# Eternal Isles — roadmap

## Milestone 0 — foundation
- [x] Rojo code layout and modular server/client/shared boundary.
- [x] Server-built floating starter island (placeholder geometry).
- [x] World clock with client HUD.
- [x] Starter island landmarks and first mana-crystal resource nodes.
- [x] Server-authoritative per-player mana collection with proximity prompts.
- [x] HUD displays the player's current mana.
- [ ] Studio smoke test with two players.
- [ ] Check mobile HUD and spawn collisions.

## Milestone 1 — first fun loop
- [x] Functional portal to a second island, with a safe return.
- [x] One collectible resource and server-side session inventory (persistence still pending).
- [x] First expedition: gather 15 mana, reach the rookery, collect the golden scale and return home.
- [x] Befriend Iskra, ride to Wind Isle and unlock a direct flight home by collecting wind amber.
- [x] In-game relic journal with discovery clues, collected lore and unlocked dragon routes.
- [ ] Verify DawnTrail milestone saves on rejoin in a published test place.
- [ ] Persistent player profile with safe DataStore handling.
- [ ] One cooperative encounter, including mobile controls.
- [ ] First-time-user tutorial, skip option and session analytics.

**Exit criteria:** five external testers can independently play for 10 minutes without intervention; no progress loss across rejoin tests.

## Milestone 2 — unique identity
- [ ] First dragon companion with distinct traversal ability.
- [ ] Personal island customization and save/load.
- [ ] Modular polished island art, sound and VFX.
- [ ] Friends/co-op flow and social sharing.

## Milestone 3 — launch preparation
- [ ] Profile security, remote validation and exploit review.
- [ ] Localization, accessibility and low-end device profiling.
- [ ] Analytics: D1 retention, first-session completion, crashes.
- [ ] Honest cosmetic store with transparent prices.
- [ ] Playtest feedback and small-scale acquisition test.

## Product constraints
- Avoid pay-to-win mechanics and paid randomized rewards in the prototype.
- Never trust client-supplied progression, currency or purchases.
- Design for mobile first; measure performance before adding expensive assets.
- Keep art original or properly licensed and track attribution.
- Do not promise earnings: retention and conversion must be measured.
