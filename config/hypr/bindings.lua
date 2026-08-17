-- dgreid keybinding overrides. Unbind a default before replacing it.
-- See current bindings: omarchy menu keybindings --print

--
-- Vim-style focus / swap / workspace / group (was arrow keys)
--

-- SUPER+J was toggle split; SUPER+T stays float. Split is left unbound.
hl.unbind("SUPER + J")
-- SUPER+K was the keybindings menu; move it so HJKL can own focus.
hl.unbind("SUPER + K")
o.bind("SUPER + SHIFT + CTRL + K", "Keybindings", "omarchy-menu-keybindings")
-- SUPER+L was workspace layout toggle; leave that unbound.
hl.unbind("SUPER + L")

hl.unbind("SUPER + LEFT")
hl.unbind("SUPER + RIGHT")
hl.unbind("SUPER + UP")
hl.unbind("SUPER + DOWN")
o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))
o.bind("SUPER + K", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + J", "Focus on below window", hl.dsp.focus({ direction = "d" }))

hl.unbind("SUPER + SHIFT + LEFT")
hl.unbind("SUPER + SHIFT + RIGHT")
hl.unbind("SUPER + SHIFT + UP")
hl.unbind("SUPER + SHIFT + DOWN")
o.bind("SUPER + SHIFT + H", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + L", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))
o.bind("SUPER + SHIFT + K", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + SHIFT + J", "Swap window down", hl.dsp.window.swap({ direction = "d" }))

hl.unbind("SUPER + SHIFT + ALT + LEFT")
hl.unbind("SUPER + SHIFT + ALT + RIGHT")
hl.unbind("SUPER + SHIFT + ALT + UP")
hl.unbind("SUPER + SHIFT + ALT + DOWN")
o.bind("SUPER + SHIFT + ALT + H", "Move workspace to left monitor", hl.dsp.workspace.move({ monitor = "l" }))
o.bind("SUPER + SHIFT + ALT + L", "Move workspace to right monitor", hl.dsp.workspace.move({ monitor = "r" }))
o.bind("SUPER + SHIFT + ALT + K", "Move workspace to up monitor", hl.dsp.workspace.move({ monitor = "u" }))
o.bind("SUPER + SHIFT + ALT + J", "Move workspace to down monitor", hl.dsp.workspace.move({ monitor = "d" }))

-- SUPER+ALT+K was tmux keybindings; move it so HJKL can own group-join.
hl.unbind("SUPER + ALT + K")
o.bind("SUPER + CTRL + ALT + K", "Tmux keybindings", "omarchy-menu-tmux-keybindings")

hl.unbind("SUPER + ALT + LEFT")
hl.unbind("SUPER + ALT + RIGHT")
hl.unbind("SUPER + ALT + UP")
hl.unbind("SUPER + ALT + DOWN")
o.bind("SUPER + ALT + H", "Move window to group on left", hl.dsp.window.move({ into_group = "l" }))
o.bind("SUPER + ALT + L", "Move window to group on right", hl.dsp.window.move({ into_group = "r" }))
o.bind("SUPER + ALT + K", "Move window to group on top", hl.dsp.window.move({ into_group = "u" }))
o.bind("SUPER + ALT + J", "Move window to group on bottom", hl.dsp.window.move({ into_group = "d" }))

-- Former workspace on semicolon; keep SUPER+CTRL+TAB as well.
o.bind("SUPER + semicolon", "Former workspace", hl.dsp.focus({ workspace = "previous" }))

--
-- Lock on Super+Ctrl+Q (calculator moves to Super+Ctrl+L)
--

hl.unbind("SUPER + CTRL + Q")
hl.unbind("SUPER + CTRL + L")
o.bind("SUPER + CTRL + Q", "Lock system", "omarchy-system-lock")
o.bind("SUPER + CTRL + L", "Calculator", "omacalc")

--
-- Keyboard backlight via Ctrl + display brightness (laptops without XF86Kbd*)
--

o.bind("CTRL + XF86MonBrightnessUp", "Keyboard brightness up", "omarchy-brightness-keyboard up", { locked = true, repeating = true })
o.bind("CTRL + XF86MonBrightnessDown", "Keyboard brightness down", "omarchy-brightness-keyboard down", { locked = true, repeating = true })

--
-- Media keys: assert mute; volume-up unmutes first when already at a non-zero level
--

hl.unbind("XF86AudioRaiseVolume")
hl.unbind("XF86AudioMute")
o.bind("XF86AudioRaiseVolume", "Volume up", "omarchy-audio-output-volume raise-or-unmute", { locked = true, repeating = true })
o.bind("XF86AudioMute", "Mute", "omarchy-audio-output-volume mute", { locked = true })

--
-- Web apps: Google properties in Chrome, X/Grok in Brave
--

hl.unbind("SUPER + SHIFT + Y")
o.bind("SUPER + SHIFT + Y", "YouTube", "omarchy-launch-webapp --browser chrome https://youtube.com/")

hl.unbind("SUPER + SHIFT + P")
o.bind("SUPER + SHIFT + P", "Google Photos", "omarchy-launch-or-focus-webapp 'Google Photos' --browser chrome https://photos.google.com/")

hl.unbind("SUPER + SHIFT + CTRL + G")
o.bind("SUPER + SHIFT + CTRL + G", "Google Messages", "omarchy-launch-or-focus-webapp 'Google Messages' --browser chrome https://messages.google.com/web/conversations")

hl.unbind("SUPER + SHIFT + S")
o.bind("SUPER + SHIFT + S", "Google Maps", "omarchy-launch-or-focus-webapp 'Google Maps' --browser chrome https://maps.google.com/")

hl.unbind("SUPER + SHIFT + X")
o.bind("SUPER + SHIFT + X", "X", "omarchy-launch-webapp --browser brave https://x.com/")

hl.unbind("SUPER + SHIFT + ALT + X")
o.bind("SUPER + SHIFT + ALT + X", "X Post", "omarchy-launch-webapp --browser brave https://x.com/compose/post")

hl.unbind("SUPER + SHIFT + ALT + A")
o.bind("SUPER + SHIFT + ALT + A", "Grok", "omarchy-launch-webapp --browser brave https://grok.com")
