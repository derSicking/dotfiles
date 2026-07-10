vim.pack.add({ { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } })

local function get_darkman_mode()
	local handle = io.popen("darkman get 2>/dev/null")
	if handle then
		local result = vim.trim(handle:read("*a") or "")
		handle:close()
		if result == "dark" or result == "light" then
			return result
		end
	end
	-- fallback: check gsettings color-scheme
	local gs_handle = io.popen("gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null")
	if gs_handle then
		local val = gs_handle:read("*a") or ""
		gs_handle:close()
		if val:find("prefer%-dark") then
			return "dark"
		end
		if val:find("prefer%-light") then
			return "light"
		end
	end
	return "light" -- safe default
end

local function get_flavor(mode)
	return (mode == "dark") and "macchiato" or "latte"
end

local function switch_theme(mode)
	-- pcall in case catppuccin hasn't fully initialised
	pcall(require("catppuccin").load, get_flavor(mode))
end

-- Initial setup: detect mode and configure catppuccin
local current_mode = get_darkman_mode()
require("catppuccin").setup({
	flavour = get_flavor(current_mode),
})

vim.cmd.colorscheme("catppuccin")

-- Live switch: catch SIGUSR1 sent by darkman hook
vim.api.nvim_create_autocmd("Signal", {
	pattern = "SIGUSR1",
	callback = function()
		local mode = get_darkman_mode()
		if mode then
			switch_theme(mode)
		end
	end,
})
