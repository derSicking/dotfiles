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
			tag_string = vim.fs.basename(tag.path)
		end
		if not tag_string or string.len(tag_string) == 0 and tag.path:sub(1, 6) == "oil://" then
			local cwd = vim.loop.cwd()
			if not cwd then
				tag_string = tag.path:sub(7)
			else
				tag_string = tag.path:sub(string.len(cwd) + 7)
			end
		end
		if not tag_string or string.len(tag_string) == 0 then
			tag_string = tag.path
		end
		if is_current then
			line = line .. "%#TablineSel#  " .. i .. " " .. tag_string .. "  %#Tabline#"
		else
			line = line .. "%#Tabline#  " .. i .. " " .. tag_string .. "  %#Tabline#"
		end
	end
	return line
end
