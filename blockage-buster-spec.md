# Blockage Buster — Kanban Board Spec

## Purpose

A kanban board screen for tracking issues and blockages across the club's admin/operational workflow. Each card represents something that's stuck — a delayed approval, a missing document, a broken process — and shows at a glance what it is, where it's stuck, and who owns it.

---

## Kanban Columns

### Default columns

| Column | Meaning |
|--------|---------|
| **Flagged** | Issue identified but not yet picked up |
| **On Us** | In progress — ball is in our court |
| **On Them** | In progress — waiting for someone external to act |
| **Resolved** | Done, kept visible briefly for reference |

Cards move left-to-right through columns. Tap a card to open its detail view.

### Custom columns

Users can add their own columns to the kanban. Tap **"+ Column"** (shown as a tab at the end of the tab bar) to create a new one.

Adding a column requires:
- **Column name** — free text (e.g. "Parked", "Needs Budget", "Committee Review")
- **Position** — where it sits in the tab order (between any two existing columns, but Flagged is always first and Resolved is always last)
- **Colour** — pick from the existing palette for the left-border colour on cards in that column

Custom columns behave the same as the defaults — cards can be moved into them, they appear as tabs, and they show a count badge. Custom columns do NOT have the sub-kanban person grouping that On Us and On Them have (those are special).

Custom columns can be renamed, reordered, or deleted (cards in a deleted column move back to Flagged).

---

## Card Design

Each card shows four pieces of information:

```
+-------------------------------+
|  #007        [Urgent LED]     |
|  TITLE OF ISSUE               |
|  Brief description excerpt    |
|  that wraps to two lines...   |
|                               |
|  Stage: [Current stage name]  |
|  Stuck with: [Person name]    |
+-------------------------------+
```

### Card fields

| Field | Description | Example |
|-------|-------------|---------|
| **Buster number** | 3-digit auto-assigned ID, shown top-left of the card. Prefixed with `#`. Auto-increments from 001. Used for quick verbal/written reference — "Buster 003", "Buster 113". | `#003`, `#113` |
| **Urgency** | LED indicator, top-right of the card | Urgent (red), High (orange), Medium (green), Low (grey) |
| **Title** | Short name for the blockage | "River risk assessment overdue" |
| **Description excerpt** | 1–2 line summary, truncated with ellipsis | "The RA for the Grade 3 Tay trip hasn't been submitted yet and the trip is in..." |
| **Current stage** | The name of the stage it's currently at (from the stages list) | "Submit completed RA" |
| **Stuck with** | The person assigned to the current stage — updates automatically as stages are completed | "Jamie M." |

**"Stuck with" is always derived from the current stage.** You never set it directly on the card — you assign people to stages, and the card reflects whoever owns the active one. This is also what determines which sub-tab the card appears under in On Us / On Them.

### Urgency levels

Set when creating a card, changeable at any time from the detail view.

| Level | Colour | Pill background | Use for |
|-------|--------|-----------------|---------|
| **Urgent** | `--red` (#8a1a1a) | `--red-pale` (#fde8e8) | Deadline imminent, safety issue, or blocking other people right now |
| **High** | `--amber` (#c4622d) | `--amber-pale` (#f5e0d6) | Needs attention this week |
| **Medium** | `--forest-mid` (#3d6640) | `--forest-pale` (#e4ede4) | On the radar, no immediate pressure |
| **Low** | `--stone` (#7a8a78) | `--snow` (#f4f5f2) | Nice to resolve, no deadline |

Visual treatment:
- Urgency pill sits top-right of the card, before the title
- Pill: rounded, small (0.75rem text, 4px 10px padding), background + text colour from table above
- **Urgent cards also get a red left border** that overrides the column colour — so urgent items are instantly visible regardless of which column they're in
- Within a column, cards are sorted by urgency (Urgent at top, Low at bottom)

### Card visual treatment

- White card on `--snow` (#f4f5f2) column background
- Subtle left border colour per column:
  - Flagged: `--stone` (#7a8a78)
  - On Us: `--forest-mid` (#3d6640)
  - On Them: `--amber` (#c4622d)
  - Resolved: `--sea-b` (#0098a0)
- Title: **Plus Jakarta Sans 600**, 1rem
- Description: Plus Jakarta Sans 400, 0.9rem, `--stone` colour, max 2 lines with ellipsis
- "Stuck at" / "Stuck with" labels: Plus Jakarta Sans 500, 0.85rem, `--peat`
- Card padding: 14px 16px
- Card gap within column: 10px
- Border radius: 10px
- Subtle box-shadow: `0 1px 3px rgba(0,0,0,0.06)`

---

## Column Layout

### Top-level tabs

Horizontal tab bar with four tabs: **Flagged** · **On Us** · **On Them** · **Resolved**. Each tab shows column name + card count badge.

**Flagged** and **Resolved** work as simple card lists — tap a tab, see cards stacked vertically.

**On Us** and **On Them** are expandable — tapping one of these tabs reveals a second-level view grouped by person.

---

### On Us — sub-kanban by team member

When you tap the **On Us** tab you don't see a flat list of cards. Instead you see person columns — one per club member who currently owns a blockage.

```
+-----------------------------------+
|  Flagged | [ON US] | On Them | Res|
+-----------------------------------+
|  Dillon (2)  Helan (1)  Misha (3)|
+-----------------------------------+
|                                   |
|  Cards for the selected person    |
|  stacked vertically               |
|                                   |
+-----------------------------------+
```

- A second row of tabs appears below the main tab bar, one per person
- Each person tab shows their name + count badge (e.g. "Dillon (2)")
- Tap a person tab to see only their cards
- First person tab is selected by default
- Person tabs scroll horizontally if there are many people
- Cards within a person column use the same card design as the main kanban, but the "Stuck with" field is hidden (redundant — you already know who)

**Sample people for On Us:**
- **Dillon** (2 cards) — Insurance renewal, Equipment audit follow-up
- **Helan** (1 card) — Committee minutes backlog
- **Misha** (2 cards) — Website event calendar sync, New member welcome packs

### On Them — sub-kanban by external party

Same pattern as On Us, but the person tabs represent external parties, contractors, suppliers, or organisations that we're waiting on.

```
+-----------------------------------+
|  Flagged | On Us | [ON THEM] | Res|
+-----------------------------------+
|  BC Scotland (2)  Pinkston (1)   |
|  Jamie M. (1)                     |
+-----------------------------------+
|                                   |
|  Cards for the selected party     |
|                                   |
+-----------------------------------+
```

- Same second-row tab pattern — one tab per external party/person
- These are anyone outside the core team: BC Scotland, Pinkston staff, individual leaders who haven't delivered, external suppliers, etc.
- "Stuck with" is also hidden on these cards (the person tab already tells you)

**Sample parties for On Them:**
- **BC Scotland** (2 cards) — Qualification verification, Coaching grant application
- **Pinkston** (1 card) — Summer session pricing
- **Jamie M.** (1 card) — River risk assessment

### Visual treatment for sub-tabs

- Sub-tabs sit directly below the main tab bar with no gap — feels like a drill-down
- Sub-tab background: `--white`
- Active sub-tab: bold text, `--forest-mid` underline (On Us) or `--amber` underline (On Them) — matches the parent column colour
- Inactive sub-tab: `--stone` text, no underline
- Sub-tab font: Plus Jakarta Sans 500, 0.85rem
- Count badge: same style as main tabs but smaller
- Horizontal scroll with no scrollbar visible (overflow-x: auto, hidden scrollbar)

---

## Top Bar

Standard OtterPool topbar:
- Back arrow (left) if navigated from another screen
- Title: "Blockage Buster"
- No right-side action for now (future: + Add Issue button)

---

## Sample Data (for prototype)

### Flagged (2)
1. **#001** [High] **"Expired first aid certs"** — "Three leaders have first aid certificates expiring before the summer season starts in..." — Stuck at: Cert renewal — Stuck with: Committee
2. **#002** [Medium] **"Missing trip reports"** — "Four trip reports from March are still outstanding, blocking experience tallies for..." — Stuck at: Post-trip submission — Stuck with: Various leaders

### On Us (5) — grouped by person

**Dillon (2):**
3. **#003** [High] **"Insurance renewal paperwork"** — "Annual club insurance renewal documents need to be submitted to SCA by end of..." — Stuck at: SCA submission
4. **#004** [Low] **"Equipment audit follow-up"** — "Audit spreadsheet needs updating with the new boats purchased in February before..." — Stuck at: Inventory update

**Helan (1):**
5. **#005** [Low] **"Committee minutes backlog"** — "Minutes from the last two committee meetings haven't been circulated yet, several..." — Stuck at: Minutes write-up

**Misha (2):**
6. **#006** [Medium] **"Website event calendar sync"** — "The public website calendar is out of sync with the OtterPool calendar, some April..." — Stuck at: Website update
7. **#007** [Medium] **"New member welcome packs"** — "Six new members from the spring intake haven't received their welcome packs with..." — Stuck at: Pack assembly

### On Them (4) — grouped by external party

**BC Scotland (2):**
8. **#008** [Medium] **"BC qualification verification"** — "Two new members submitted BC qualification evidence three weeks ago but haven't..." — Stuck at: BC verification
9. **#009** [Low] **"Coaching grant application"** — "The grant application for coaching bursaries was submitted in February but we've..." — Stuck at: Grant review

**Pinkston (1):**
10. **#010** [High] **"Summer session pricing"** — "We need the confirmed pricing for the summer block before we can publish the..." — Stuck at: Pricing confirmation

**Jamie M. (1):**
11. **#011** [Urgent] **"River risk assessment overdue"** — "The RA for the Grade 3 Tay trip hasn't been submitted yet and the trip is in..." — Stuck at: Leader approval

### Resolved (1)
12. **#012** **"Pinkston booking confirmed"** — "Summer block booking at Pinkston was held up waiting for the new pricing schedule..." — Stuck at: Venue booking — Stuck with: Pinkston staff

---

## Card Detail View

Tapping a card opens a full-screen detail view with back navigation to the kanban board.

### Top Bar
- Back arrow → returns to kanban board (same column tab)
- Title: card title
- Status pill in topbar-right area showing current column (colour-coded)

### Key concept: current person drives the kanban

The person shown on the kanban card ("Stuck with") is always the person who owns the **current stage**. When a stage is completed and the next stage begins, the card's "Stuck with" automatically updates to whoever is assigned to that next stage. This also determines which sub-tab the card appears under in the On Us / On Them views.

### Detail Layout

```
+-----------------------------------+
|  <- River risk assessment overdue |
|                        [On Them]  |
+-----------------------------------+
|                                   |
|  DESCRIPTION                      |
|  Full description text, no        |
|  truncation. Can be multiple      |
|  paragraphs.                      |
|                                   |
+-----------------------------------+
|                                   |
|  STAGES                           |
|                                   |
|  Completed stages (history)       |
|  -------------------------------- |
|  o  28 Mar — Identify missing RA  |
|  |  Sarah K.                      |
|  |  "Noticed during trip planning |
|  |   that the RA is missing"      |
|  |                                |
|  o  30 Mar — Chase Jamie          |
|  |  Helan                         |
|  |  "Emailed Jamie with the       |
|  |   template and deadline"       |
|  |                                |
|  Current stage                    |
|  -------------------------------- |
|  *  Jamie M.  ← NOW              |
|  |  "Submit completed RA"         |
|  |                                |
|  Remaining stages                 |
|  -------------------------------- |
|  o  — Review submitted RA         |
|  |  Dillon                        |
|  |                                |
|  o  — Upload to trip record       |
|     Sarah K.                      |
|                                   |
|  [+ Add stage]                    |
|                                   |
+-----------------------------------+
```

### Stages — the single timeline

Each blockage has one unified list of **stages** — steps it must pass through to reach resolution. Stages are added manually when the blockage is created or at any point during its life. The timeline shows three zones:

#### Completed stages (history)
Stages that are done. Each shows:

| Field | Description |
|-------|-------------|
| **Date completed** | When this stage was finished (e.g. "28 Mar") |
| **Stage name** | What was done (e.g. "Identify missing RA", "Chase Jamie") |
| **Person** | Who completed it |
| **Notes** | One or more notes — can be added at completion or at any time after. Each note is timestamped. |
| **Links** | URLs to emails, documents, spreadsheets, supplier pages, etc. Each link has a label + URL. Links with Open Graph images show a preview thumbnail. |
| **Images** | Photos or screenshots attached directly — e.g. photo of equipment ordered, screenshot of a confirmation, image of a document. |

Notes, links, and images can be added to any stage at any point (not just at completion). Tap a completed stage to expand it and see/add attachments.

#### Current stage (now)
The stage currently in progress. Highlighted with a filled circle and a "NOW" label. The **person** assigned to this stage is the one shown on the kanban card as "Stuck with" — and determines which sub-tab the card sits under.

| Field | Description |
|-------|-------------|
| **Stage name** | What needs to happen now |
| **Person** | Who it's currently sitting with — drives the kanban card display |
| **Notes** | Can add notes while in progress (e.g. "Chased again by phone") |
| **Links** | Can attach links while in progress (e.g. link to an email thread). Shows preview image if available. |
| **Images** | Can attach photos/screenshots (e.g. photo of item ordered, screenshot of supplier confirmation) |

#### Remaining stages (upcoming)
Stages that haven't started yet. Shown greyed out below the current stage. Each has a name and an assigned person, but no date (not done yet). Notes and links can be pre-added here too (e.g. "Here's the template they'll need" with a link).

| Field | Description |
|-------|-------------|
| **Stage name** | What needs to happen |
| **Person** | Who will own it when the time comes |
| **Notes** | Optional — prep notes for this stage |
| **Links** | Optional — resources needed for this stage. Shows preview image if available. |
| **Images** | Optional — reference images for this stage |

### Adding a stage

Tap **"+ Add stage"** at the bottom of the timeline to append a new upcoming stage.

Adding a stage requires:
- **Stage name** — free text input (e.g. "Get committee sign-off")
- **Assigned to** — person picker:
  - If internal (club member): picked from the member directory
  - If external: uses the contacts library with autocomplete (see Contacts Library section)

New stages are always added to the end of the remaining stages list. Stages can be reordered by long-press drag (future — not in prototype).

### Completing a stage

Tap the current stage to mark it complete. This:
1. Prompts for an optional note (what happened?)
2. Stamps today's date on the completed stage
3. Advances the "current" marker to the next stage
4. Updates the kanban card's "Stuck with" to the next stage's person
5. If no remaining stages → card moves to **Resolved**

### Visual treatment

- Vertical line on the left connecting all stages
- **Completed stages:** outlined circle, `--forest-mid` line colour, full opacity
- **Current stage:** filled circle, `--amber` colour, "NOW" pill beside the person name
- **Remaining stages:** outlined circle, `--stone-lt` line colour, 60% opacity text
- Date (completed only): Plus Jakarta Sans 600, 0.85rem, `--peat`
- Stage name: Plus Jakarta Sans 500, 0.95rem
- Person name: Plus Jakarta Sans 400, 0.85rem, `--stone`
- Notes: Plus Jakarta Sans 400, 0.85rem, italic, `--peat`. Each note prefixed with a small timestamp (e.g. "30 Mar —"). Multiple notes stack vertically.
- Links: Plus Jakarta Sans 500, 0.85rem, `--forest-mid` colour, underlined. Shown as tappable label text (e.g. "RA template (Google Doc)"). Link icon (small chain/external icon) before the label. If the link target has an Open Graph image or preview thumbnail, it's shown as a small preview card (60px tall, full width, rounded corners, image left + label right). Falls back to text-only link if no preview is available.
- Images: Photos or screenshots attached directly to a stage. Shown as thumbnails (full-width, max 160px tall, rounded corners, tap to view full size). Useful for things like photos of ordered equipment, screenshots of confirmations, etc.
- "+ Add note", "+ Add link", and "+ Add image" buttons appear when a stage is expanded: text-only, `--stone` colour, Plus Jakarta Sans 400, 0.85rem. Image upload accepts camera or photo library.
- "+ Add stage" button: text-only, `--forest-mid` colour, Plus Jakarta Sans 500

### Sample Detail — "River risk assessment overdue" (On Them)

**Description:** The risk assessment for the Grade 3 Tay trip hasn't been submitted yet. The trip is scheduled for 19 April and we need the RA at least 5 days in advance per club policy. Jamie took responsibility for it at the last committee meeting but hasn't submitted yet.

**Completed stages:**
1. 28 Mar — **Identify missing RA** — Sarah K.
   - Note (28 Mar): "Noticed during trip planning that the RA is missing"
   - Link: "Club RA policy (Google Doc)"
2. 30 Mar — **Email Jamie with template** — Helan
   - Note (30 Mar): "Sent the template and the 14 Apr deadline"
   - Note (2 Apr): "Chased again by phone, Jamie says he's on it"
   - Link: "RA template (Google Doc)"
   - Link: "Email thread with Jamie (Gmail)"

**Current stage:**
3. **Submit completed RA** — Jamie M. ← NOW
   - Note (4 Apr): "Jamie confirmed he'll have it done by weekend"
   - Image: screenshot of Jamie's WhatsApp confirmation

**Remaining stages:**
4. **Review submitted RA** — Dillon
   - Link: "RA review checklist (Google Doc)"
5. **Upload signed RA to trip record** — Sarah K.

Kanban card shows: Stuck with **Jamie M.** → appears under **On Them → Jamie M.** sub-tab.
When Jamie completes his stage, it shifts to Dillon → moves to **On Us → Dillon** sub-tab.

### Sample Detail — "Pinkston booking confirmed" (Resolved)

**Description:** The summer block booking at Pinkston was held up waiting for the new pricing schedule from the venue. We need the booking confirmed before we can publish the summer Tuesday evening calendar.

**All stages completed:**
1. 10 Mar — **Request pricing from Pinkston** — Treasurer
   - Note (10 Mar): "Emailed venue for new season rates"
   - Link: "Email to Pinkston (Gmail)"
2. 15 Mar — **Provide updated pricing** — Pinkston
   - Note (15 Mar): "Received new rates, 8% increase on last year"
   - Link: "Pinkston 2026 price list (PDF)"
3. 20 Mar — **Get committee approval for increase** — Treasurer
   - Note (20 Mar): "Approved at committee meeting, unanimous"
   - Link: "Committee meeting minutes (Google Doc)"
4. 24 Mar — **Send signed booking form** — Treasurer
   - Note (24 Mar): "Posted signed form to Pinkston"
5. 1 Apr — **Confirm booking receipt** — Pinkston
   - Note (1 Apr): "Booking confirmed, summer slots secured"
   - Link: "Booking confirmation email (Gmail)"

All stages done → card in **Resolved** column.

---

## Contacts Library (autocomplete)

When assigning a blockage to an external party (the "Stuck with" field for On Them cards), the system maintains a **contacts library** that learns over time.

### How it works

1. **First time** you type an external name (e.g. "BC Scotland"), it's saved to the library
2. **Next time** you start typing "BC...", the library suggests "BC Scotland" as an autocomplete match
3. The library is shared across all blockage cards — anyone creating or editing a card benefits from names already entered

### What's stored per contact

| Field | Description | Example |
|-------|-------------|---------|
| **Name** | Person or organisation name | "BC Scotland" |
| **Type** | `person` or `organisation` | organisation |
| **Last used** | Date last assigned to a card | 2 Apr 2026 |

### Input behaviour

- Text input with dropdown suggestions appearing after 1+ characters typed
- Suggestions filtered by what's typed, sorted by most recently used
- Tap a suggestion to select it, or keep typing to add a new entry
- New entries are automatically saved to the library on card save
- No separate "manage contacts" screen needed — the library builds itself through use

### Visual treatment

- Input field: standard OtterPool text input styling
- Dropdown: white card below input, `--border` outline, max 5 suggestions visible, scrollable
- Each suggestion row: name on left, type pill on right (`person` / `org`), 44px row height for easy tap targets
- Highlight on matching characters: **bold** the portion that matches what's typed

### Applies to

- "Stuck with" field when creating/editing a card destined for **On Them**
- "By" field when adding a history entry (for external actors)
- Does NOT apply to On Us — those columns use the club member list directly (pulled from the existing admin member directory)

### Seed data (for prototype)

The library comes pre-populated with:
- BC Scotland (organisation)
- Pinkston (organisation)
- SCA (organisation)
- Jamie M. (person)
- Highland Council (organisation)
- Tiso (organisation)

---

## Reminders

Reminders can be set on any card to nudge the person it's currently stuck with.

### Setting a reminder

From the card detail view, tap **"Set reminder"** (below the stages timeline). A reminder requires:

| Field | Description |
|-------|-------------|
| **When** | Date and time the reminder fires. Preset options: "Tomorrow", "In 3 days", "Next Monday", "Custom date" |
| **Message** | Pre-filled with a sensible default (e.g. "Buster #011 — River risk assessment overdue — is waiting on you") but editable |
| **Who** | Defaults to the person assigned to the current stage. Can be changed to anyone (club member or external contact) |

Multiple reminders can be set per card. Upcoming reminders are shown on the detail view as a list below the stages.

### Reminder display on the card

Cards with an upcoming reminder show a small bell icon beside the buster number on the kanban view — so you can see at a glance which blockages have chasers set.

### Delivery method — WhatsApp Business API

A reminder that doesn't send itself isn't a reminder. The message needs to arrive automatically in the recipient's WhatsApp without anyone pressing send.

This requires the **WhatsApp Business API**, accessed through a provider like Twilio, MessageBird, or the Meta Cloud API directly.

**What's needed to set this up:**
1. A **Meta Business account** (free)
2. A **WhatsApp Business profile** for the club (free — uses a dedicated phone number)
3. An **API provider** account (e.g. Twilio) to handle sending
4. **Message templates** — pre-approved by Meta. Reminder messages need to follow a template (e.g. "Hi {{name}}, Buster #{{number}} — {{title}} — is waiting on you. {{message}}")
5. **Phone numbers** stored in the contacts library for each person/organisation

**Cost:** Roughly 3–5p per message (UK utility-category messages via Twilio). For a club sending maybe 20–30 reminders a month, that's under 2 quid.

**Contacts library update:** The contacts library needs a **phone number** field alongside name and type. For club members, this can be pulled from their profile. For external contacts, it's entered when the contact is first added.

**Fallback for external contacts without WhatsApp:** If a phone number isn't available or the contact doesn't use WhatsApp, fall back to **email**. The contacts library should store an optional email address too. The reminder form shows which channel will be used based on what's available for that contact.

### Alternative / additional channel — Calendar invite

A **Google Calendar event** sent as a reminder is another strong option:
- Lands as a notification on their phone at the exact time — no app install needed
- Free, no API approval, works with any email address
- The calendar event title is the reminder (e.g. "Buster #011 — River RA due")
- The event description contains the full context: blockage title, current stage, who's waiting, and a link back to the card in OtterPool
- Can include a built-in calendar reminder (e.g. popup 30 mins before)

**This could work as:**
- The **primary method** — simpler to implement than WhatsApp, no cost, no Meta approvals
- A **complement to WhatsApp** — WhatsApp for the nudge message, calendar for the scheduled reminder that sits in their diary

The reminder form could offer both: "Send WhatsApp now" and/or "Add to their calendar on [date]".

### Recommended approach

| Channel | When to use | Setup effort |
|---------|-------------|-------------|
| **Calendar invite** | Scheduled reminders with a specific date — "remind Jamie on Friday" | Low — Google Calendar API (already used in OtterPool) |
| **WhatsApp** | Immediate nudges — "chase Jamie now about Buster 011" | Medium — Business API + template approval |
| **Email** | Fallback when no phone number or external orgs | Low — Supabase email |

Start with **calendar invites** for the MVP — they're the easiest to implement and the most reliable for scheduled reminders. Add WhatsApp later for immediate chasers.

**For the prototype:** Reminders are fully designed in the UI (set date, recipient, message, see upcoming reminders, bell icon on cards) but the actual sending is mocked — a toast notification shows "Reminder sent to Jamie M." to demonstrate the flow. Real sending is wired up when the backend is built.

### Reminder visual treatment

- "Set reminder" button: Night Watchman button style with a yellow rectangular indicator
- Reminder list on detail view: each row shows date, recipient, message preview, and a delete (x) button
- Bell icon on kanban card: `0.7rem`, `color: #6b7280`, sits beside the buster number

---

## Interaction (prototype scope)

- Tap top-level tabs to switch between Flagged / On Us / On Them / Resolved
- On Us and On Them tabs reveal sub-tabs grouped by person/party
- Tap a card to open its detail view
- Back arrow in detail view returns to kanban (same column + sub-tab)
- Subtask checkboxes are interactive (toggle on tap)
- Contacts library autocomplete works on the "Stuck with" input
- Cards and history entries are static (no add/edit in prototype beyond checkboxes)
- Future: add new cards, edit descriptions, add history notes, drag between columns

---

## Screen ID

`blockage-buster` — added to the `screenData` object and accessible from the home dashboard under the Admin/Web Dev role view.

---

## Visual Style — "Night Watchman" inspired

The Blockage Buster takes its visual language from the mk Night Watchman dashboard (`EMCO_E25_Home_WithCamera_v3.ino`). This is deliberately different from the rest of OtterPool's nature-themed screens — the Blockage Buster is an operational tool, not a member-facing screen, so it should feel like a workshop dashboard.

### Reference values from Night Watchman CSS

```
Background:      #f5f7fa
Panel bg:        #f3f4f6
Card/inset bg:   white (#ffffff)
Border:          1px solid #e5e7eb
Panel border:    1px solid #9ca3af
Text primary:    #4b5563
Text secondary:  #6b7280
Heading red:     #e20e0c
Font:            Oswald (we substitute Plus Jakarta Sans)
Uppercase:       text-transform: uppercase; letter-spacing: 0.05em
Button:          white bg, 1px solid #9ca3af, shadow: 1px 1px 2px rgba(0,0,0,0.1)
Btn indicator:   1.25rem × 2.5rem, 1px solid #6b7280, inset shadow
LED:             1.5rem, border-radius: 50%, 1px solid #6b7280, gradient fill
```

### How we apply it to Blockage Buster

#### Page background
- `#f5f7fa` — the exact Night Watchman background (cooler than OtterPool's `--snow`)
- This is the only OtterPool screen that uses this background

#### Cards / panels
- Outer panel: `background: #f3f4f6`, `box-shadow: -1px 1px 2px rgba(0,0,0,0.06)` — matches `.panel`
- Inset cards (individual blockage cards): `background: white`, `border: 1px solid #d1d5db`, `box-shadow: inset 1px 1px 2px rgba(0,0,0,0.06)` — matches `.status-panel`
- No border-radius (Night Watchman uses none — square/sharp edges throughout)

#### Typography
- **Section headings** (e.g. "STAGES", "HISTORY", column headers): `text-transform: uppercase`, Plus Jakarta Sans 600, `0.875rem`, `letter-spacing: 0.05em`, `color: #6b7280`. Followed by `<hr>` with `border-top: 1px solid #9ca3af` — matches `.panel h3` + `.panel hr`
- **Card titles**: Plus Jakarta Sans 600, 1.05rem, `color: #4b5563`, normal case
- **Body text / descriptions**: Plus Jakarta Sans 400, 0.9rem, `color: #4b5563`
- **Labels** ("Stage:", "Stuck with:"): `text-transform: uppercase`, Plus Jakarta Sans 500, `0.75rem`, `color: #6b7280`, `letter-spacing: 0.05em` — matches `.timer-input label` / `.status-title`
- **Values** beside labels: Plus Jakarta Sans 500, 0.9rem, `color: #4b5563`, normal case

#### LED status indicators
Replicate the Night Watchman's gradient LED circles for urgency and stage status:
- Size: `1.5rem` (24px), `border-radius: 50%`, `border: 1px solid #6b7280`
- Shadow: `inset 0 -2px 4px rgba(0,0,0,0.2), inset 0 2px 4px rgba(255,255,255,0.3)`
- **Urgent (red):** `background: linear-gradient(135deg, #fca5a5 0%, #dc2626 100%)`
- **High (orange):** `background: linear-gradient(135deg, #fdba74 0%, #ea580c 100%)`
- **Medium (green):** `background: linear-gradient(135deg, #86efac 0%, #16a34a 100%)`
- **Low (off/grey):** `background: linear-gradient(135deg, #f9fafb 0%, #e5e7eb 100%)`
- Used beside card titles (urgency) and in the stage timeline (stage status)

#### Buttons
Directly from Night Watchman `.btn` + `.btn-indicator`:
- `background: white`, `border: 1px solid #9ca3af`, `box-shadow: 1px 1px 2px rgba(0,0,0,0.1)`
- `text-transform: uppercase`, Plus Jakarta Sans 600, `1.125rem`
- Coloured **rectangular indicator** to the left of text: `width: 1.25rem`, `height: 2.5rem`, `border: 1px solid #6b7280`, `box-shadow: inset 1px 1px 2px rgba(0,0,0,0.2)`
  - `.green`: `background: #84cc16` — positive actions (complete stage, add card)
  - `.yellow`: `background: #facc15` — caution actions (move column, park)
  - `.red`: `background: #ef4444` — destructive/urgent actions (delete, escalate)
- Hover: `background: #f9fafb`. Active: `background: #e5e7eb`
- Min 44px height for touch targets

#### Urgency system on cards
The urgency indicator on each kanban card uses the LED circle (not a pill):
- LED sits top-right of the card, same gradient styling as above
- Urgent cards also get a left border override: `3px solid #ef4444`
- Within a column, cards sort by urgency (Urgent at top)

#### Tab bar
- Tabs sit in a panel strip with `background: #f3f4f6`, same border treatment
- Active tab: `color: #4b5563`, `border-bottom: 2px solid` in the column colour
- Inactive tab: `color: #6b7280`, no bottom border
- Tab text: `text-transform: uppercase`, Plus Jakarta Sans 600, `0.75rem`, `letter-spacing: 0.05em`
- Count badge: small rounded pill, column colour background, white text

#### Timeline (stages)
- Vertical line: `1px solid #e5e7eb` (matches card borders)
- Circle nodes: LED-style, `1.5rem`, gradient fill for completed/current, grey-off for upcoming
- The timeline sits inside a panel with the section heading "STAGES" in uppercase

#### State display
For the current column status shown on the detail view, use the Night Watchman state display:
- `background: #1f2937`, `color: #10b981`, `text-transform: uppercase`, `letter-spacing: 0.05em`, `border-radius: 3px`
- Shows the current column name (e.g. "ON THEM") as a dark chip with green text

#### Overall feel
- Functional, not decorative — workshop dashboard aesthetic
- Cool grey tones (`#f5f7fa`, `#f3f4f6`, `#e5e7eb`) instead of OtterPool's warm greens
- Square edges (no border-radius on panels/cards) — industrial
- Gradient LED indicators give it a physical, hardware quality
- Rectangular coloured button indicators echo real machine controls
- The red/amber/green urgency LEDs pop against the neutral background
- Generous spacing maintained ("Duplo not Lego" still applies)

---

## Design Principles (per project)

- "Duplo not Lego" — generous spacing, large text, simple layout
- Plus Jakarta Sans throughout (not Fraunces except wordmark)
- Mobile-first, max 430px container
- Night Watchman visual style — grey background, white panels, all-caps small-caps labels, coloured square indicators
- Minimum 1rem body text (0.9rem allowed for secondary labels only)
