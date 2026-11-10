# Bless The Blizzard

A World of Warcraft addon for mages, for Mists of Pandaria Classic and WoW: Forever. Whenever you channel Blizzard, it plays Toto's "Africa". When the channel ends, the music stops.

## What it does

- On login and every loading screen, if you know Blizzard (any rank), it prints `YOUR BLIZZARDS ARE BLESSED` to chat.
- When you start channeling Blizzard, it plays the bundled `africa.mp3` through the game's music channel.
- When the channel ends (finished, interrupted, or cancelled), it stops the music.

There are no slash commands, options, or saved variables.

The track plays through the in-game music channel, so you need music enabled with the volume turned up to hear it.

## Supported game versions

The `.toc` declares `## Interface: 50504, 16001`:

- Mists of Pandaria Classic 5.5.x (`50504`)
- WoW: Forever 1.60.x (`16001`)

On other clients the addon may show as out of date; tick "Load out of date AddOns" on the AddOns screen to use it there.

## Installation

1. Download or clone this repository.
2. Copy the addon folder into your game's AddOns directory, for example:
   `World of Warcraft/_classic_/Interface/AddOns/BlessTheBlizzard` (MoP Classic) or
   `World of Warcraft/_forever_/Interface/AddOns/BlessTheBlizzard` (Forever)
3. The folder must be named `BlessTheBlizzard` to match `BlessTheBlizzard.toc`, or the game won't load it (the music path is also hard-coded to that folder name).
4. The folder needs `BlessTheBlizzard.toc`, `BlessTheBlizzard.lua`, and `africa.mp3`.
5. Restart the game or `/reload`, then make sure Bless The Blizzard is enabled on the AddOns screen.

## Building a release zip

```sh
npm run build
# or: bash scripts/build.sh
```

This writes `dist/BlessTheBlizzard-<version>.zip`. The version comes from the `## Version` line in the `.toc`, and the zip has a top-level `BlessTheBlizzard/` folder ready to upload or extract into `Interface/AddOns`.
