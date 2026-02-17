---@meta
---@module 'oxwm'
-------------------------------------------------------------------------------
-- Variables
-------------------------------------------------------------------------------
-- Modifier key: "Mod4" is the Super/Windows key, "Mod1" is Alt
local modkey = "Mod4"

-- Terminal emulator command (defaults to alacritty)
local terminal = "alacritty"

-- Color palette - customize these to match your theme
-- Alternatively you can import other files in here, such as
-- local colors = require("colors.lua") and make colors.lua a file
-- in the ~/.config/oxwm directory
local colors = {
    fg = "#d8dee9",
    red = "#bf616a",
    bg = "#2e3440",
    cyan = "#88c0d0",
    green = "#a3be8c",
    lavender = "#b48ead",
    light_blue = "#88c0d0",
    grey = "#4c566a",
    blue = "#81a1c1",
    purple = "#b48ead",
}

-- Workspace tags - can be numbers, names, or icons (requires a Nerd Font)
local tags = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
-- local tags = { "", "󰊯", "", "", "󰙯", "󱇤", "", "󱘶", "󰧮" } -- Example of nerd font icon tags

-- Font for the status bar (use "fc-list" to see available fonts)
local bar_font = "JetBrainsMono Nerd Font Propo:style=Bold:size=10"

-- Define your blocks
-- Similar to widgets in qtile, or dwmblocks
local blocks = {
    oxwm.bar.block.ram({
        format = "{used}/{total} GB",
        interval = 5,
        color = colors.light_blue,
        underline = false,
    }),
    oxwm.bar.block.static({
        text = "│",
        interval = 999999999,
        color = colors.lavender,
        underline = false,
    }),
    oxwm.bar.block.shell({
        format = " {}",
        command = "uname --nodename -r",
        interval = 999999999,
        color = colors.red,
        underline = false,
    }),
    oxwm.bar.block.static({
        text = "│",
        interval = 999999999,
        color = colors.lavender,
        underline = false,
    }),
    oxwm.bar.block.datetime({
        format = "󰃭 {}",
        date_format = "%a, %d %b - %-H:%M:%S",
        interval = 1,
        color = colors.cyan,
        underline = false,
    }),
    oxwm.bar.block.battery({
        format = "󰁹 {}%",
        charging = "󰂄 {}%",
        discharging = "󱟤 {}%",
        full = "󱟢 {}%",
        interval = 30,
        color = colors.green,
        underline = false,
    }),
};

-------------------------------------------------------------------------------
-- Basic Settings
-------------------------------------------------------------------------------
oxwm.set_terminal(terminal)
oxwm.set_modkey(modkey) -- This is for Mod + mouse binds, such as drag/resize
oxwm.set_tags(tags)

-------------------------------------------------------------------------------
-- Layouts
-------------------------------------------------------------------------------
-- Set custom symbols for layouts (displayed in the status bar)
-- Available layouts: "tiling", "normie" (floating), "grid", "monocle", "tabbed"
oxwm.set_layout_symbol("tiling", "[T]")
oxwm.set_layout_symbol("normie", "[F]")
oxwm.set_layout_symbol("tabbed", "[=]")

-------------------------------------------------------------------------------
-- Appearance
-------------------------------------------------------------------------------
-- Border configuration

-- Width in pixels
oxwm.border.set_width(0)
-- Color of focused window border
oxwm.border.set_focused_color(colors.blue)
-- Color of unfocused window borders
oxwm.border.set_unfocused_color(colors.grey)

-- Smart Enabled = No border if 1 window
oxwm.gaps.set_smart(disabled)
-- Inner gaps (horizontal, vertical) in pixels
oxwm.gaps.set_inner(0, 0)
-- Outer gaps (horizontal, vertical) in pixels
oxwm.gaps.set_outer(0, 0)

-------------------------------------------------------------------------------
-- Window Rules
-------------------------------------------------------------------------------
-- oxwm.rule.add({ instance = "gimp", floating = true })
-- oxwm.rule.add({ class = "Alacritty", tag = 9, focus = true })
-- oxwm.rule.add({ class = "firefox", title = "Library", floating = true })
-- oxwm.rule.add({ class = "firefox", tag = 2 })
oxwm.rule.add({ class = "gamescope", tag = 9 })
-- oxwm.rule.add({ instance = "mpv", floating = true })

-- To find window properties, use xprop and click on the window
-- WM_CLASS(STRING) shows both instance and class (instance, class)

-------------------------------------------------------------------------------
-- Status Bar Configuration
-------------------------------------------------------------------------------
-- Font configuration
oxwm.bar.set_font(bar_font)

-- Set your blocks here (defined above)
oxwm.bar.set_blocks(blocks)

-- Bar color schemes (for workspace tag display)
-- Parameters: foreground, background, border

-- Unoccupied tags
oxwm.bar.set_scheme_normal(colors.fg, colors.bg, "#444444")
-- Occupied tags
oxwm.bar.set_scheme_occupied(colors.cyan, colors.bg, colors.cyan)
-- Currently selected tag
oxwm.bar.set_scheme_selected(colors.cyan, colors.bg, colors.purple)
-- Urgent tags (windows requesting attention)
oxwm.bar.set_scheme_urgent(colors.red, colors.bg, colors.red)
-- Hide tags that have no windows and are not selected
oxwm.bar.set_hide_vacant_tags(true)

-------------------------------------------------------------------------------
-- Keybindings
-------------------------------------------------------------------------------
-- Basic window management

oxwm.key.bind({ modkey }, "Q", oxwm.spawn_terminal())
-- Launch Dmenu
oxwm.key.bind({ modkey, "Control" }, "Space", oxwm.spawn({ "sh", "-c", "dmenu_run -l 10" }))
oxwm.key.bind({ modkey }, "Space", oxwm.spawn({ "rofi -show drun" }))
-- Copy screenshot to clipboard
oxwm.key.bind({ modkey, "Shift" }, "S", oxwm.spawn({ "sh", "-c", "maim -s | xclip -selection clipboard -t image/png" }))
oxwm.key.bind({ modkey }, "W", oxwm.client.kill())

-- Keybind overlay - Shows important keybindings on screen
oxwm.key.bind({ modkey, "Shift" }, "Slash", oxwm.show_keybinds())

-- Window state toggles
oxwm.key.bind({ modkey, "Shift" }, "F", oxwm.client.toggle_fullscreen())
oxwm.key.bind({ modkey, "Shift" }, "Space", oxwm.client.toggle_floating())

-- Layout management
-- oxwm.key.bind({ modkey }, "F", oxwm.layout.set("normie"))
oxwm.key.bind({ modkey }, "T", oxwm.layout.set("tiling"))
oxwm.key.bind({ modkey }, "G", oxwm.layout.set("grid"))
-- Cycle through layouts
oxwm.key.bind({ modkey }, "N", oxwm.layout.cycle())

-- Master area controls (tiling layout)

-- Decrease/Increase master area width
oxwm.key.bind({ modkey, "Control" }, "Left", oxwm.set_master_factor(-5))
oxwm.key.bind({ modkey, "Control" }, "Right", oxwm.set_master_factor(5))
-- Increment/Decrement number of master windows
-- oxwm.key.bind({ modkey }, "I", oxwm.inc_num_master(1))
-- oxwm.key.bind({ modkey }, "P", oxwm.inc_num_master(-1))

-- Gaps toggle
oxwm.key.bind({ modkey, "Shift" }, "G", oxwm.toggle_gaps())

-- Window manager controls
oxwm.key.bind({ modkey, "Control" }, "W", oxwm.quit())
oxwm.key.bind({ modkey, "Control" }, "R", oxwm.restart())

-- Focus movement [1 for up in the stack, -1 for down]
oxwm.key.bind({ modkey }, "Right", oxwm.client.focus_stack(1))
oxwm.key.bind({ modkey }, "Left", oxwm.client.focus_stack(-1))
oxwm.key.bind({ modkey }, "Up", oxwm.client.focus_stack(1))
oxwm.key.bind({ modkey }, "Down", oxwm.client.focus_stack(-1))

-- Window movement (swap position in stack)
oxwm.key.bind({ modkey, "Shift" }, "Right", oxwm.client.move_stack(1))
oxwm.key.bind({ modkey, "Shift" }, "Left", oxwm.client.move_stack(-1))
oxwm.key.bind({ modkey, "Shift" }, "Up", oxwm.client.move_stack(1))
oxwm.key.bind({ modkey, "Shift" }, "Down", oxwm.client.move_stack(-1))

-- Multi-monitor support

-- Focus next/previous Monitors
-- oxwm.key.bind({ modkey }, "Comma", oxwm.monitor.focus(-1))
-- oxwm.key.bind({ modkey }, "Period", oxwm.monitor.focus(1))
-- Move window to next/previous Monitors
-- oxwm.key.bind({ modkey, "Shift" }, "Comma", oxwm.monitor.tag(-1))
-- oxwm.key.bind({ modkey, "Shift" }, "Period", oxwm.monitor.tag(1))

-- Workspace (tag) navigation
-- Switch to workspace N (tags are 0-indexed, so tag "1" is index 0)
oxwm.key.bind({ modkey }, "1", oxwm.tag.view(0))
oxwm.key.bind({ modkey }, "2", oxwm.tag.view(1))
oxwm.key.bind({ modkey }, "3", oxwm.tag.view(2))
oxwm.key.bind({ modkey }, "4", oxwm.tag.view(3))
oxwm.key.bind({ modkey }, "5", oxwm.tag.view(4))
oxwm.key.bind({ modkey }, "6", oxwm.tag.view(5))
oxwm.key.bind({ modkey }, "7", oxwm.tag.view(6))
oxwm.key.bind({ modkey }, "8", oxwm.tag.view(7))
oxwm.key.bind({ modkey }, "9", oxwm.tag.view(8))

-- Move focused window to workspace N
oxwm.key.bind({ modkey, "Shift" }, "1", oxwm.tag.move_to(0))
oxwm.key.bind({ modkey, "Shift" }, "2", oxwm.tag.move_to(1))
oxwm.key.bind({ modkey, "Shift" }, "3", oxwm.tag.move_to(2))
oxwm.key.bind({ modkey, "Shift" }, "4", oxwm.tag.move_to(3))
oxwm.key.bind({ modkey, "Shift" }, "5", oxwm.tag.move_to(4))
oxwm.key.bind({ modkey, "Shift" }, "6", oxwm.tag.move_to(5))
oxwm.key.bind({ modkey, "Shift" }, "7", oxwm.tag.move_to(6))
oxwm.key.bind({ modkey, "Shift" }, "8", oxwm.tag.move_to(7))
oxwm.key.bind({ modkey, "Shift" }, "9", oxwm.tag.move_to(8))

-- Combo view (view multiple tags at once) {argos_nothing}
-- Example: Mod+Ctrl+2 while on tag 1 will show BOTH tags 1 and 2
oxwm.key.bind({ modkey, "Control" }, "1", oxwm.tag.toggleview(0))
oxwm.key.bind({ modkey, "Control" }, "2", oxwm.tag.toggleview(1))
oxwm.key.bind({ modkey, "Control" }, "3", oxwm.tag.toggleview(2))
oxwm.key.bind({ modkey, "Control" }, "4", oxwm.tag.toggleview(3))
oxwm.key.bind({ modkey, "Control" }, "5", oxwm.tag.toggleview(4))
oxwm.key.bind({ modkey, "Control" }, "6", oxwm.tag.toggleview(5))
oxwm.key.bind({ modkey, "Control" }, "7", oxwm.tag.toggleview(6))
oxwm.key.bind({ modkey, "Control" }, "8", oxwm.tag.toggleview(7))
oxwm.key.bind({ modkey, "Control" }, "9", oxwm.tag.toggleview(8))

-- Multi tag (window on multiple tags)
-- Example: Mod+Ctrl+Shift+2 puts focused window on BOTH current tag and tag 2
oxwm.key.bind({ modkey, "Control", "Shift" }, "1", oxwm.tag.toggletag(0))
oxwm.key.bind({ modkey, "Control", "Shift" }, "2", oxwm.tag.toggletag(1))
oxwm.key.bind({ modkey, "Control", "Shift" }, "3", oxwm.tag.toggletag(2))
oxwm.key.bind({ modkey, "Control", "Shift" }, "4", oxwm.tag.toggletag(3))
oxwm.key.bind({ modkey, "Control", "Shift" }, "5", oxwm.tag.toggletag(4))
oxwm.key.bind({ modkey, "Control", "Shift" }, "6", oxwm.tag.toggletag(5))
oxwm.key.bind({ modkey, "Control", "Shift" }, "7", oxwm.tag.toggletag(6))
oxwm.key.bind({ modkey, "Control", "Shift" }, "8", oxwm.tag.toggletag(7))
oxwm.key.bind({ modkey, "Control", "Shift" }, "9", oxwm.tag.toggletag(8))

-- Custom keybinds
oxwm.key.bind({ modkey }, "B", oxwm.spawn({ "waterfox" }))
oxwm.key.bind({ modkey }, "E", oxwm.spawn({ "thunar" }))
oxwm.key.bind({ modkey }, "L", oxwm.spawn({ "~/.local/bin/lock.sh" }))
oxwm.key.bind({ modkey, "Shift" }, "P", oxwm.spawn({ "~/.local/bin/dunst-cpu.sh performance" }))
oxwm.key.bind({ modkey, "Control" }, "P", oxwm.spawn({ "~/.local/bin/dunst-cpu.sh powersaver" }))
oxwm.key.bind({ modkey, "Control" }, "S", oxwm.spawn({ "gamescope -w 1920 -h 1080 -r 144 steam" }))
oxwm.key.bind({ modkey, "Shift" }, "W", oxwm.spawn({ "feh --bg-scale --randomize ~/Pictures/Wallpapers/*" }))



-- Volume/Brightness with dunst script
oxwm.key.bind({ }, "XF86AudioRaiseVolume", oxwm.spawn({ "~/.local/bin/dunst-volume.sh +5%" }))
oxwm.key.bind({ }, "XF86AudioLowerVolume", oxwm.spawn({ "~/.local/bin/dunst-volume.sh -5%" }))
oxwm.key.bind({ }, "XF86AudioMute", oxwm.spawn({ "~/.local/bin/dunst-volume.sh toggle" }))
oxwm.key.bind({ }, "XF86MonBrightnessUp", oxwm.spawn({ "~/.local/bin/dunst-brightness.sh 5%+" }))
oxwm.key.bind({ }, "XF86MonBrightnessDown", oxwm.spawn({ "~/.local/bin/dunst-brightness.sh 5%-" }))

-------------------------------------------------------------------------------
-- Advanced: Keychords
-------------------------------------------------------------------------------
-- Keychords allow you to bind multiple-key sequences (like Emacs or Vim)
-- Format: {{modifiers}, key1}, {{modifiers}, key2}, ...
-- Example: Press Mod4+Space, then release and press T to spawn a terminal
-- oxwm.key.chord({
--     { { modkey }, "Space" },
--     { {},         "T" }
-- }, oxwm.spawn_terminal())

-------------------------------------------------------------------------------
-- Autostart
-------------------------------------------------------------------------------
-- Commands to run once when OXWM starts
-- Uncomment and modify these examples, or add your own

-- oxwm.autostart("dbus-update-activation-environment --all")
-- oxwm.autostart("gnome-keyring-daemon --start --components=secrets")
oxwm.autostart("picom")
oxwm.autostart("feh --bg-scale --randomize ~/Pictures/Wallpapers/*")
oxwm.autostart("dunst -startup_notification")
oxwm.autostart("wireplumber")
oxwm.autostart("pipewire")
oxwm.autostart("pipewire-pulse")
oxwm.autostart("brightnessctl set 25%")
oxwm.autostart("surge server start")
oxwm.autostart("~/.local/bin/lock.sh")
