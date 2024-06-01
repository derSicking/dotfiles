vim.opt.showtabline = 2
vim.opt.tabline = "%!v:lua.tabline()"

local grapple = require("grapple")

vim.api.nvim_create_autocmd("User", {
	pattern = "GrappleUpdate",
	group = vim.api.nvim_create_augroup("grapple-update", { clear = true }),
	callback = function()
		local tags = grapple.tags()
		if tags and tags[1] then
			vim.opt.showtabline = 2
		else
			vim.opt.showtabline = 0
		end
		vim.cmd.redrawtabline()
	end,
})

local path_to_tab_name = function(path)
	local name = vim.fs.basename(path)
	if not name or string.len(name) == 0 and path:sub(1, 6) == "oil://" then
		local cwd = vim.loop.cwd()
		if not cwd then
			name = path:sub(7)
		else
			name = path:sub(string.len(cwd) + 7)
		end
	end
	if not name or string.len(name) == 0 then
		name = path
	end
	return name
end

_G.tabline = function()
	local current_tag = grapple.find({ path = vim.fn.bufname() })

	local line = ""

	local tags = grapple.tags()
	if not tags then
		return ""
	end
	for i, tag in ipairs(tags) do
		local is_current = current_tag and current_tag.path == tag.path
		local tag_string = tag.name
		if not tag_string or string.len(tag_string) == 0 then
			tag_string = path_to_tab_name(tag.path)
		end
		if is_current then
			line = line .. "%#TablineSel#  " .. i .. " " .. tag_string .. "  %#Tabline#"
		else
			line = line .. "%#Tabline#  " .. i .. " " .. tag_string .. "  %#Tabline#"
		end
	end

	if not current_tag then
		local cur_name = path_to_tab_name(vim.fn.bufname())
		if cur_name and string.len(cur_name) > 0 then
			line = line .. "%#Tabline#  %#TablineSel# %#TablineFill# " .. cur_name .. "  %#Tabline#"
		end
	end

	return line
end
