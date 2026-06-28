-- 001_cards_updated_at.sql
-- Adds a real "last updated" timestamp to cards, kept current by triggers on
-- BOTH `cards` and `stages`, so ANY change (card edit, card move, note edit,
-- step added/completed/renamed/deleted) refreshes it. This drives the
-- per-person staleness overlay on the "Us" screen.
--
-- Run this ONCE in the Supabase SQL editor (Dashboard -> SQL Editor -> New query).
-- It is idempotent — safe to re-run.
--
-- Order matters: add the column, BACKFILL from existing stage timestamps,
-- THEN install the triggers (so the backfill isn't overwritten by the
-- "set updated_at = now()" trigger).

-- 1) Column ------------------------------------------------------------------
alter table public.cards
  add column if not exists updated_at timestamptz not null default now();

-- 2) Backfill ----------------------------------------------------------------
-- Seed each card's updated_at from the most recent activity we can infer from
-- its steps, so columns don't all reset to "fresh" the moment this runs.
-- Cards with no step timestamps keep the column default (now()).
update public.cards c
set updated_at = sub.ts
from (
  select card_id, max(t) as ts
  from (
    select card_id, created_at   as t from public.stages where created_at   is not null
    union all
    select card_id, completed_at as t from public.stages where completed_at is not null
  ) x
  group by card_id
) sub
where sub.card_id = c.id
  and sub.ts is not null;

-- 3) Trigger functions -------------------------------------------------------
-- 3a) Touch a card's own updated_at whenever the card row itself changes.
create or replace function public.bb_touch_cards_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- 3b) Touch the PARENT card's updated_at whenever one of its steps changes.
--     Handles insert/update/delete (OLD is null on insert, NEW is null on delete).
create or replace function public.bb_touch_card_from_stage()
returns trigger
language plpgsql
as $$
declare
  cid uuid;
begin
  cid := coalesce(new.card_id, old.card_id);
  if cid is not null then
    update public.cards set updated_at = now() where id = cid;
  end if;
  return coalesce(new, old);
end;
$$;

-- 4) Triggers ----------------------------------------------------------------
drop trigger if exists bb_cards_set_updated_at on public.cards;
create trigger bb_cards_set_updated_at
  before update on public.cards
  for each row
  execute function public.bb_touch_cards_updated_at();

drop trigger if exists bb_stages_touch_card on public.stages;
create trigger bb_stages_touch_card
  after insert or update or delete on public.stages
  for each row
  execute function public.bb_touch_card_from_stage();

-- Note: the stages trigger issues `update cards ...`, which fires the cards
-- BEFORE UPDATE trigger above. That just re-sets updated_at = now() (idempotent)
-- and does NOT loop, because updating a card never writes back to stages.
