# Changelog

## Unreleased

### Fixed
- No error if the game hides the channel's spell ID in combat (Forever); the addon reads it from the player's channel info instead, or skips the music if that's hidden too.
- The music always stops when the Blizzard channel ends, even if the spell ID is hidden at that point.
- The addon only calls StopMusic when it started the music itself, so it leaves other music alone.

## 3.1 — 2026-11-10

### Added
- WoW: Forever support (Interface 16001), alongside Mists of Pandaria Classic.
- Every rank of Blizzard triggers the music in Forever, not just rank 1.

### Fixed
- The music path in code was missing its backslashes, so "Africa" never played.

## 3.0 — 2026-09-27

- Updated for Mists of Pandaria Classic (5.5.4).
