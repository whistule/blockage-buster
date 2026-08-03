-- 004_workstations.sql
-- Adds "workstations" (workcentres) — an ordered list of process stations — and
-- lets each card be assigned to one. Powers the settings popup, the card edit
-- dropdown, and the "Workstation" board view.
--
-- Run ONCE in the Supabase SQL editor. Idempotent — safe to re-run.

-- 1) The ordered list of workcentres.
create table if not exists public.workstations (
  id       uuid primary key default gen_random_uuid(),
  name     text not null,
  position int  not null default 0
);

-- 2) A card's assigned workstation (nulled if the workstation is deleted).
alter table public.cards
  add column if not exists workstation_id uuid references public.workstations(id) on delete set null;

-- 3) Assigning a workstation is categorisation, not "progress" — exclude it from
-- the last_progress_at bump (alongside stage / person_id / sort_pos / watchers).
create or replace function public.bb_touch_cards_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  if (to_jsonb(new) - 'stage' - 'person_id' - 'sort_pos' - 'watchers' - 'workstation_id' - 'updated_at' - 'last_progress_at')
     is distinct from
     (to_jsonb(old) - 'stage' - 'person_id' - 'sort_pos' - 'watchers' - 'workstation_id' - 'updated_at' - 'last_progress_at')
  then
    new.last_progress_at = now();
  end if;
  return new;
end;
$$;
