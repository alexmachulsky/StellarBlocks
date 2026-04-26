# StellarBlocks — Feature Spec (v1)

This document is the product spec, derived from analyzing hundreds of negative reviews
across Block Blast, Blocks: Block Puzzle, Tap Master, and other top block-puzzle games.

Every feature below maps to a real, repeated complaint or feature request from real players.
The strategy is simple: **be the block puzzle that respects the player.**

**Launch platform: Android (Google Play). iOS later.**

---

## Marketing positioning

> "The block puzzle that doesn't waste your time."
>
> No forced ads. No rigged pieces. Built by one person, for grown-ups who like puzzles.

---

## P0 — Differentiators (must ship at v1.0)

These are the features that make players switch from Block Blast to us.

### 1. Honest, transparent piece generation
- **Complaint addressed:** "Pieces feel rigged — they give you bad pieces when you're winning."
- **What we ship:**
  - Pieces are generated from a seeded RNG. Fair. No difficulty rubber-banding.
  - The seed for the **Daily Puzzle** is publicly derived from the date (e.g. `sha256("stellar-2026-04-26")`). Anyone can verify the day's pieces are the same for every player.
  - In-app "Fairness" page in Settings explaining how piece generation works.
- **Implementation:** `PieceGenerator` takes a `SeededRng` instance. `DailyPuzzle.seedFor(DateTime)` is a pure function.
- **Marketing angle:** This becomes a verifiable trust claim no competitor can copy without rebuilding their economy.

### 2. One-time ad-free unlock — no subscription, no gacha
- **Complaint addressed:** "I would happily pay to get rid of ads but there's no option."
- **What we ship:**
  - Single non-consumable IAP: **"Stargazer Pass" — $4.99**
  - Removes all ads, forever, on the user's Google account (Play handles cross-device entitlement).
  - Includes the Mythology constellation pack as a thank-you.
  - **No** subscriptions. **No** loot boxes. **No** consumable currency.
  - Clear "Restore Purchases" button in Settings (many competitors hide this).
- **Implementation:** `PurchaseManager` wrapping the `in_app_purchase` package. One product ID: `stargazer_pass`.

### 3. Ads that respect the player (when ads exist at all)
- **Complaint addressed:** "30-second ads after every loss, banner ads while playing, mid-placement ad interruptions, no X button."
- **What we ship for free users:**
  - **Zero interstitials.** Ever.
  - **Zero banners during gameplay.**
  - **Rewarded video only, opt-in only**, with two specific uses:
    - Watch an ad to revive once per game (your choice).
    - Watch an ad for a "Hint" or "Block Swap" power-up.
  - Optional banner on the home screen only, between sessions.
  - **Ad budget cap:** maximum 1 rewarded video offered per game session.
- **Implementation:** `AdManager` with explicit `requestRewardedAd(for:)` calls only. No interstitial loading code anywhere in the project.
- **Network:** Google AdMob via the `google_mobile_ads` package.

### 4. Undo button (limited, fair)
- **Complaint addressed:** "Most-requested feature across every block puzzle game. Players misplace pieces, especially one-handed."
- **What we ship:**
  - **3 free undos per game** (last placement only, no chain undos).
  - Small undo icon in the bottom corner. Visible.
  - Grayed out when not available, with a tooltip ("3 undos per game — saves you from misplacements").
  - Stargazer Pass holders get **unlimited undos**.
- **Implementation:** `GameBoard` is immutable — keep a stack of `[GameBoard]` snapshots, max depth 1 per turn (we only undo the last placement, not chains).

### 5. Hold/Swap piece slot
- **Complaint addressed:** Implicit feature request from Tetris players migrating to block puzzle. Adds strategic depth that competitors lack.
- **What we ship:**
  - One "hold" slot above the piece rack. Tap a rack piece to send it to hold; tap hold to swap it back.
  - Hold persists across a single game.
  - Limit: one swap per piece-deal cycle (prevents infinite cycling exploits).
- **Implementation:** Extend `PieceRack` with a nullable `heldPiece` field and `swapHold()` method.

### 6. Real ambient soundtrack + clean SFX
- **Complaint addressed:** "No BGM, just ads."
- **What we ship:**
  - Original cosmic-ambient soundtrack, ~3 looping tracks (one per "biome": night sky, deep space, dawn).
  - Crisp SFX for placement, clear, and star-light events. Tactile, satisfying, never grating.
  - Music **off by default** — respects players who play in public. Settings toggle.
  - No "press X to unmute" forced popups.
- **Implementation:** `AudioManager` using `flame_audio`. Configure to mix-with-others so we don't kill the user's podcast or Spotify.

### 7. The Constellation hook (already core to the game)
- **Why this directly addresses a complaint:** Players say *"high scores feel pointless — no sense of accomplishment."*
- Every line clear permanently lights a star. Every game leaves you closer to completing a constellation, **regardless of whether you "lost."** This breaks the manipulation loop where losing feels punitive — losing here is just "the constellation gets a few more stars."
- Completed constellations live in the **Constellation Gallery** — a permanent visual record of progress.
- Each completion generates a **shareable card** (constellation art + your stats) for organic TikTok/IG growth.

---

## P1 — Polish baseline (ship by v1.1, within 4 weeks of launch)

These are table stakes that competitors get wrong.

### 8. Google Play Games Services leaderboards
- **Complaint addressed:** "No leaderboards, no meaningful progression."
- Daily Puzzle leaderboard (resets daily).
- All-time high score leaderboard.
- Constellation completion count leaderboard.
- Implementation: `games_services` package, signed in via Play Games.

### 9. Honest Google Play Store listing
- **Complaint addressed:** "Ads show features that don't exist."
- Every screenshot is captured from the actual app. No edited-in scores. No fake skin pickers.
- Store description explicitly says "no fake ads, no forced ads, no subscriptions."

### 10. Stats panel
- **Complaint addressed:** "No way to see my play data."
- Total games, average score, longest combo, total stars lit, current streak, constellations completed.
- Local only (`shared_preferences`); no analytics SDK that tracks individuals.

### 11. Proper content rating (Everyone)
- **Complaint addressed:** "Block Blast is 17+ because of bad ads — kids can't play."
- With our ad policy (no inappropriate ad networks, opt-in rewarded only), an "Everyone" rating is achievable.
- Configure AdMob ad content filtering to "G" rated max.

### 12. Tutorial that's actually a tutorial
- **Complaint addressed:** "I don't know how features work; the game just throws them at me."
- 30-second interactive intro. Dismissible. Replayable from Settings.
- Each new feature (Hold, Undo, Daily Puzzle) gets a one-time gentle tooltip the first time it's available.

---

## P2 — New modes (post-launch content)

Add one mode every 6–8 weeks as a content drop.

### 13. Daily Puzzle (week 4–6)
- Same seed for every player worldwide that day.
- Limited number of pieces (e.g., 50). Score the most points before they run out.
- Shareable result emoji-grid (Wordle-style):
  ```
  Stellar Daily #142
  ⭐ Score: 8,420
  🌟🌟🌟🌟⭐⚪
  Constellation: Lyra
  ```
- Drives daily retention without dark patterns.

### 14. Zen Mode (week 8)
- No game-over state. Pieces always fit. Play forever.
- For players who just want to relax and slowly fill constellations.
- Stargazer Pass perk, OR rewarded-ad unlock for one Zen session.

### 15. Time Trial (week 12)
- 90 seconds. Score as much as possible.
- Great for short-attention sessions and TikTok clips.

---

## What we are NOT building (and why)

These are explicitly out of scope. Resist the urge.

- ❌ **Adventure / level mode** — Block Blast players consistently hate it. *"Gimmicky, unfair, feels disconnected from the core."* The constellation system serves the same purpose better.
- ❌ **Subscriptions** — alienates the audience that's fleeing predatory monetization.
- ❌ **Energy / lives system** — same reason.
- ❌ **Loot boxes or gacha cosmetics** — same reason.
- ❌ **Multiplayer / online battles** — out of scope for solo development; Play Games leaderboards are enough social.
- ❌ **A "Watch ad to continue" prompt that auto-plays** — forced ads are exactly what we're differentiating against.
- ❌ **Push notifications by default** — ask permission, default off.
- ❌ **An in-app event calendar with FOMO timers** — manipulative.

---

## Monetization summary

| Source | Mechanism | Expected revenue mix |
|---|---|---|
| Stargazer Pass IAP | One-time $4.99 | ~70% |
| Rewarded ads (revives, hints) | Opt-in only | ~25% |
| Home screen banner ads | Free users only | ~5% |

Compare to Block Blast: ~95% interstitial ads + rewarded ads, no IAP option.
Our model trades volume for retention and goodwill — and a much better Play Store rating.

**Google Play's revenue split:** 15% on the first $1M/year, 30% above that. Plus 30% on ad revenue at the AdMob level. So a $4.99 sale nets ~$4.24 in your first $1M.

---

## Google Play launch checklist (for v1.0)

- [ ] Google Play Console account ($25 one-time)
- [ ] App signing key generated and backed up offline
- [ ] App bundle (`.aab`) under 150MB
- [ ] Privacy policy URL (we collect: nothing personal; AdMob may collect ad-tech data)
- [ ] Data safety form filled honestly
- [ ] Content rating questionnaire (target: Everyone)
- [ ] At least 8 screenshots, 1 feature graphic, 1 icon
- [ ] Short (80 char) and full (4000 char) store descriptions
- [ ] Soft launch in Philippines + Canada first; measure D1/D7 retention; iterate; then expand

---

## Review-mining methodology

Sources analyzed (April 2026):
- Block Blast App Store reviews (US + UK + iPad)
- Blocks: Block Puzzle Games reviews
- Tap Master reviews
- ComplaintsBoard threads on Block Blast Adventure Master
- Metacritic user reviews

Pattern: complaints cluster tightly around (1) ad volume/intrusiveness, (2) perceived rigging,
(3) missing undo, (4) misleading marketing, (5) no premium option. Every P0 above maps to one of these.
