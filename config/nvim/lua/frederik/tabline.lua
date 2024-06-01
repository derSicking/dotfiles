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
		if is_current then
			line = line .. "%#TablineSel#  " .. i .. " " .. vim.fs.basename(tag.path) .. "  %#Tabline#"
		else
			line = line .. "%#Tabline#  " .. i .. " " .. vim.fs.basename(tag.path) .. "  %#Tabline#"
		end
	end
	return line
end
