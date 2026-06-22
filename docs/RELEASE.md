# Releases (Windows installer)

Download **`VibepolloSetup.exe`** from **[GitHub Releases](https://github.com/heilmansamuelmax-netizen/Vibepollo-android-mic/releases)**.

Full Vibepollo host installer with **Android/client microphone passthrough** on top of Vibepollo 1.17.0-beta.8 (service, virtual display, web UI, Playnite).

## Download

1. Open [Releases](https://github.com/heilmansamuelmax-netizen/Vibepollo-android-mic/releases).
2. Download **`VibepolloSetup.exe`** from the latest `android-mic-*` tag.
3. Run as **Administrator** (unsigned — Windows SmartScreen may warn; choose **Run anyway**).

## Required client

| Component | Link |
|-----------|------|
| **Android TV client** | **[logabell/moonlight-qt-mic](https://github.com/logabell/moonlight-qt-mic)** (required) |

Artemis, stock Moonlight, and other forks are **not** supported for mic passthrough with this build.

**Tested hardware:** **2019 NVIDIA Shield TV Pro** only. Other Android TV devices are untested.

## After install

1. Open the web UI (`https://localhost:47990`) and pair your client.
2. Enable mic: **Configuration → Audio/Video** → **Microphone Passthrough** → save.
3. **Steam** must be installed (virtual mic/speaker drivers ship with Steam).
4. Install **moonlight-qt-mic** on the Shield, pair, and enable microphone when streaming.
5. On the host, select **Microphone (Steam Streaming Microphone)** in Discord/games.

USB wireless headsets are recommended on Shield; see [remote_microphone.md](remote_microphone.md#nvidia-shield-tv-pro-2019-tested-client-setup).

## Build your own

See [BUILD_INSTALLER.md](BUILD_INSTALLER.md). When publishing a release, use [RELEASE_NOTES_TEMPLATE.md](RELEASE_NOTES_TEMPLATE.md).

## Notes

- Local builds are **unsigned** unless you sign them yourself.
- Mic port from [logabell/Vibepollo](https://github.com/logabell/Vibepollo); see [MIC_PORT.md](MIC_PORT.md) and [FORK_ATTRIBUTION.md](FORK_ATTRIBUTION.md).