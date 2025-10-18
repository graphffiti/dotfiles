local wezterm = require("wezterm")

-- Initialize config builder
local config = wezterm.config_builder()

-- Performance and Rendering Settings
config.front_end = "WebGpu"
config.enable_wayland = false
config.animation_fps = 1
config.cursor_blink_rate = 800
config.max_fps = 60
config.automatically_reload_config = false
config.check_for_updates = false
config.enable_kitty_keyboard = false
config.enable_csi_u_key_encoding = false

-- Font Configuration
config.font = wezterm.font_with_fallback({
	{
		family = "JetBrainsMono Nerd Font",
		weight = "Regular",
	},
	"JetBrainsMono Nerd Font",
})
config.font_size = 12.0
config.freetype_load_target = "HorizontalLcd"
config.freetype_render_target = "HorizontalLcd"

-- Window Configuration
config.initial_rows = 30
config.initial_cols = 120
config.scrollback_lines = 3000
config.window_decorations = "RESIZE"
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.show_tabs_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = false
-- Appearance
--config.color_scheme = 'Campbell'
config.color_scheme = "Grey-green"
local scheme = wezterm.color.get_builtin_schemes()[config.color_scheme]
-- config.line_height = 1.2
config.line_height = 1
config.colors = {
	cursor_bg = "#BA8E23",
	tab_bar = {
		background = scheme.background,

		inactive_tab = {
			bg_color = scheme.background,
			fg_color = "#808080",
		},

		active_tab = {
			bg_color = scheme.background,
			fg_color = scheme.foreground, -- Also use scheme's foreground
		},
	},
}

config.window_background_opacity = 0.85
config.win32_system_backdrop = "Acrylic"

-- WSL2 Configuration
--config.default_prog = { 'wsl.exe', '--cd', '~' }
config.default_cwd = "~"
config.wsl_domains = {
	{
		name = "WSL:Ubuntu-22.04",
		distribution = "Ubuntu-22.04",
		default_cwd = "~",
	},
	{
		name = "WSL:graphffiti-linux",
		distribution = "graphffiti-linux",
		default_cwd = "~",
	},
	{
		name = "WSL:archlinux",
		distribution = "archlinux",
		default_cwd = "~",
	},
}
config.default_domain = "WSL:archlinux"

-- SSH Domains
-- config.ssh_domains = {
--     {
--       name = 'myremote',
--       remote_address = 'myremote',  -- this matches your ~/.ssh/config inside WSL
--       multiplexing = 'None',        -- optional, avoids nesting muxes
--       remote_wezterm_path = nil,    -- use remote wezterm if installed
--       assume_shell = 'bash',        -- optional
--       connect_via_domain = 'WSL:Ubuntu',  -- 🔥 tells WezTerm to run ssh from inside WSL
--     },
-- }
-- Launch Menu
config.launch_menu = {
	{
		label = "WSL2 Ubuntu",
		args = { "wsl.exe", "-d", "Ubuntu" },
	},
	{
		label = "WSL2 Default",
		args = { "wsl.exe" },
	},
	{
		label = "PowerShell",
		args = { "powershell.exe", "-NoLogo" },
	},
	{
		label = "Command Prompt",
		args = { "cmd.exe" },
	},
}

-- Key Bindings
config.keys = {
	{
		key = "`",
		mods = "CTRL",
		action = wezterm.action.ShowLauncher,
	},
	{
		key = "r",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ReloadConfiguration,
	},
	{
		key = "c",
		mods = "CTRL|SHIFT",
		action = wezterm.action.CopyTo("Clipboard"),
	},
	{
		key = "v",
		mods = "CTRL|SHIFT",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
	{
		key = "n",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SpawnWindow,
	},
	{
		key = "t",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "t",
		mods = "ALT",
		action = wezterm.action.SpawnCommandInNewTab({
			domain = "CurrentPaneDomain",
			cwd = "~",
		}),
	},
	{
		key = "w",
		mods = "CTRL|SHIFT",
		action = wezterm.action.CloseCurrentTab({ confirm = false }),
	},
	{
		key = "w",
		mods = "ALT",
		action = wezterm.action_callback(function(window, pane)
			window:perform_action(wezterm.action.CloseCurrentTab({ confirm = false }), pane)
			-- Force refresh
			window:perform_action(wezterm.action.Nop, pane)
		end),
	},
	{
		key = "PageUp",
		mods = "SHIFT",
		action = wezterm.action.ScrollByPage(-1),
	},
	{
		key = "PageDown",
		mods = "SHIFT",
		action = wezterm.action.ScrollByPage(1),
	},
}

-- ADDED: Mouse behavior for copy/paste
config.mouse_bindings = {
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = wezterm.action_callback(function(window, pane)
			local sel = window:get_selection_text_for_pane(pane)
			if sel ~= "" then
				window:perform_action(wezterm.action.CopyTo("ClipboardAndPrimarySelection"), pane)
			end
		end),
	},
}

-- Platform-specific font directories
local font_dirs = {}
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	local homedrive = os.getenv("HOMEDRIVE")
	font_dirs = {
		homedrive .. "\\embedded-programs\\fonts\\",
		wezterm.home_dir .. "\\.fonts",
		wezterm.config_dir .. "\\fonts",
	}
else
	font_dirs = {
		wezterm.home_dir .. "/.local/share/fonts",
		wezterm.home_dir .. "/.fonts",
		"/usr/share/fonts",
		"/usr/local/share/fonts",
		wezterm.config_dir .. "/fonts",
	}
end
if #font_dirs > 0 then
	config.font_dirs = font_dirs
end

-- Additional Windows/WSL2 Optimizations
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.prefer_egl = false
	config.win32_system_backdrop = "Disable"
end

-- Local overrides
local overrides_file = wezterm.config_dir .. "/local_overrides.lua"
local ok, overrides = pcall(dofile, overrides_file)
if ok and type(overrides) == "table" then
	for k, v in pairs(overrides) do
		config[k] = v
	end
end

config.debug_key_events = false

-- ADDED: Tab title customization for WSL
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

config.tab_max_width = 25
-- wezterm.on("format-tab-title", function(tab)
--   local pane_title = tab.active_pane.title
--   if pane_title:find("wslhost.exe") then
--     return { { Text = " WSL " } }
--   else
--     return { { Text = " " .. pane_title .. " " } }
--   end
-- end)

-- wezterm.on("format-tab-title", function(tab)
--   local tab_index = tab.tab_index + 1  -- Convert from 0-based to 1-based
--   return { { Text = string.format(" %d ", tab_index) } }
-- end)
-- Force tab bar refresh on tab close
-- wezterm.on('window-config-reloaded', function(window, pane)
--   window:perform_action(wezterm.action.Nop, pane)
-- end)

-- wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
--   local tab_index = tab.tab_index + 1
--   return { { Text = string.format(" %d ", tab_index) } }
-- end)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	-- Force recalculation each time
	local actual_index = 0
	for i, t in ipairs(tabs) do
		if t.tab_id == tab.tab_id then
			actual_index = i
			break
		end
	end
	return { { Text = string.format(" %d ", actual_index) } }
end)

-- wezterm.on("update-right-status", function(window, pane)
--   local workspace = window:active_workspace()
--   local tab_count = #window:tabs()
--   window:set_right_status(tab_count)

--   window:set_left_status 'left'
-- end)

-- config.use_fancy_tab_bar = false
-- config.show_tabs_in_tab_bar = false
config.automatically_reload_config = true

-- Return final config
return config

