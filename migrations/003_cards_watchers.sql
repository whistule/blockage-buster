-- 003_cards_watchers.sql
-- Adds card-level "watchers": internal people who want a card to appear in
-- their Us column even when the current action isn't with them. Works like the
-- per-action "Also relevant to" option, but at the card level.
--
-- Run ONCE in the Supabase SQL editor. Idempotent — safe to re-run.

-- 1) Column: an array of contact UUIDs.
alter table public.cards
  add column if not exists watchers uuid[] not null default '{}';

-- 2) Keep watcher changes from counting as "progress".
-- Changing who watches a card is routing/administration, not working the task,
-- so add 'watchers' to the columns excluded from the last_progress_at bump
-- (alongside stage / person_id / sort_pos). Replaces the function from 002.
create or replace function public.bb_touch_cards_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  if (to_jsonb(new) - 'stage' - 'person_id' - 'sort_pos' - 'watchers' - 'updated_at' - 'last_progress_at')
     is distinct from
     (to_jsonb(old) - 'stage' - 'person_id' - 'sort_pos' - 'watchers' - 'updated_at' - 'last_progress_at')
  then
    new.last_progress_at = now();
  end if;
  return new;
end;
$$;
-- (Trigger bb_cards_set_updated_at from migration 001 already calls this function.)
