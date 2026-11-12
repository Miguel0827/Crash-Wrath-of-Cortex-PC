<div align="center">

<img src="tools/starter/logo.png" alt="Crash Bandicoot: The Wrath of Cortex PC" width="340">

# Crash Bandicoot: The Wrath of Cortex PC

**By NyxBorn**

<a href="https://github.com/Miguel0827/Crash-Wrath-of-Cortex-PC/releases/latest"><img src="https://img.shields.io/github/v/release/Miguel0827/Crash-Wrath-of-Cortex-PC?style=for-the-badge&color=a855f7&label=release" alt="Latest release"></a>
<img src="https://img.shields.io/badge/Windows-10%20%7C%2011-a855f7?style=for-the-badge&logo=windows&logoColor=white" alt="Windows 10 / 11">
<img src="https://img.shields.io/badge/Linux-64--bit-a855f7?style=for-the-badge&logo=linux&logoColor=white" alt="Linux 64-bit">
<img src="https://img.shields.io/github/license/Miguel0827/Crash-Wrath-of-Cortex-PC?style=for-the-badge&color=2e1065" alt="MIT licence">

<a href="https://recompstore.com/dev/miguel0827"><picture><source media="(prefers-color-scheme: dark)" srcset="https://recompstore.com/assets/press/verified-light.svg"><img src="https://recompstore.com/assets/press/verified-dark.svg" alt="Verified developer on RecompStore" height="56"></picture></a>

**[Download the latest version](https://github.com/Miguel0827/Crash-Wrath-of-Cortex-PC/releases/latest)** (Windows `.zip` or Linux `.tar.gz`) · [Report a problem](https://github.com/Miguel0827/Crash-Wrath-of-Cortex-PC/issues/new)

</div>

| | |
|---|---|
| 🖥️ **Native** | The game's own code runs as a real PC program: no emulator |
| 📺 **16:9 widescreen** | Always on, plus no interlacing for a clean picture |
| 🔍 **Up to 4x resolution** | With smooth fog and no ghost copy of the far scenery |
| ⏸️ **Quick menu (F1)** | Resolution, picture, vertical sync, keys, quick save/load |
| 🐧 **Windows and Linux** | Installer with a progress bar, desktop shortcut, saves folder |
| 💿 **Your own disc** | Nothing of the game is included: it is converted from your ISO |

Native PC port of *Crash Bandicoot: The Wrath of Cortex* (PlayStation 2) built with [ps2-native-recomp](https://github.com/exoteric33/ps2-native-recomp): the game's own code is translated to C++ and compiled for Windows or Linux **on your PC, from your own disc**. This project contains **no game code, no game data and no disc images**.

*Port nativo para PC de Crash Bandicoot: The Wrath of Cortex (PS2). El juego se convierte en tu PC a partir de tu propia copia. Este proyecto no contiene nada del juego.* (Español abajo.)

## What you need

- **Windows** 10/11 64-bit, or **Linux** 64-bit (see [Linux](#linux)), and an internet connection for the first install (on Windows about 1 GB of tools is downloaded).
- An ISO you made from **your own** Wrath of Cortex disc. Supported:
  - **Europe** — SLES-50386 (English, French, German, Spanish, Italian, Dutch)
  - **USA / Latin America** — SLUS-20238 (English)
- A graphics card with Vulkan (or Direct3D 12 on Windows).

Your disc dump is a `.bin` + `.cue` pair? That is a CD image; it has to be turned into an `.iso` first (any BIN to ISO converter that keeps 2048-byte sectors, MODE2/2352 → ISO).

## Use (Windows)

1. Download the Windows zip from the [latest release](https://github.com/Miguel0827/Crash-Wrath-of-Cortex-PC/releases/latest) and extract it to a short folder **without spaces and outside OneDrive**, for example `C:\Games\TWoC`.
2. Open **`Crash Wrath of Cortex PC - Config.exe`** (installing and settings).
3. Click **Import ISO...** and choose your ISO. The installer downloads the converter, applies this project's fixes and converts the game. It takes several minutes the first time. At the end it offers a desktop shortcut.
4. Choose your settings and press **PLAY**. Once installed, **`Crash Wrath of Cortex PC.exe`** appears next to it and goes straight into the game.

In the game, **F1** opens the quick menu (resolution, picture, vertical sync, keys, quick save/load).

## Linux

Download the Linux `.tar.gz` and extract it (`tar xzf ...`). It works like on Windows, with windows (zenity) on a desktop:

1. Install what the build needs, once:
   - Debian / Ubuntu / Mint: `sudo apt install clang libc++-dev libc++abi-dev cmake ninja-build python3 libsdl2-dev git curl unzip pkg-config zenity`
   - Fedora: `sudo dnf install clang libcxx-devel libcxxabi-devel cmake ninja-build python3 SDL2-devel git curl unzip pkgconf zenity`
   - Arch: `sudo pacman -S clang libc++ cmake ninja python sdl2 git curl unzip pkgconf zenity`
2. Run **`linux/config.sh`** (the settings window). The first time it asks for your ISO and installs the game with a progress bar; at the end it offers a desktop shortcut.
3. From then on, **Crash Bandicoot: The Wrath of Cortex** in your applications menu (or `linux/play.sh`) goes straight into the game; **... - Config** changes the settings.

From a terminal: `./linux/install.sh your-game.iso`, then `./linux/play.sh` (options `--scale 1-4`, `--window`, `--lang 1-6`; see `--help`).

## What this project adds

Fixes to ps2-native-recomp (`patches/twoc-fixes.patch`, made for commit `b1af7232b320`):

- **Endless "LOADING" screen fixed**: the game's sound streamer (NUSOUND.IRX) seeks the disc and waits for the drive's callback before reading. The converter answered the seek but never called back; now a seek ends like a read and calls the CD callback.
- **Normal game speed**: this game runs without the console's GIF transfer timing, which made its main loop take two frames instead of one (slow motion).
- **Smooth fog at high resolutions**: the game works out its fog from the depth buffer at 256 columns and stretches that mask over the 640-column picture. Upscaled, the fog and the far scenery had stair-step edges several pixels wide; the mask is now filtered and rebuilt from the full-resolution depth, so the fog grows smoothly into the distance and its edge follows the scenery (`PS2_SMOOTH_MASKS=0` turns it off).
- **No double image in the distance**: the game softens the far scenery by drawing the picture over itself shifted a few columns sideways. On a sharp PC picture it is a ghost copy of the background that wobbles as the camera moves. That pass is skipped; the fog itself stays (`PS2_DISTANCE_BLUR=1` brings it back).
- Shared with [Crash Tag Team Racing PC](https://github.com/Miguel0827/Crash-Tag-Team-Racing-PC): drawing-queue freeze fix, vector unit programs no longer recompiled every frame, **quick menu (F1)** in English and Spanish in a purple pixel-art style with a **vertical sync** option, and the game's icon on its window.

The launcher (`tools/Launcher.ps1`) and installer (`tools/Instalar.ps1`) are in English, Spanish, French, German, Italian and Portuguese; the Linux windows (`linux/`) in English and Spanish. The converter is downloaded from this project's own copy ([Miguel0827/ps2-native-recomp](https://github.com/Miguel0827/ps2-native-recomp)), with the original repository as a fallback.

Patches from the PCSX2 community (downloaded during install from [PCSX2/pcsx2_patches](https://github.com/PCSX2/pcsx2_patches), not included here): 16:9 widescreen and no interlacing (asasega, CRASHARKI) are always on — the alternate lines were for old TVs and only make edges shimmer on a PC screen; on the USA disc, widescreen (flameofrecca, PsxFan107) and the effect fixes for high resolutions (TechieSaru), also always on.

**ReShade** (optional, Vulkan, Windows) is not included: install it yourself from [reshade.me](https://reshade.me) for `ps2run.exe` if you want SMAA or sharpening.

## Where things go

Everything stays in this folder: the installer creates **`engine/`** next to `tools/` with the converter, its tools (~1 GB) and your converted games, saves and settings. `engine/` is listed in `.gitignore`; delete it before sharing or uploading this folder.

Your saves: the **`Partidas`** folder next to the programs leads to them (`memcard.ps2` is the memory card, `states` the quick saves); the note inside says which file is which. Importing the ISO again keeps them.

## Troubleshooting

- **"Este disco no es una versión soportada"** (this disc is not a supported version): only the Europe (SLES-50386) and USA/Latin America (SLUS-20238) discs are supported.
- **"No se pudo descargar el archivo de parches de PCSX2"** (could not download the PCSX2 patch file): the first install needs an internet connection.
- **The installation fails while building**: some of the build tools do not handle spaces in the folder path. Move this folder to a short path without spaces and outside OneDrive (for example `C:\Games\TWoC`) and import the ISO again. Each import starts clean and keeps your saves.
- **The game is slow or the picture tears**: lower **Internal resolution**, switch **Vertical sync**, or try the other **Graphics API** (Vulkan / Direct3D 12).
- **Installer log**: `%TEMP%\twoc-pc-install.log` on Windows, `/tmp/twoc-pc-install.log` on Linux. Attach it when you report a problem.

## Do not share

Do not share ISOs, the converted program (`ps2run.exe` and the generated C++), or saves. They contain the game, which belongs to its owners.

## Reporting problems

[Open an issue](https://github.com/Miguel0827/Crash-Wrath-of-Cortex-PC/issues/new) and say which disc version you have, Windows or Linux, and what graphics card you use. If the installation failed, attach the installer log.

## Credits and licences

- [ps2-native-recomp](https://github.com/exoteric33/ps2-native-recomp) © Samir Nuri and exoteric33, MIT licence. The fixes in `patches/` are under the same licence.
- Launcher, installer and fixes: **NyxBorn**, MIT licence (`LICENSE`).
- Crash Bandicoot © Activision. The Wrath of Cortex was made by Traveller's Tales. This is an unofficial fan project, not affiliated with or endorsed by them.

---

## Español

**Windows:**

1. Descarga el zip de Windows de la [última versión](https://github.com/Miguel0827/Crash-Wrath-of-Cortex-PC/releases/latest) y descomprímelo en una carpeta corta, **sin espacios y fuera de OneDrive**, por ejemplo `C:\Juegos\TWoC`.
2. Abre **`Crash Wrath of Cortex PC - Config.exe`** (instalar y configurar).
3. Pulsa **Importar ISO...** y elige la ISO de **tu propio disco** (Europa SLES-50386 o USA/Latinoamérica SLUS-20238). La primera vez tarda varios minutos: descarga el convertidor, aplica los arreglos de este proyecto y convierte el juego. Al terminar ofrece un acceso directo en el escritorio.
4. Elige la configuración y pulsa **JUGAR**. Ya instalado, aparece **`Crash Wrath of Cortex PC.exe`**, que abre el juego directamente.

**Linux:** descarga el `.tar.gz`, descomprímelo, instala lo necesario (comando de arriba, sección *Linux*) y abre **`linux/config.sh`**: pide tu ISO, instala el juego con barra de progreso y ofrece un acceso directo. Después el juego aparece en tu menú de aplicaciones como **Crash Bandicoot: The Wrath of Cortex**.

Si tu copia es un `.bin` + `.cue`, primero conviértela a `.iso`.

En el juego, **F1** abre el menú rápido. La versión europea trae español; la de USA solo inglés.

Todo queda en esta carpeta: el instalador crea **`engine`** con el convertidor, sus herramientas y tus juegos convertidos, partidas y configuración. Bórrala antes de compartir o subir la carpeta. Tus partidas: la carpeta **`Partidas`**, junto a los programas, lleva a ellas.

No compartas ISOs ni el juego convertido: contienen el juego, que es de sus dueños.

---

<div align="center">

### Support my work · Apoya mi trabajo 💜

This port is free and always will be. If you want to support my work as a developer, you can sponsor me on GitHub.
It's completely optional: it doesn't unlock anything and it doesn't pay for the game. You always need your own disc.

*Este port es gratis y siempre lo será. Si quieres apoyar mi trabajo como desarrollador, puedes patrocinarme en GitHub.
Es totalmente opcional: no desbloquea nada y no paga el juego. Siempre necesitas tu propio disco.*

<a href="https://github.com/sponsors/Miguel0827"><img src="https://img.shields.io/badge/Sponsor-NyxBorn-a855f7?style=for-the-badge&logo=githubsponsors&logoColor=white" alt="Sponsor NyxBorn on GitHub"></a>

</div>
