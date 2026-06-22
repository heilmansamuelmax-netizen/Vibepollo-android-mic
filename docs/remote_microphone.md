# Remote Microphone Support

This fork adds a working host-side remote microphone path for Vibepollo, focused on Windows hosts and Steam Streaming Microphone integration.

## Overview

**Paired client (required):** [logabell/moonlight-qt-mic](https://github.com/logabell/moonlight-qt-mic) on Android TV. This host fork does not change the client — you must use moonlight-qt-mic (not Artemis or stock Moonlight).

**Tested hardware:** **2019 NVIDIA Shield TV Pro** only.

The microphone path is:

1. The paired Android client captures local microphone audio.
2. The client sends **encrypted** microphone packets to Vibepollo on the dedicated microphone stream.
3. Vibepollo receives the packets, decrypts them when needed, and decodes the Opus frames on the host.
4. Vibepollo renders the decoded PCM into the Steam playback endpoint `Speakers (Steam Streaming Microphone)`.
5. Host applications consume that audio from the paired capture endpoint `Microphone (Steam Streaming Microphone)`.

This keeps the host-side application flow simple: Vibepollo writes into Steam Streaming Microphone, and games, chat apps, or capture tools use `Microphone (Steam Streaming Microphone)` as the microphone.

## What Changed

The working implementation in this fork includes:

- Dedicated microphone session handling in the stream path, including packet receive, optional decryption, and per-session lifecycle management.
- Windows microphone backend initialization and teardown that stays alive for the full remote microphone session.
- A Steam-backed Windows microphone path that auto-detects the Steam microphone render/capture pair, normalizes only that pair to `2ch, 32-bit, 48000 Hz` when microphone streaming starts, decodes Opus microphone frames as mono float `48 kHz`, and writes them into the Steam microphone render buffer using a `float32` shared-mode render client.
- Host-side recovery for recoverable WASAPI failures such as device invalidation or audio service restarts.
- A Remote Microphone Debug panel in the web UI that shows packet arrival, decode status, render status, signal detection, counters, and recent mic events.

## Key Files

- `src/stream.cpp`: microphone socket handling, session startup/shutdown, and packet routing.
- `src/audio.cpp`: shared microphone debug state and persistent audio context ownership for the redirect device.
- `src/platform/windows/audio.cpp`: Windows microphone backend selection and redirect device ownership.
- `src/platform/windows/vibepollo_vmic.cpp`: Steam Streaming Microphone backend wrapper.
- `src/platform/windows/mic_write.cpp`: device discovery, WASAPI initialization, Opus decode, and Steam Streaming Microphone rendering.
- `src_assets/common/assets/web/configs/tabs/AudioVideo.vue`: Remote Microphone Debug UI.

## Windows Requirements

- **Steam must be installed** on the PC (drivers live under `C:\Program Files (x86)\Common Files\Steam\drivers\Windows10\x64\`).
- Vibepollo installs **both** virtual devices when `install_steam_audio_drivers` is enabled (default):
  - **Speakers (Steam Streaming Microphone)** — where Vibepollo *writes* decoded phone audio
  - **Microphone (Steam Streaming Microphone)** — what Discord, Steam, games, etc. must *record from*
- Enable `stream_mic` in Vibepollo.
- Install and pair **[logabell/moonlight-qt-mic](https://github.com/logabell/moonlight-qt-mic)** on Android TV (required for this fork).

### Discord, Steam, and games

Remote mic does **not** replace your normal PC microphone automatically. In each app’s input settings, choose:

**Microphone (Steam Streaming Microphone)**

Not your headset, webcam, or “Default device” unless that default is explicitly the Steam virtual mic.

Quick sanity check before Discord:

1. Connect from the phone with mic enabled.
2. Open **Sound settings → Recording** and confirm **Microphone (Steam Streaming Microphone)** exists.
3. Open **Voice Recorder** (or similar), select that device, talk into the phone — you should see levels move.

If Voice Recorder works but Discord does not, Discord’s input device is wrong. If Voice Recorder is flat, the host path (drivers, `stream_mic`, or client encryption) is still broken.

## NVIDIA Shield TV Pro (2019) — tested client setup

This fork's mic release was **only tested** on a **2019 NVIDIA Shield TV Pro** running **[logabell/moonlight-qt-mic](https://github.com/logabell/moonlight-qt-mic)** with a **USB wireless headset** (dongle or base connected to the Shield's USB port). Other Android TV devices, clients, and Shield models are **untested**.

- **USB wireless headset (recommended):** Let Android TV see the headset as the recording device. The wireless link is between the headset and its USB dongle; the Shield only needs to capture from that USB audio device.
- **Bluetooth headset:** Mic passthrough **may not work** on Shield over Bluetooth—Android TV and many BT headsets do not expose a reliable mic path to sideloaded streaming apps. This fork does not fix Shield-side Bluetooth routing.
- **Why USB over BT anyway:** Bluetooth audio on Shield is often **low quality** (narrow codec, latency, dropouts) for both playback and capture. A USB wireless headset is usually the better choice for voice chat even when BT “works.”

The host side is unchanged: `stream_mic` on the PC, then **Microphone (Steam Streaming Microphone)** in Discord, Steam, or games.

## Configuration Notes

- `stream_mic` enables the host microphone redirect path.
- `mic_backend` defaults to `steam_streaming_microphone` on Windows in this fork.
- On Windows, Vibepollo auto-detects the Steam Streaming Microphone pair and normalizes only those microphone endpoints to `2ch, 32-bit, 48000 Hz` automatically instead of requiring a manual device-properties change.
- `mic_device` is mainly relevant on non-Windows platforms. The Windows path currently targets Steam Streaming Microphone automatically.
- Redirected microphone transport is always required to negotiate encrypted microphone packets. If the client falls back to plaintext microphone transport, Vibepollo disables microphone passthrough for that session instead of accepting unencrypted microphone packets.

## Debugging

The Audio/Video page on Windows exposes a Remote Microphone Debug panel that shows:

- whether the client is sending packets
- whether Vibepollo is decoding microphone frames
- whether Vibepollo is rendering into Steam Streaming Microphone
- whether non-silent input is being detected
- which endpoint mix format Vibepollo discovered
- which render and capture device formats are currently active
- which render format Vibepollo actually initialized
- whether the recommended Steam microphone format is active or had to be enforced
- how mono input is mapped to the host channels
- the most recent mic errors and recent mic events

This view is intended to quickly separate client capture problems from host decode/render problems.
