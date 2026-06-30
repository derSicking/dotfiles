vim.pack.add({ {
	src = "https://github.com/mrcjkb/rustaceanvim",
} })

local lsp = require("lsp")

vim.g.rustaceanvim = {
	server = {
		on_attach = function()
			lsp.on_attach()
			lsp.add_inlay_hint_toggle_bind()
			vim.keymap.set("n", "<leader>f", function()
				vim.cmd.RustLsp("codeAction")
			end, { buffer = 0 })

			vim.keymap.set("n", "K", function()
				vim.cmd.RustLsp({ "hover", "actions" })
			end, { buffer = 0 })
		end,
		capabilities = lsp.capabilities,
	},
}
