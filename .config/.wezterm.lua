local wezterm = require 'wezterm'

-- Initialize config builder
local config = wezterm.config_builder()

-- Performance and Rendering Settings
config.front_end = "WebGpu" -- Use WebGpu for better performance (fallback to "OpenGL" if issues)
config.enable_wayland = false
config.animation_fps = 1 -- Minimal animations for speed
config.cursor_blink_rate = 1 -- Disable cursor blinking
config.max_fps = 60 -- Cap frame rate
config.automatically_reload_config = false
config.check_for_updates = false
config.enable_kitty_keyboard = false
config.enable_csi_u_key_encoding = false

-- Font Configuration
config.font = wezterm.font_with_fallback({
  -- Primary font
  {
    family = 'JetBrainsMono Nerd Font',
    weight = 'Regular',
  },
  -- Fallback fonts
  'Symbols Nerd Font',
--   'Cascadia Code',
--   'Courier New',
})
config.font_size = 12.0
config.freetype_load_target = "HorizontalLcd"
config.freetype_render_target = "HorizontalLcd"

-- Window Configuration
config.initial_rows = 30
config.initial_cols = 120
config.scrollback_lines = 3000 -- Reduced from default 3500 for better memory usage

-- Appearance
config.color_scheme = 'Campbell'

-- WSL2 Configuration
config.default_prog = { 'wsl.exe', '--cd', '~' }
config.default_cwd = '~'
config.wsl_domains = {
  {
    name = 'WSL:Ubuntu',
    distribution = 'Ubuntu',
    default_cwd = '~',
  },
}

-- Launch Menu
config.launch_menu = {
  {
    label = 'WSL2 Ubuntu',
    args = { 'wsl.exe', '-d', 'Ubuntu' },
  },
  {
    label = 'WSL2 Default',
    args = { 'wsl.exe' },
  },
  {
    label = 'PowerShell',
    args = { 'powershell.exe', '-NoLogo' },
  },
  {
    label = 'Command Prompt',
    args = { 'cmd.exe' },
  },
}

-- Key Bindings
config.keys = {
  {
    key = 'l',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ShowLauncher,
  },
  {
    key = 'r',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ReloadConfiguration,
  },
  -- Additional useful keybindings
  {
    key = 'c',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.CopyTo 'Clipboard',
  },
  {
    key = 'v',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.PasteFrom 'Clipboard',
  },
  {
    key = 'n',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SpawnWindow,
  },
  {
    key = 't',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 'w',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.CloseCurrentTab { confirm = true },
  },
  {
    key = 'PageUp',
    mods = 'SHIFT',
    action = wezterm.action.ScrollByPage(-1),
  },
  {
    key = 'PageDown',
    mods = 'SHIFT',
    action = wezterm.action.ScrollByPage(1),
  },
}

-- Platform-specific font directories
local font_dirs = {}
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  -- Windows font directories
  font_dirs = {
    'C:\\Windows\\Fonts',
    '%USERPROFILE%\\NerdFontsSymbolsOnly',
    wezterm.home_dir .. '\\.fonts',
    wezterm.config_dir .. '\\fonts',
  }
else
  -- Linux/macOS font directories
  font_dirs = {
    wezterm.home_dir .. '/.local/share/fonts',
    wezterm.home_dir .. '/.fonts',
    '/usr/share/fonts',
    '/usr/local/share/fonts',
    wezterm.config_dir .. '/fonts',
  }
end

-- Apply font directories if using custom fonts
if #font_dirs > 0 then
  config.font_dirs = font_dirs
end

-- Additional optimizations for Windows/WSL2
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  -- Windows-specific optimizations
  config.prefer_egl = false
  
  -- Set process priority (optional)
  config.win32_system_backdrop = 'Disable'
end

-- Environment-specific overrides (optional)
-- This allows you to have a local_overrides.lua file for machine-specific settings
local overrides_file = wezterm.config_dir .. '/local_overrides.lua'
local ok, overrides = pcall(dofile, overrides_file)
if ok and type(overrides) == 'table' then
  -- Apply overrides to config
  for k, v in pairs(overrides) do
    config[k] = v
  end
end

-- Config validation helper (optional)
config.debug_key_events = false

-- Return the configuration to WezTerm
return config