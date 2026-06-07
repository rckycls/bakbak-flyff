# Custom Features

This file documents the custom `__BB_*` features added to this source tree.
Keep it updated for every future custom change, including source edits, resource edits, packet IDs, database scripts, feature defines, and known limitations.

## Maintenance Rule

When adding or changing a custom feature:

1. Update the relevant section in this file.
2. Add any new feature define, packet ID, resource ID, hotkey, menu entry, database script, or rebuild/repack requirement.
3. Note whether the change affects `Neuz`, `WorldServer`, resources, database, or client data files.
4. Keep tunable data locations clear so future edits do not require hunting through the source.

## Feature Defines

Current custom feature switches are grouped under `// CUSTOM FEATURES`.

Files:

- `Source/Neuz/VersionCommon.h`
- `Source/WORLDSERVER/VersionCommon.h`

Defines:

```cpp
#define __BB_VIP_AUTH_LEVELS
#define __BB_VIP_TITLES
#define __BB_TELEPORTER_WINDOW
#define __BB_ARENA_3V3
```

Commenting one of these defines disables the related custom code path for that project. Keep matching defines enabled in both `Neuz` and `WorldServer` when a feature has both client and server code.

## VIP Auth Levels And Titles

Feature defines:

- `__BB_VIP_AUTH_LEVELS`
- `__BB_VIP_TITLES`

Main files:

- `Source/_Common/authorization.h`
- `Source/_Common/Mover.h`
- `Source/_Common/MoverRender.cpp`
- `Source/Neuz/VersionCommon.h`
- `Source/WORLDSERVER/VersionCommon.h`

Added auth values:

```cpp
AUTH_GENERAL_VIP1  '1'
AUTH_GENERAL_VIP2  '2'
AUTH_GENERAL_VIP3  '3'
```

Behavior:

- VIP auth levels currently mirror `AUTH_GENERAL` permissions.
- VIP levels are treated as valid general-user auth for normal permission checks.
- The auth ranking helper places VIP levels above `AUTH_GENERAL` but below staff levels.
- VIP display/title color is light gold, close to white.

Important helpers:

- `IsAuthVip(dwAuthorization)`
- `IsAuthorizationHigher(dwCurrentAuthorization, dwRequiredAuthorization)`

Notes:

- Auth is currently read from `m_chAuthority` / `m_dwAuthorization`, which is account-side in the existing login flow.
- These VIP levels are intended for future VIP-only features.
- Keep VIP-only checks using `IsAuthVip(...)` instead of raw character comparisons.

## Teleporter Window

Feature define:

- `__BB_TELEPORTER_WINDOW`

Main files:

- `Source/_Common/TeleportTownInfo.h`
- `Source/_Interface/WndTeleporter.h`
- `Source/_Interface/WndTeleporter.cpp`
- `Source/_Interface/FuncApplet.cpp`
- `Source/_Interface/WndTaskBar.cpp`
- `Source/Neuz/DPClient.h`
- `Source/Neuz/DPClient.cpp`
- `Source/WORLDSERVER/DPSrvr.h`
- `Source/WORLDSERVER/DPSrvr.cpp`
- `Source/_Network/MsgHdr.h`
- `Resource/ResData.h`

App ID:

```cpp
APP_TELEPORTER 2023
```

Hotkey:

- `U`

Menu:

- Added under taskbar menu group `Navigation`.
- `Navigation` contains Teleporter, 3v3 Arena, World Map, and Navigator.

Behavior:

- `AUTH_GENERAL` and above can open and use the Teleporter.
- Regular `AUTH_GENERAL` players only see/use Town destinations.
- VIP players can see/use Town and Premium destinations.
- Staff at `AUTH_HELPER` and above can see/use Premium destinations too.
- Server validates permissions again before teleporting.
- Teleporting costs Penya.
- If Penya is insufficient, teleport is blocked and an error is shown.
- UI displays the selected destination cost as `Cost: {Price}` below the list.

Destination data:

- Edit destinations in `Source/_Common/TeleportTownInfo.h`.
- Each entry has name, category, world ID, position, layer, and cost.

Town destinations:

- Flaris
- Saint Morning
- Darkon
- Darkon 3
- Shaduwar

Premium destinations:

- Azria
- Coral Island
- Volcano
- Garden of Rhisis
- Dungeon: Dekane Mines
- Dungeon: Mars Mine

Important helpers:

- `CanOpenTeleporter(dwAuthorization)`
- `CanUsePremiumTeleportDestinations(dwAuthorization)`
- `CanUseTeleportTown(pTown, dwAuthorization)`
- `GetTeleportTownInfo(nIndex)`
- `GetTeleportTownCount()`

Rebuild notes:

- Rebuild `Neuz` and `WorldServer`.
- If resource/app IDs or resdata layout changes are made later, rebuild/repack the client resources as needed.

## Pet Stat Changes And Mana Unicorn

Main resource files:

- `Resource/pet.inc`
- `Resource/defineObj.h`
- `Resource/defineItem.h`
- `Resource/propMover.txt`
- `Resource/propItem.txt`

Pet stat changes:

- Dragon now uses `DST_ATKPOWER_RATE` for attack percent.
- Eagle/griffin-style defense pet now uses `DST_ADJDEF_RATE` for defense percent.
- Unicorn now uses `DST_HP_MAX_RATE` for HP percent.
- Mana Unicorn uses `DST_MP_MAX_RATE` for MP percent.

`Resource/pet.inc` current custom stat rows:

```txt
DST_ATKPOWER_RATE ... II_PET_DRAGON01      MI_PET_DRAGON01      MI_PET_DRAGON01_1      MI_PET_DRAGON01_2
DST_ADJDEF_RATE   ... II_PET_EAGLE01       MI_PET_EAGLE01       MI_PET_EAGLE01_1       MI_PET_EAGLE01_2
DST_HP_MAX_RATE   ... II_PET_UNICORN01     MI_PET_UNICORN01     MI_PET_UNICORN01_1     MI_PET_UNICORN01_2
DST_MP_MAX_RATE   ... II_PET_MANAUNICORN01 MI_PET_MANAUNICORN01 MI_PET_MANAUNICORN01_1 MI_PET_MANAUNICORN01_2
```

Mana Unicorn IDs:

```cpp
II_PET_MANAUNICORN01 21090
MI_PET_MANAUNICORN01   1157
MI_PET_MANAUNICORN01_1 1158
MI_PET_MANAUNICORN01_2 1159
```

Mana Unicorn resource entries:

- `Resource/propMover.txt` contains `MI_PET_MANAUNICORN01`, `_1`, and `_2`.
- `Resource/propItem.txt` contains `II_PET_MANAUNICORN01`.
- The item texture reference is `Itm_PetManaUnicorn01.dds`.

Notes:

- Pet stat display code was updated to show percent-style text for `DST_ATKPOWER_RATE`, `DST_ADJDEF_RATE`, `DST_HP_MAX_RATE`, and `DST_MP_MAX_RATE`.
- Resource-side pet edits require client resource rebuild/repack for live client testing.
- If adding another pet later, document new `II_*`, `MI_*`, `propItem`, `propMover`, `pet.inc`, icon/model/texture entries, and any resource pack steps here.

## 3v3 Arena Matchmaking

Feature define:

- `__BB_ARENA_3V3`

Main files:

- `Source/_Common/Arena3v3.h`
- `Source/WORLDSERVER/Arena3v3MatchMaker.h`
- `Source/WORLDSERVER/Arena3v3MatchMaker.cpp`
- `Source/WORLDSERVER/DPSrvr.h`
- `Source/WORLDSERVER/DPSrvr.cpp`
- `Source/WORLDSERVER/ThreadMng.cpp`
- `Source/WORLDSERVER/User.cpp`
- `Source/WORLDSERVER/AttackArbiter.cpp`
- `Source/_Interface/WndArena3v3.h`
- `Source/_Interface/WndArena3v3.cpp`
- `Source/_Interface/FuncApplet.cpp`
- `Source/_Interface/WndTaskBar.cpp`
- `Source/Neuz/DPClient.h`
- `Source/Neuz/DPClient.cpp`
- `Source/_Network/MsgHdr.h`
- `Resource/ResData.h`
- `Arena3v3.sql`

App ID:

```cpp
APP_ARENA_3V3 2024
```

Hotkey:

- `Z`

Menu:

- Added under taskbar menu group `Navigation`.

Client UI:

- Window title: `3v3 Arena`.
- Main title: `3v3 Arena Matchmaking`.
- Initial buttons: `Find Match` and `Close`.
- Main button changes by state:
  - Ready: `Find Match`
  - Searching: `Cancel Find Match`
  - Match found: `Accept Match`
  - Accepted: `Accepted`
  - In match: `In Match`
- Placeholder stats are shown for Credit, MMR, Last Match, and Win Rate.

Current match flow:

1. Player clicks `Find Match`.
2. Neuz sends join queue packet.
3. WorldServer queues the player.
4. Once 6 players are queued, the server creates a pending match.
5. Neuz receives match-found packet and shows `Accept Match`.
6. All 6 players must accept before timeout.
7. WorldServer starts the match and moves players into the arena world/layer.
8. Kill count, time limit, leave, disconnect, and match end logic are handled server-side.

Packet IDs:

```cpp
PACKETTYPE_ARENA3V3_JOIN_QUEUE    0x88100300
PACKETTYPE_ARENA3V3_LEAVE_QUEUE   0x88100301
PACKETTYPE_ARENA3V3_ACCEPT_MATCH  0x88100302
PACKETTYPE_ARENA3V3_DECLINE_MATCH 0x88100303
PACKETTYPE_ARENA3V3_STATUS        0x88100304
PACKETTYPE_ARENA3V3_MATCH_FOUND   0x88100305
```

Tunables:

- Edit match constants in `Source/_Common/Arena3v3.h`.
- Current values include:
  - 3 players per team.
  - 6 players per match.
  - 30 second accept timeout.
  - 300 second match time.
  - 15 kill limit.
  - Arena world: `WI_WORLD_ARENA`.
  - Match layers: `30000` to `39999`.

Current limitations:

- MMR, credit score, win rate, and last match are in-memory/placeholders.
- `Arena3v3.sql` exists but full database persistence is not wired yet.
- Full DB wiring is needed before production use for persistent MMR, credit, match history, win/loss/draw, leaderboards, rewards, and admin tools.
- The feature is ready for queue/match-flow testing with 6 online characters after rebuilding `Neuz` and `WorldServer`.

## Build And Test Checklist

For source-only changes:

1. Rebuild `Neuz`.
2. Rebuild `WorldServer`.
3. Copy updated executables to the matching client/server folders.
4. Restart the server stack.

For resource/data changes:

1. Rebuild or repack affected resource files.
2. Copy updated resource archives/files to the client.
3. Rebuild source too if headers or source files changed.

Feature-specific smoke tests:

- VIP: log in with each VIP auth value and confirm normal user access still works.
- VIP titles: confirm name color is light gold and staff colors still work.
- Teleporter: test general user Town access, VIP Premium access, staff Premium access, insufficient Penya, and successful Penya deduction.
- Pets: spawn/equip affected pets and confirm tooltip/stat display uses percent for changed stats.
- 3v3 Arena: queue 6 characters, accept match, confirm teleport to arena, test decline, timeout, close-window cleanup, disconnect, match end, and return teleport.

## Change Log

### 2026-06-08

- Created this custom feature documentation file.
- Documented VIP auth/title changes, Teleporter, pet stat/Mana Unicorn work, and 3v3 Arena matchmaking.
