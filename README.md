# Eternal Isles 🏝️

A social fantasy adventure on floating islands, built with **Roblox Studio**, **Luau** and **Rojo**.

> **Status:** pre-alpha foundation. The world is a playable greybox, not final art.

## First playable slice

- A generated floating starter island with a safe spawn, grove, rune circle and portal landmark.
- A brook, waterfall and grotto on the starter island. Gather 15 mana to open the portal, find the golden scale in the rookery and return home. Show the scale to Iskra and call the dragon again for a guided flight to Wind Isle. Its amber relic unlocks a direct return flight. Mana lasts for the session. Expedition milestones use DataStore in published places.
- Three mana crystals that players can gather individually with a proximity prompt.
- A server-owned session mana counter shown in the HUD.
- Server-authoritative day/night clock.
- Lightweight client HUD with world time and project status.
- A small, modular codebase ready for dragons, exploration and player housing.

## Start in Roblox Studio

1. Install [Roblox Studio](https://create.roblox.com/) and [Rojo](https://rojo.space/).
2. Clone this repository.
3. In the repository directory run `rojo serve`.
4. In Roblox Studio open a **new Baseplate** place, install/open the Rojo plugin and connect to the local server.
5. Press **Play**. The server creates the island automatically. Save the place to your Roblox account when ready.

The server-generated geometry is deliberate: no third-party Toolbox models, hidden scripts or external dependencies.

## Repository structure

- `default.project.json` — Rojo mapping.
- `src/server` — authoritative world systems.
- `src/client` — local interface.
- `src/shared` — shared settings.
- `docs/ROADMAP.md` — milestones and acceptance criteria.

## Design pillars

1. Delightful first five minutes.
2. Explore islands together, then bring treasures home.
3. Express identity through an island and cosmetics.
4. Mobile-first performance and fair monetization.
5. Analytics and playtesting before scaling content.

No monetization is implemented yet. The first priority is a genuinely fun loop.

## Language

Player-facing UI is currently Russian; English localization is planned before public launch.
