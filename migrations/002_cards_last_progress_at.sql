-- 002_cards_last_progress_at.sql
-- Adds a PROGRESS-only timestamp to cards, separate from updated_at.
--
-- Why: updated_at (migration 001) bumps on ANY change, including placing or
-- assigning a card into someone's column. Because the Us-view overlay uses the
-- most recent activity across a column's cards, that made a column look freshly
-- worked the moment a card was dropped into it — masking genuinely stale cards.
--
-- last_progress_at only advances when a task is actually worked:
--   * a step is completed (completed_at set), OR
--   * a note is added / edited on a step.
-- It does NOT advance on: placing/assigning a card, moving it between board
-- stages, creating an empty next step, or editing card meta.
--
-- updated_at is left in place as the general "any change" audit field.
--
-- Run ONCE in the Supabase SQL editor. Idempotent — safe to re-run.

-- 1) Column ------------------------------------------------------------------
alter table public.cards
  add column if not exists last_progress_at timestamptz not null default now();

-- 2) Backfill ----------------------------------------------------------------
-- Start everyone from their last recorded activity (updated_at)...
update public.cards
set last_progress_at = coalesce(updated_at, now());

-- ...then, for cards that have a completed step, use the latest completion
-- (that is real progress).
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

-- 3) Trigger function --------------------------------------------------------
-- Bump the parent card's last_progress_at only on genuine progress.
create or replace function public.bb_touch_card_progress()
returns trigger
language plpgsql
as $$
declare
  is_progress boolean := false;
begin
  if TG_OP = 'INSERT' then
    -- A step logged as already done, or created with a note, is recorded progress.
    is_progress := (new.completed_at is not null)
                or (new.notes is not null and btrim(new.notes) <> '');
  elsif TG_OP = 'UPDATE' then
    -- Completing a step, or adding/editing its note, is progress.
    is_progress := (new.completed_at is distinct from old.completed_at)
                or (new.notes is distinct from old.notes);
  end if;

  if is_progress and new.card_id is not null then
    update public.cards set last_progress_at = now() where id = new.card_id;
  end if;
  return new;
end;
$$;

-- 4) Trigger -----------------------------------------------------------------
drop trigger if exists bb_stages_progress on public.stages;
create trigger bb_stages_progress
  after insert or update on public.stages
  for each row
  execute function public.bb_touch_card_progress();
