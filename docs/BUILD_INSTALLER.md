# Building a Windows installer (like official Vibepollo)

This matches the upstream pipeline: **compile → WiX MSI → bootstrapper setup EXE**.

## Prerequisites

1. **MSYS2** with **UCRT64** shell and packages from [building.md](building.md#windows)
2. **WiX Toolset 3.x** — e.g. `choco install wixtoolset` or [WiX releases](https://github.com/wixtoolset/wix3/releases)
3. **.NET SDK 8+** — for `packaging/windows/bootstrapper/`
4. **Node.js** — MSYS2 `mingw-w64-ucrt-x86_64-nodejs` **and** pass `-DNPM=.../scripts/npm_with_ucrt64.cmd` so `cmd.exe` can find `node.exe` during the web UI build (or install [Node.js 22.x for Windows](https://nodejs.org/) and point `-DNPM` at that `npm.cmd`)
5. **Git submodules:** `git submodule update --init --recursive`

## WebRTC (matches official releases)

Official Vibepollo builds with `SUNSHINE_ENABLE_WEBRTC=ON`. Download pinned artifacts:

```powershell
.\scripts\download_webrtc_release.ps1 `
  -OutDir "$env:LOCALAPPDATA\Vibepollo\deps\libwebrtc\out"
```

Or set `WEBRTC_ROOT` to that folder.

## Virtual display driver (required for MSI)

The MSI packages the **Vibepollo Display Driver**. CI downloads a prebuilt [Nonary/libvirtualdisplay](https://github.com/Nonary/libvirtualdisplay) release instead of building the kernel driver locally.

For a local installer, download and extract the pinned release (see `.github/workflows/ci-windows.yml`, currently `v1.4.3`), then either:

1. **Refresh driver assets** before configuring CMake:

```powershell
$prebuilt = "C:\path\to\libvirtualdisplay-1.4.3-windows-x64"
.\packaging\windows\virtual_display_driver\refresh_driver_package.ps1 `
  -Build -LibVirtualDisplayDir .\third-party\libvirtualdisplay `
  -PrebuiltPackageDir $prebuilt `
  -PackageDir .\src_assets\windows\drivers\sunshine `
  -SkipSigning
```

2. **Re-configure CMake** with the prebuilt path (set `GITHUB_ACTIONS=true` so CMake accepts the prebuilt dir, matching CI):

```bash
export GITHUB_ACTIONS=true
export TAG=1.17.0-beta.8
cmake -B build ... \
  -DSUNSHINE_LIBVIRTUALDISPLAY_PREBUILT_DIR="/c/path/to/libvirtualdisplay-1.4.3-windows-x64"
```

Without the driver DLL, probe, and Vulkan layer in `src_assets/windows/drivers/sunshine/`, `package_msi` will fail.

## Configure and build (MSYS2 UCRT64)

```bash
cd /c/Users/heilm/Vibepollo-android-mic
export TAG=1.17.0-beta.8
export WEBRTC_ROOT="$LOCALAPPDATA/Vibepollo/deps/libwebrtc/out"

cmake -B build -G Ninja -S . \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_TESTS=OFF \
  -DBUILD_DOCS=OFF \
  -DSUNSHINE_ENABLE_WEBRTC=ON \
  -DWEBRTC_ROOT="$WEBRTC_ROOT" \
  -DNPM=/c/Users/heilm/Vibepollo-android-mic/scripts/npm_with_ucrt64.cmd \
  -DSUNSHINE_ASSETS_DIR=assets

cmake --build build --target all -j 8
```

**Note:** Run `cmake --build` from **PowerShell** with MSYS2 on `PATH` (so `windres` can find `gcc` and the web UI can find `node.exe`):

```powershell
$env:PATH = 'C:\msys64\ucrt64\bin;C:\msys64\usr\bin;' + $env:PATH
$env:TAG = '1.17.0-beta.8'
$env:WIX = "$env:LOCALAPPDATA\WiX314"
cmake --build build --target all -j 8
```

Use `C:\msys64\ucrt64\bin\cmake.exe` if `cmake` is not on PATH.

## Package MSI

```bash
cmake --build build --target package_msi -j 8
# Output: build/cpack_artifacts/*.msi
```

## Package setup EXE (bootstrapper)

```powershell
$Msi = Get-ChildItem build\cpack_artifacts\*.msi | Sort-Object LastWriteTime -Descending | Select-Object -First 1
.\packaging\windows\bootstrapper\build_bootstrapper.ps1 `
  -BuildDir build `
  -MsiPath $Msi.FullName `
  -OutputName VibepolloSetup.exe `
  -DisableSignPath
```

Output: `build/cpack_artifacts/VibepolloSetup.exe` (~38 MB MSI inside ~38 MB bootstrapper; unsigned)

## Build outputs (this fork)

After a successful run:

| Artifact | Path |
|----------|------|
| Host binary | `build/sunshine.exe` |
| MSI | `build/cpack_artifacts/Vibepollo.msi` |
| Setup EXE | `build/cpack_artifacts/VibepolloSetup.exe` |

Install by running **`VibepolloSetup.exe`** as Administrator (same flow as official Vibepollo: removes conflicting Sunshine/Apollo/Vibeshine, upgrades in place, installs service and drivers).

## Unsigned vs official releases

Local installers are **unsigned**. Official GitHub releases use SignPath. Expect SmartScreen prompts unless you sign the binaries.

## What the installer does (from upstream)

- Removes conflicting **Sunshine**, **Apollo**, **Vibeshine** installs before setup
- In-place **upgrade** via stable WiX Upgrade GUID
- Installs service, firewall rules, shortcuts, virtual display helpers
- Same behavior as Nonary/Vibepollo releases, plus this fork's mic-enabled `sunshine.exe`

See `packaging/windows/wix/` for custom actions.
