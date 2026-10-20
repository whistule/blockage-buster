-- 006_shared_team.sql
-- One team list for Blockage Buster AND Reg-Ops: the internal people in
-- `contacts`. Adding or removing someone in either app changes both.
--
--   initial  Reg-Ops' short key for the person ("M", "D"...). Reg-Ops stores
--            completions and working days by it, so it must never change
--            or be reused.
--   active   false = they've left. Hidden in both apps, but the row stays
--            so past completions still show their name and colour.
--            Replaces Blockage Buster's hardcoded HIDDEN_INTERNAL_NAMES.
--
-- Also creates regop_config, where Reg-Ops keeps its task assignments.
--
-- Access rules (RLS policies) are NOT in this file: Reg-Ops needs to update
-- contacts and read/write regop_config from the browser, so set those up to
-- match how the other tables are secured.
--
-- Run ONCE in the Supabase SQL editor. Idempotent — safe to re-run.

alter table public.contacts
  add column if not exists initial text,
  add column if not exists active  boolean not null default true;

create unique index if not exists contacts_initial_key
  on public.contacts (initial) where initial is not null;

-- Existing team, using the initials Reg-Ops already has on record
update public.contacts set initial = 'R' where type = 'internal' and name = 'Ronnie' and initial is null;
update public.contacts set initial = 'E' where type = 'internal' and name = 'Ewen'   and initial is null;
update public.contacts set initial = 'H' where type = 'internal' and name = 'Helena' and initial is null;
update public.contacts set initial = 'D' where type = 'internal' and name = 'Dillon' and initial is null;
update public.contacts set initial = 'M' where type = 'internal' and name = 'Misha'  and initial is null;
-- Ben has left: keep his initial so his old ticks keep his colour
update public.contacts set initial = 'B', active = false where type = 'internal' and name = 'Ben';

-- Reg-Ops task assignments
create table if not exists public.regop_config (
  key        text primary key,
  value      jsonb not null,
  updated_at timestamptz not null default now()
);
