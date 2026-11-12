#!/usr/bin/env bash
# Crash Wrath of Cortex PC - starts the converted game on Linux with the settings of the Config window (linux/config.sh).
# Nothing installed yet: the installer opens instead. Options given here win over the saved settings, for this start only:
#   ./linux/play.sh [--us|--eu] [--scale 1-4] [--window] [--lang 1-6]
#   --window  no full screen      --lang  game language: 1 English, 2 French, 3 Spanish, 4 German, 5 Italian, 6 Dutch (European disc)
# In the game, F1 opens the quick menu (resolution, picture, vertical sync, keys, quick save/load).
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
. "$here/ui.sh"

want="$(conf_get version)"; scale="$(conf_get scale)"; look="$(conf_get look)"; vsync="$(conf_get vsync)"
full="$(conf_get full)"; lang="$(conf_get lang)"
: "${full:=1}"
while [ $# -gt 0 ]; do
  case "$1" in
    --us) want=twoc_us ;; --eu) want=twoc_eu ;;
    --scale) scale="$2"; shift ;;
    --window) full=0 ;;
    --lang) lang="$2"; shift ;;
    -h|--help) sed -n '2,6p' "$0"; exit 0 ;;
    *) echo "unknown option: $1 (see --help)" >&2; exit 1 ;;
  esac
  shift
done

games=($(installed_games))
if [ ${#games[@]} -eq 0 ]; then
  [ "$gui" = 1 ] && exec bash "$here/install.sh"
  echo "$(t 'The game is not installed: run' 'El juego no está instalado: ejecuta') ./linux/install.sh /path/to/your/game.iso" >&2
  exit 1
fi
name="${games[0]}"
for n in "${games[@]}"; do [ "$n" = "$want" ] && name="$n"; done
game="$root/games/$name"
exe="$root/build/native-$name/ps2run"
elf="$(sed -nE 's/.*"elf": *"([^"]+)".*/\1/p' "$game/region.json")"
wide="$(sed -nE 's/.*"widescreen": *(true|false).*/\1/p' "$game/region.json")"

# keys.ini (read by the game itself): resolution, picture look and vertical sync
ini="$game/keys.ini"
touch "$ini"
set_ini() { if grep -qE "^[[:space:]]*$1[[:space:]]*=" "$ini"; then sed -i -E "s/^[[:space:]]*$1[[:space:]]*=.*/$1 = $2/" "$ini"; else echo "$1 = $2" >> "$ini"; fi; }
if [ -n "$scale" ]; then set_ini scale "$scale"; elif ! grep -qE '^[[:space:]]*scale[[:space:]]*=' "$ini"; then set_ini scale 4; fi
[ -z "$look" ] || set_ini look "$look"
if [ -n "$vsync" ]; then set_ini vsync "$vsync"; elif ! grep -qE '^[[:space:]]*vsync[[:space:]]*=' "$ini"; then set_ini vsync on; fi

# the patches of every run: wide screen, no interlacing, and the effect fixes for high resolutions (when the disc has them)
{
  for f in ws noint fx; do
    if [ -s "$game/patchsets/$f.txt" ]; then cat "$game/patchsets/$f.txt"; echo; fi   # (the European disc has no effect fixes)
  done
} | sed '/^$/d' > "$game/patches_run.txt"

# languages: the game's from the settings (or --lang), else from $LANG (European disc); the quick menu in Spanish or English
case "${LANG:-}" in es*) def=3 ;; fr*) def=2 ;; de*) def=4 ;; it*) def=5 ;; nl*) def=6 ;; *) def=1 ;; esac
[ "$name" = twoc_us ] && def=1 && lang=1
[ -n "$lang" ] || lang=$def
menu=$([ "$es" = 1 ] && echo es || echo en)

elf_path="games/$name/patched/$elf"; [ -f "$root/$elf_path" ] || elf_path="games/$name/disc/$elf"
args=("$elf_path" --disc "games/$name/disc.iso" --window --game-dir "games/$name" --memcard "games/$name/memcard.ps2" --patches "games/$name/patches_run.txt")
[ "$wide" = true ] && args+=(--widescreen)
[ "$full" = 1 ] && args+=(--fullscreen)
cd "$root"
# the window: the game's emblem as icon, and the name the menu entry (twoc-pc.desktop, StartupWMClass) is matched by in the taskbar
export PS2_WINDOW_ICON="$pkg/tools/starter/icon.bmp" SDL_VIDEO_X11_WMCLASS=twoc-pc SDL_VIDEO_WAYLAND_WMCLASS=twoc-pc
# no PS2_DMA_TIME here: with the console's GIF timing this game's loop needs two frames instead of one and plays in slow motion
PS2_LANGUAGE="$lang" PS2_MENU_LANG="$menu" PS2_GPU_BACKEND=vulkan exec "$exe" "${args[@]}"
