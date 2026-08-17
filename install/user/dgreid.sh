# Extra packages and defaults for the dgreid profile.

read_package_list() {
  local file="$1"
  grep -v '^#' "$file" | grep -v '^$' || true
}

if [[ -f $OMARCHY_INSTALL/omarchy-dgreid.packages ]]; then
  mapfile -t packages < <(read_package_list "$OMARCHY_INSTALL/omarchy-dgreid.packages")
  if ((${#packages[@]} > 0)); then
    omarchy-pkg-add "${packages[@]}"
  fi
fi

if [[ -f $OMARCHY_INSTALL/omarchy-dgreid-aur.packages ]]; then
  mapfile -t aur_packages < <(read_package_list "$OMARCHY_INSTALL/omarchy-dgreid-aur.packages")
  for pkg in "${aur_packages[@]}"; do
    if omarchy-pkg-present "$pkg"; then
      continue
    fi

    if pacman -Si "$pkg" &>/dev/null; then
      omarchy-pkg-add "$pkg"
    elif ! omarchy-pkg-aur-add "$pkg"; then
      echo "Warning: could not install AUR package $pkg"
    fi
  done
fi

# Screensaver off by default.
omarchy-toggle screensaver-off on

# Prefer looknfeel.lua gaps=0 (keeps borders) over the no-gaps toggle,
# which also sets border_size = 0.
rm -f "$HOME/.local/state/omarchy/toggles/hypr/window-no-gaps.lua"
