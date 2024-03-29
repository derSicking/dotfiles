local capabilities = require("cmp_nvim_lsp").default_capabilities()

local on_attach = function()
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
end

return {
	-- Tools to be installed with Mason
	ensure_installed = {
		-- Language Servers
		"lua_ls",
		"jdtls",
		"eslint-lsp",
		"typescript-language-server",
		"angular-language-server",
		"emmet-language-server",
		"html-lsp",
		"css-lsp",

		-- Formatters
		"stylua",
		"prettierd",
		"google-java-format",

		-- Linters
		"eslint_d",

		-- Tools
		"tree-sitter-cli",
		"jq",
	},
	-- LSP handlers for mason-lspconfig
	handlers = {
		-- Default Handler (lspconfig)
		function(server_name)
			require("lspconfig")[server_name].setup({ on_attach = on_attach, capabilities = capabilities })
		end,

		-- Java: ldtls-nvim
		["jdtls"] = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "java",
				group = vim.api.nvim_create_augroup("jdtls_start", {}),
				callback = function()
					require("jdtls").start_or_attach({
						cmd = { "jdtls" },
					})
					on_attach()
				end,
			})
		end,
	},
}
