# Eternal Isles — roadmap

## Milestone 0 — foundation
- [x] Rojo code layout and modular server/client/shared boundary.
- [x] Server-built floating starter island (placeholder geometry).
- [x] World clock with client HUD.
- [x] Starter island landmarks and first mana-crystal resource nodes.
- [x] Server-authoritative per-player mana collection with proximity prompts.
- [x] HUD displays the player's current mana.
- [x] Three player-specific portal runes reflect crystal collection. Verified the spawn-to-crystals-to-portal route on foot in solo Studio Play.
- [ ] Studio smoke test with two players.
- [ ] Check mobile HUD and spawn collisions.

## Milestone 1 — first fun loop
- [x] Functional portal to a second island, with a safe return.
- [x] One collectible resource and server-side session inventory (persistence still pending).
- [x] Dragon-first onboarding: one interaction at spawn grants a scale and starts a guided ride; the first screen presents one objective.
- [ ] Observe five first-time players on touch devices: can they pet Iskra and find the amber without coaching? Record the first point of confusion and whether they choose another flight.
- [x] Optional grove route: gather 15 mana, reach the rookery, collect the golden scale and return home.
- [x] Befriend Iskra, ride to Wind Isle and unlock a direct flight home by collecting wind amber.
- [x] In-game relic journal with discovery clues, collected lore and unlocked dragon routes.
- [ ] Verify DawnTrail milestone saves on rejoin in a published test place.
- [ ] Persistent player profile with safe DataStore handling.
- [x] West Cape signal fires: a shared encounter without an activation deadline with a solo route and a sky beam to the observatory.
- [ ] Verify the beacon encounter with two clients and touch controls.
- [ ] First-time-user tutorial, skip option and session analytics.

**Exit criteria:** five external testers can independently play for 10 minutes without intervention; no progress loss across rejoin tests.

## Milestone 2 — unique identity
- [x] First dragon traversal ability: wind amber unlocks player-controlled flight between island perches. Desktop input verified in Studio; touch and gamepad playtests pending.
- [x] First optional free-flight discovery: land at the ruined observatory and study the stargazer’s lens for the relic journal.
- [x] Starter island western cape: continuous walking trail and an observatory lookout.
- [ ] Develop large multi-district islands with walking routes, aerial landmarks and mobile performance checks. Keep smaller discovery islands between them.
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
