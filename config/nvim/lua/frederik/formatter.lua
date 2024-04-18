local util = require("formatter.util")

return {
	filetype = {
		lua = {
			require("formatter.filetypes.lua").stylua,
		},
		javascript = {
			require("formatter.filetypes.javascript").prettierd,
			require("formatter.filetypes.javascript").eslint_d,
		},
		typescript = {
			require("formatter.filetypes.typescript").prettierd,
			require("formatter.filetypes.typescript").eslint_d,
		},
		html = {
			require("formatter.filetypes.html").prettierd,
		},
		css = {
			require("formatter.filetypes.css").prettierd,
		},
		markdown = {
			function()
				return {
					exe = "prettierd",
					args = { '--prose-wrap="always"', util.escape_path(util.get_current_buffer_file_path()) },
					stdin = true,
				}
			end,
		},
		java = {
			require("formatter.filetypes.java").google_java_format,
		},
	},
}
