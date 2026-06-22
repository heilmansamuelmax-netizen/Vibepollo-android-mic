# Microphone port (logabell → this fork)

This fork adds **host-side remote microphone passthrough** so a compatible Android/Moonlight client can send mic audio to the PC. User-facing setup is in [remote_microphone.md](remote_microphone.md). Legal and credit context is in [FORK_ATTRIBUTION.md](FORK_ATTRIBUTION.md).

## Source

| Item | Detail |
|------|--------|
| Mic feature origin | [logabell/Vibepollo](https://github.com/logabell/Vibepollo) (`feature/microphone-passthrough` lineage) |
| Base codebase | [Nonary/Vibepollo](https://github.com/Nonary/Vibepollo) @ `1.17.0-beta.8` era |
| Port method | Cherry-picked / manually merged mic-related changes (not a full merge of logabell's outdated tree) |

## New files

- `src/platform/windows/vibepollo_vmic.h` / `.cpp` — Steam Streaming Microphone backend (renamed from logabell's `apollo_vmic`)
- `src/platform/windows/mic_write.h` / `.cpp` — WASAPI render path + Opus decode
- `docs/remote_microphone.md` — usage and debugging

## Modified areas (summary)

- **Stream / RTSP:** UDP mic socket (port offset 12), session lifecycle, encrypted mic negotiation
- **Audio / config:** `stream_mic`, `mic_backend`, `mic_device`, debug API `/api/audio-debug`
- **Crypto:** `cbc_t::decrypt()` for encrypted mic packets
- **Platform:** Windows full backend; Linux PulseAudio redirect stub; macOS stub
- **UI:** `stream_mic` toggle in Audio/Video settings
- **Protocol:** `SS_ENC_MICROPHONE`, `MIC_PACKET_TYPE_OPUS`, `MIC_PACKET_MAGIC` in `third-party/moonlight-common-c` (see below)
- **Build:** `tools/CMakeLists.txt` — `nlohmann_json` for display helper

## Protocol constants

Mic passthrough uses `src/mic_protocol.h` (included from `stream.cpp` and `rtsp.cpp`):

```c
#define SS_ENC_MICROPHONE     0x08
#define MIC_PACKET_TYPE_OPUS  0x61
#define MIC_PACKET_MAGIC      0x12345678
```

These match [logabell/Vibepollo](https://github.com/logabell/Vibepollo) / [ClassicOldSong/moonlight-common-c](https://github.com/ClassicOldSong/moonlight-common-c) until upstream `moonlight-stream/moonlight-common-c` merges equivalent defines. No submodule fork is required for clones.

## Client requirement

The **client** must be **[logabell/moonlight-android](https://github.com/logabell/moonlight-android)** release **[v20.2.6-mic-test2](https://github.com/logabell/moonlight-android/releases/tag/v20.2.6-mic-test2)** on Android TV — install **`app-nonRoot_game-arm64-v8a-debug.apk`** (**Artemis-mic**, `com.limelight.noirdebug`). Stock Moonlight and other builds are not supported for this mic release. This repo only changes the **host**.

**Tested hardware:** **2019 NVIDIA Shield TV Pro** only.

## Build verification

Verified on Windows with MSYS2 **UCRT64**:

```bash
git submodule update --init --recursive
export TAG=1.17.0-beta.8
cmake -B build -G Ninja -S . -DCMAKE_BUILD_TYPE=Release -DSUNSHINE_ENABLE_WEBRTC=OFF ...
cmake --build build --target sunshine -j 8
```

Full release-style installer: see [BUILD_INSTALLER.md](BUILD_INSTALLER.md).
