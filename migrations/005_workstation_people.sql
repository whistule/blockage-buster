-- 005_workstation_people.sql
-- Lets people be assigned to ("take control of") a workcentre. Stored as an
-- array of contact UUIDs on each workstation.
--
-- Run ONCE in the Supabase SQL editor. Idempotent — safe to re-run.

alter table public.workstations
  add column if not exists people uuid[] not null default '{}';
