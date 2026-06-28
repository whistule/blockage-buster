-- 002_cards_last_progress_at.sql
-- Adds a PROGRESS-only timestamp to cards, separate from updated_at.
--
-- Why: updated_at (migration 001) bumps on ANY change, including placing or
-- assigning a card into someone's column. Because the Us-view overlay uses the
-- most recent activity across a column's cards, that made a column look freshly
-- worked the moment a card was dropped into it — masking genuinely stale cards.
--
-- Principle: last_progress_at advances on any genuine INPUT BY THE PERSON on the
-- card or its steps — completing a step, creating a step, adding/editing a note,
-- editing the description or the 5-whys, changing urgency/mood/etc.
-- It does NOT advance on passive ROUTING/PLACEMENT:
--   * assigning / changing who a card or step belongs to
--   * moving a card between board stages
--   * reordering (sort position) / a step merely becoming the current one
--
-- Implementation note: rather than list every "progress" field (brittle as the
-- schema grows), we bump UNLESS the only things that changed are the routing
-- columns. Comparing the row as jsonb with those keys removed does this in one
-- shot and stays correct if new content fields are added later.
--
-- updated_at is left in place as the general "any change" audit field.
--
-- Run ONCE in the Supabase SQL editor. Idempotent — safe to re-run.

-- 1) Column ------------------------------------------------------------------
alter table public.cards
  add column if not exists last_progress_at timestamptz not null default now();

-- 2) Backfill ----------------------------------------------------------------
-- Seed from last recorded activity, then prefer the latest real step completion.
update public.cards
set last_progress_at = coalesce(updated_at, now());

update public.cards c
set last_progress_at = sub.ts
from (
  select card_id, max(completed_at) as ts
  from public.stages
  where completed_at is not null
  group by card_id
) sub
where sub.card_id = c.id
  and sub.ts is not null;

-- 3) Card edits ---------------------------------------------------------------
-- Replaces the updated_at touch function from migration 001: still maintains
-- updated_at on every change, and ALSO bumps last_progress_at when something
-- other than the routing columns (stage / person_id / sort_pos) changed.
create or replace function public.bb_touch_cards_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  if (to_jsonb(new) - 'stage' - 'person_id' - 'sort_pos' - 'updated_at' - 'last_progress_at')
     is distinct from
     (to_jsonb(old) - 'stage' - 'person_id' - 'sort_pos' - 'updated_at' - 'last_progress_at')
  then
    new.last_progress_at = now();
  end if;
  return new;
end;
$$;
-- (Trigger bb_cards_set_updated_at from migration 001 already calls this.)

-- 4) Step edits ---------------------------------------------------------------
-- Creating a step is progress. On update, bump unless only the routing columns
-- (person assignment / status handoff / sort order) changed — so completing a
-- step, editing a note, or renaming a step counts, but a pure reassignment or
-- "becomes the current step" handoff does not.
create or replace function public.bb_touch_card_progress()
returns trigger
language plpgsql
as $$
declare
  cid uuid;
  is_progress boolean := false;
begin
  if TG_OP = 'INSERT' then
    is_progress := true;
  elsif TG_OP = 'UPDATE' then
    is_progress := (to_jsonb(new) - 'person_id' - 'additional_people' - 'secondary_person_id' - 'status' - 'sort_order')
                   is distinct from
                   (to_jsonb(old) - 'person_id' - 'additional_people' - 'secondary_person_id' - 'status' - 'sort_order');
  end if;

  cid := coalesce(new.card_id, old.card_id);
  if is_progress and cid is not null then
    update public.cards set last_progress_at = now() where id = cid;
  end if;
  return coalesce(new, old);
end;
$$;

drop trigger if exists bb_stages_progress on public.stages;
create trigger bb_stages_progress
  after insert or update on public.stages
  for each row
  execute function public.bb_touch_card_progress();
