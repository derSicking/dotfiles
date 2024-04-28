local snippetDir = "~/.config/nvim-snippets/"

return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "L3MON4D3/LuaSnip" },
			{ "saadparwaiz1/cmp_luasnip" },
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				sources = {
					{ name = "nvim_lsp_signature_help" },
					{ name = "path" },
					{ name = "nvim_lsp" },
					{ name = "nvim_lua" },
					{ name = "luasnip", keyword_length = 2 },
					{ name = "buffer", keyword_length = 3 },
				},
				mapping = cmp.mapping.preset.insert({
					["<cr>"] = cmp.mapping.confirm({ select = false }),
					["<Tab>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete(),
				}),
			})

			require("luasnip.loaders.from_vscode").lazy_load({
				paths = { snippetDir },
			})
		end,
	},
	{
		"chrisgrieser/nvim-scissors",
		opts = {
			snippetDir = snippetDir,
			jsonFormatter = "jq",
		},
		keys = {
			{
				"<leader>se",
				function()
					require("scissors").editSnippet()
				end,
			},
			{
				"<leader>sa",
				function()
					require("scissors").addNewSnippet()
				end,
			},
		},
	},
}
