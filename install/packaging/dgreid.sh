# Install user-specific pacman packages
mapfile -t packages < <(grep -v '^#' "$OMARCHY_INSTALL/omarchy-dgreid.packages" | grep -v '^$')
sudo pacman -S --noconfirm --needed "${packages[@]}"

# Install AUR packages - use pacman if available (ISO offline mirror), otherwise yay
mapfile -t aur_packages < <(grep -v '^#' "$OMARCHY_INSTALL/omarchy-dgreid-aur.packages" | grep -v '^$')
if [[ ${#aur_packages[@]} -gt 0 ]]; then
  if pacman -Si "${aur_packages[0]}" &>/dev/null; then
    sudo pacman -S --noconfirm --needed "${aur_packages[@]}"
  else
    yay -S --noconfirm --needed "${aur_packages[@]}"
  fi
fi
