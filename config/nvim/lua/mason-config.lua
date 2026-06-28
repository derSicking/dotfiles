return {
	-- Tools to be installed with Mason
	ensure_installed = {
		-- Language Servers
		"lua_ls",
		"eslint-lsp",
		"typescript-language-server",
		"emmet-language-server",
		"html-lsp",
		"css-lsp",
		"gopls",
		"yamlls",
		"helm_ls",
		"kotlin_lsp",
		"clangd",
		"rust-analyzer",
		"wgsl-analyzer",

		-- Formatters
		"stylua",
		"prettierd",

		-- Linters
		"eslint_d",

		-- Debug Adapters

		-- Tools
		"tree-sitter-cli",
		"jq",
	},

	automatic_enable_exclude = {
		"rust-analyzer",
	},
}
