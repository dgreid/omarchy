# Copy over Omarchy configs
mkdir -p ~/.config
cp -R ~/.local/share/omarchy/config/* ~/.config/
for d in ~/.local/share/omarchy/config/*; do
  ln -s $d ~/.config
done

# Use default bashrc from Omarchy
cp ~/.local/share/omarchy/default/bashrc ~/.bashrc
