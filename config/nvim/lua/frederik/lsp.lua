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

		-- Debug Adapters
		"java-debug-adapter",

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
					vim.api.nvim_create_autocmd("LspAttach", {
						buffer = 0,
						group = vim.api.nvim_create_augroup("jdtls_start", {}),
						callback = function()
							require("jdtls.dap").setup_dap_main_class_configs()
						end,
					})
					require("jdtls").start_or_attach({
						cmd = { "jdtls" },
						init_options = {
							bundles = {
								vim.fn.stdpath("data")
									.. "/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar",
							},
						},
					})
					on_attach()
				end,
			})
		end,
	},
}
