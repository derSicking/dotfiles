local utils = require("frederik.utils")

local get_short_buf_name = function()
	return utils.shorten_buf_name(vim.fn.bufname())
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		sections = {
			lualine_c = { get_short_buf_name },
			lualine_x = { "encoding", "filetype" },
		},
	},
}
