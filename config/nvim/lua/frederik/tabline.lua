local grapple = require("grapple")
local utils = require("frederik.utils")

local update_showtabline = function()
	local tags = grapple.tags()
	if tags and tags[1] then
		vim.opt.showtabline = 2
	else
		vim.opt.showtabline = 0
	end
	vim.cmd.redrawtabline()
end

vim.api.nvim_create_autocmd("User", {
	pattern = "GrappleUpdate",
	group = vim.api.nvim_create_augroup("grapple-update", { clear = true }),
	callback = update_showtabline,
})

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
			tag_string = utils.shorten_buf_name(tag.path)
		end
		if is_current then
			line = line .. "%#TablineSel#  " .. i .. " " .. tag_string .. "  %#Tabline#"
		else
			line = line .. "%#Tabline#  " .. i .. " " .. tag_string .. "  %#Tabline#"
		end
	end

	if not current_tag then
		local cur_name = utils.shorten_buf_name(vim.fn.bufname())
		if cur_name and string.len(cur_name) > 0 then
			line = line .. "%#Tabline#  %#TablineSel# %#TablineFill# " .. cur_name .. "  %#Tabline#"
		end
	end

	return line
end

vim.opt.tabline = "%!v:lua.tabline()"
update_showtabline()
