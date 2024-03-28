return {
	filetype = {
		lua = {
			require("formatter.filetypes.lua").stylua,
		},
		javascript = {
			require("formatter.filetypes.javascript").prettier,
			require("formatter.filetypes.javascript").eslint_d,
		},
		typescript = {
			require("formatter.filetypes.typescript").prettier,
			require("formatter.filetypes.typescript").eslint_d,
		},
		html = {
			require("formatter.filetypes.html").prettier,
		},
		markdown = {
			require("formatter.filetypes.markdown").prettier,
		},
		java = {
			require("formatter.filetypes.java").google_java_format,
		},
	},
}
