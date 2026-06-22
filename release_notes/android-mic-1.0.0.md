# Vibepollo full installer (Android mic) — 1.0.0

First public release of the **mic-only** fork installer.

## Download

| File | Size | SHA-256 |
|------|------|---------|
| `VibepolloSetup.exe` | ~36 MB | `28854444C1164996D16778186A1009423F7511C39340986B55F425F318331D02` |

Run as **Administrator**. Unsigned — SmartScreen may warn.

## Required client

**[logabell/moonlight-qt-mic](https://github.com/logabell/moonlight-qt-mic)** on Android TV — **required**.

Do **not** use Artemis, stock Moonlight, or other forks for mic passthrough with this release.

**Tested hardware:** **2019 NVIDIA Shield TV Pro** only. Other Android TV boxes and clients are untested.

## What is included

- Full Vibepollo host (1.17.0-beta.8 base): service, virtual display, web UI, Playnite
- **Android/client microphone passthrough** (`stream_mic`) from [logabell/Vibepollo](https://github.com/logabell/Vibepollo)
- Steam Streaming Microphone + Speakers drivers

## Quick start

1. Install `VibepolloSetup.exe` on your Windows streaming PC.
2. Install **moonlight-qt-mic** on the **2019 Shield TV Pro** and pair to the host.
3. Web UI -> **Audio/Video** -> enable **Microphone Passthrough**.
4. Use **Microphone (Steam Streaming Microphone)** in Discord/games on the host.

USB wireless headset recommended on Shield — see [remote_microphone.md](../docs/remote_microphone.md#nvidia-shield-android-tv-client).

## Credits

[Nonary/Vibepollo](https://github.com/Nonary/Vibepollo) · [logabell/Vibepollo](https://github.com/logabell/Vibepollo) · Maintainer Samuel Heilman · [FORK_ATTRIBUTION.md](../docs/FORK_ATTRIBUTION.md)