# GitHub release notes template

**Tag:** `android-mic-VERSION`  
**Title:** `Vibepollo full installer (Android mic) — VERSION`

---

## Download

**`VibepolloSetup.exe`** — full Windows host install (unsigned).

| File | SHA-256 |
|------|---------|
| `VibepolloSetup.exe` | _(paste from Get-FileHash)_ |

Run as **Administrator**. SmartScreen may warn on unsigned builds.

---

## Required client

**[logabell/moonlight-qt-mic](https://github.com/logabell/moonlight-qt-mic)** on Android TV — **required**. Not Artemis or stock Moonlight.

**Tested hardware:** **2019 NVIDIA Shield TV Pro** only.

---

## What is in this build

- Full Vibepollo host based on **1.17.0-beta.8** (service, virtual display, web UI, Playnite)
- **Android / client microphone passthrough** (`stream_mic`) — port from [logabell/Vibepollo](https://github.com/logabell/Vibepollo)
- Steam Streaming Microphone + Speakers virtual audio drivers

---

## After install

1. Install **moonlight-qt-mic** on the Shield and pair to this host.
2. Web UI -> **Audio/Video** -> enable **Microphone Passthrough**.
3. Host apps: **Microphone (Steam Streaming Microphone)**.

---

## Credits

[Nonary/Vibepollo](https://github.com/Nonary/Vibepollo) · [logabell/Vibepollo](https://github.com/logabell/Vibepollo) mic port · Maintainer: Samuel Heilman · [FORK_ATTRIBUTION.md](https://github.com/heilmansamuelmax-netizen/Vibepollo-android-mic/blob/port-logabell-mic/docs/FORK_ATTRIBUTION.md)