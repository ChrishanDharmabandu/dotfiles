local wezterm = require 'wezterm'
local act = wezterm.action

local config = wezterm.config_builder()

-- Appearance
config.font = wezterm.font_with_fallback({
  "MesloLGS Nerd Font Mono",
})
config.font_size = 15
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.75
config.win32_system_backdrop = 'Acrylic'
config.color_scheme = 'One Dark'

-- Window padding
config.window_padding = {
  left = 15,
  right = 15,
  top = 15,
  bottom = 15,
}

-- Cursor customization
config.default_cursor_style = 'SteadyBar'
config.cursor_blink_rate = 800

-- Key bindings
config.keys = {
  -- Split panes
  { key = '|', mods = 'CTRL|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '_', mods = 'CTRL|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  -- Navigate panes
  { key = 'h', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Left' },
  { key = 'l', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Right' },
  { key = 'k', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Up' },
  { key = 'j', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Down' },
  -- Adjust pane size
  { key = 'H', mods = 'CTRL|SHIFT|ALT', action = act.AdjustPaneSize { 'Left', 5 } },
  { key = 'L', mods = 'CTRL|SHIFT|ALT', action = act.AdjustPaneSize { 'Right', 5 } },
  { key = 'K', mods = 'CTRL|SHIFT|ALT', action = act.AdjustPaneSize { 'Up', 5 } },
  { key = 'J', mods = 'CTRL|SHIFT|ALT', action = act.AdjustPaneSize { 'Down', 5 } },
  -- Quick opacity adjustment
  -- { key = ']', mods = 'CTRL', action = act.IncrementOpacity },
  -- { key = '[', mods = 'CTRL', action = act.DecrementOpacity },
}

-- Custom right-click context menu
config.mouse_bindings = {
  -- Right click
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = wezterm.action_callback(function(window, pane)
      local selection = window:get_selection_text_for_pane(pane)
      if selection ~= '' then
        window:perform_action(
          act.CopyTo 'ClipboardAndPrimarySelection',
          pane
        )
      else
        window:perform_action(act.PasteFrom 'Clipboard', pane)
      end
    end),
  },
}

return config
