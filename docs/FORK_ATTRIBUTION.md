# Fork attribution and credits

This document describes what this repository is, who maintains it, where the code came from, and how it was produced.

## Maintainer

**Samuel Heilman** ([@heilmansamuelmax-netizen](https://github.com/heilmansamuelmax-netizen))

I am an **auto mechanic**, not a professional software engineer. I forked Vibepollo because I wanted **one feature**: the ability to use my **Android phone's microphone** while streaming to my Windows PC through Moonlight/Artemis-style clients. I did not set out to rewrite Vibepollo or compete with its original authors.

If something in this fork is wrong, confusing, or breaks your setup, that reflects my limited background and the AI-assisted workflow described below—not the quality of upstream Vibepollo.

## What this fork adds

**Android / client microphone passthrough on the Windows host** (remote mic → Steam Streaming Microphone → games and apps).

The host-side implementation was ported from [logabell/Vibepollo](https://github.com/logabell/Vibepollo), which in turn built on Apollo/Sunshine-style streaming. See [remote_microphone.md](remote_microphone.md) and [MIC_PORT.md](MIC_PORT.md) for technical details.

## Upstream projects (credit where due)

| Project | Role | Link |
|---------|------|------|
| **Vibepollo** | Base application; display automation, WGC, WebRTC, Playnite, packaging, installer | [Nonary/Vibepollo](https://github.com/Nonary/Vibepollo) |
| **Apollo** | Lineage of the streaming host | [ClassicOldSong/Apollo](https://github.com/ClassicOldSong/Apollo) |
| **Sunshine** | Original open-source game-streaming host | [LizardByte/Sunshine](https://github.com/LizardByte/Sunshine) |
| **logabell/Vibepollo** | Source of the **microphone passthrough** host implementation used in this fork | [logabell/Vibepollo](https://github.com/logabell/Vibepollo) |
| **logabell/moonlight-qt-mic** | **Paired Android client** used with this fork (mic passthrough on the phone) | [logabell/moonlight-qt-mic](https://github.com/logabell/moonlight-qt-mic) |
| **Artemis / Moonlight Noir** | Related Android client ecosystem with mic support | [ClassicOldSong/moonlight-android](https://github.com/ClassicOldSong/moonlight-android) |
| **Moonlight** | Client protocol lineage | [moonlight-stream/moonlight](https://github.com/moonlight-stream/moonlight) |

This fork is **not** affiliated with, endorsed by, or maintained by Nonary, LizardByte, logabell, or the Moonlight project unless they say otherwise.

## How this fork was built (AI disclosure)

**Nearly all changes in the microphone port and supporting documentation were written with AI assistance**, primarily through **[Cursor](https://cursor.com)** (AI-powered IDE) and its agent tools.

That includes:

- Identifying mic-related files in logabell's fork
- Porting host-side code into current Vibepollo (`stream.cpp`, `audio.cpp`, `mic_write.cpp`, RTSP, config, UI, etc.)
- Fixing compile issues (`cbc_t::decrypt`, submodule init, installer dependencies)
- Writing documentation you are reading now

I directed the work (what feature I wanted, which repos to use, that I wanted a full installer like upstream). I did **not** hand-write the C++ patches line by line.

If you are evaluating trust or maintenance: treat this fork as **"mechanic + AI port of someone else's mic feature onto a moving upstream codebase"**, not as a carefully reviewed engineering product.

## Cursor

Development was done in **Cursor**. The AI agent explored both repositories, compared diffs, applied patches, ran MSYS2 builds, and produced installer packaging steps. Cursor is a product of [Anysphere](https://anysphere.com).

## Installer and packaging

The Windows **MSI** and **setup EXE** behavior (remove old Sunshine/Apollo/Vibeshine installs, in-place upgrade, service, firewall, shortcuts) comes from **upstream Vibepollo packaging** under `packaging/windows/` and `cmake/packaging/`. This fork reuses that pipeline; it does not reinvent the installer.

Official releases are code-signed via SignPath. **Local builds from this fork are typically unsigned** unless you sign them yourself—Windows SmartScreen may warn on first run.

## License

This project inherits the licenses of Vibepollo and its dependencies (see [LICENSE](../LICENSE) and [NOTICE](../NOTICE)). The microphone port files derived from logabell's fork remain subject to those same upstream terms. Do not remove existing copyright or license notices from ported files.

## Suggested citation / README blurb

If you link to or fork this repo, please preserve attribution:

> Microphone passthrough host code adapted from [logabell/Vibepollo](https://github.com/logabell/Vibepollo). Based on [Nonary/Vibepollo](https://github.com/Nonary/Vibepollo). Fork maintained by Samuel Heilman; implementation assisted by AI (Cursor). Maintainer is not a software engineer by trade.
