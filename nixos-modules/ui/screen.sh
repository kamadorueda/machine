#!/bin/sh -eux

command="${1}"
brightness="${2:-0.5}"

case "${1}" in
  dual-calgary)
    viewport=1600x900

    xrandr \
      --output eDP-1 \
      --primary \
      --off \
      --output DP-1 \
      --mode "${viewport}" \
      --brightness "${brightness}" \
      --same-as eDP-1 \
      --noprimary
    ;;
  dual-colombia)
    viewport=1024x768

    xrandr \
      --output eDP-1 \
      --primary \
      --off \
      --output DP-1 \
      --mode "${viewport}" \
      --brightness "${brightness}" \
      --same-as eDP-1 \
      --noprimary
    ;;
  *)
    xrandr \
      --output eDP-1 \
      --brightness "${brightness}" \
      --mode 1280x800 \
      --primary \
      --output DP-1 \
      --off
    ;;
esac
