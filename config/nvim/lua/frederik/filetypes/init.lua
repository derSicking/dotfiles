vim.filetype.add({
	extension = {
		["http"] = "http",
	},
})

require("frederik.filetypes.java")
require("frederik.filetypes.go")
require("frederik.filetypes.lua")
require("frederik.filetypes.markdown")
