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
			local luasnip = require("luasnip")

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
					["<c-j>"] = cmp.mapping(function()
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.locally_jumpable(1) then
							luasnip.jump(1)
						else
							cmp.complete()
						end
					end),
					["<c-k>"] = cmp.mapping(function()
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							cmp.complete()
						end
					end),
					["<cr>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							if luasnip.expandable() then
								luasnip.expand()
							else
								cmp.confirm({ select = false })
							end
						else
							fallback()
						end
					end),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							if luasnip.expandable() then
								luasnip.expand()
							else
								cmp.confirm({ select = true })
							end
						else
							fallback()
						end
					end),
					["<c-l>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							if luasnip.expandable() then
								luasnip.expand()
							else
								cmp.confirm({ select = true })
							end
						else
							fallback()
						end
					end),
					["<c-h>"] = cmp.mapping.abort(),
				}),
			})

			local cmp_kind = cmp.lsp.CompletionItemKind
			cmp.event:on("confirm_done", function(evt)
				if vim.tbl_contains({ cmp_kind.Function, cmp_kind.Method }, evt.entry:get_completion_item().kind) then
					vim.api.nvim_feedkeys(
						"()" .. vim.api.nvim_replace_termcodes("<Left>", true, true, true),
						"n",
						false
					)
				end
			end)

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
