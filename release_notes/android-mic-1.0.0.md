# Vibepollo full installer (Android mic) — 1.0.0

First public release of the **mic-only** fork installer.

## Download

| File | Size | SHA-256 |
|------|------|---------|
| `VibepolloSetup.exe` | ~36 MB | `28854444C1164996D16778186A1009423F7511C39340986B55F425F318331D02` |

Run as **Administrator**. Unsigned — SmartScreen may warn.

## Required client

**[logabell/moonlight-android v20.2.6-mic-test2](https://github.com/logabell/moonlight-android/releases/tag/v20.2.6-mic-test2)** on Android TV — **required**.

| Shield (arm64) | Value |
|----------------|-------|
| APK | `app-nonRoot_game-arm64-v8a-debug.apk` |
| App | Artemis-mic (`com.limelight.noirdebug`, v20.2.6) |
| SHA-256 | `78CE2B4F95D8FB4692A9D17F871BE5B7A8283424BE49F76E6B08ACBA4F472854` |

**Tested hardware:** **2019 NVIDIA Shield TV Pro** only. Other Android TV boxes and clients are untested.

## What is included

- Full Vibepollo host (1.17.0-beta.8 base): service, virtual display, web UI, Playnite
- **Android/client microphone passthrough** (`stream_mic`) from [logabell/Vibepollo](https://github.com/logabell/Vibepollo)
- Steam Streaming Microphone + Speakers drivers

## Quick start

1. Install `VibepolloSetup.exe` on your Windows streaming PC.
2. Sideload **`app-nonRoot_game-arm64-v8a-debug.apk`** from [v20.2.6-mic-test2](https://github.com/logabell/moonlight-android/releases/tag/v20.2.6-mic-test2) on the **2019 Shield TV Pro**, launch **Artemis-mic**, and pair to the host.
3. Web UI -> **Audio/Video** -> enable **Microphone Passthrough**.
4. Use **Microphone (Steam Streaming Microphone)** in Discord/games on the host.

USB wireless headset recommended on Shield — see [remote_microphone.md](../docs/remote_microphone.md#nvidia-shield-tv-pro-2019-tested-client-setup).

## Credits

[Nonary/Vibepollo](https://github.com/Nonary/Vibepollo) · [logabell/Vibepollo](https://github.com/logabell/Vibepollo) · Maintainer Samuel Heilman · [FORK_ATTRIBUTION.md](../docs/FORK_ATTRIBUTION.md)