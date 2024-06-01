vim.opt.showtabline = 2
vim.opt.tabline = "%!v:lua.tabline()"

_G.tabline = function()
	local grapple = require("grapple")
	local current_tag = grapple.find({ path = vim.fn.bufname() })

	local line = ""

	local tags = grapple.tags()
	if not tags then
		return ""
	end
	for i, tag in ipairs(tags) do
		local is_current = current_tag and current_tag.path == tag.path
		if is_current then
			line = line .. "%#TablineSel#  " .. i .. " " .. vim.fs.basename(tag.path) .. "  %#Tabline#"
		else
			line = line .. "%#Tabline#  " .. i .. " " .. vim.fs.basename(tag.path) .. "  %#Tabline#"
		end
	end
	return line
end
