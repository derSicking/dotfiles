local snippetDir = "~/.config/nvim-snippets/"

return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "L3MON4D3/LuaSnip" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "onsails/lspkind.nvim" },
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				preselect = "None",
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				sources = {
					{ name = "path" },
					{ name = "nvim_lsp", group_index = 1 },
					{ name = "nvim_lua" },
					{ name = "luasnip", keyword_length = 2 },
					{ name = "buffer", keyword_length = 3, group_index = 2 },
				},
				view = {
					docs = {
						auto_open = true,
					},
					entries = {
						name = "custom",
						selection_order = "top_down",
						follow_cursor = true,
					},
				},
				formatting = {
					fields = { "abbr", "kind", "menu" },
					expandable_indicator = false,
					format = require("lspkind").cmp_format({
						mode = "symbol_text",
						menu = {
							path = "[Path]",
							nvim_lsp = "[LSP]",
							nvim_lua = "[Lua]",
							luasnip = "[LuaSnip]",
							buffer = "[Buffer]",
						},
					}),
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
						if cmp.visible() and cmp.get_active_entry() then
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
								cmp.confirm({ select = false })
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
				local cmp_item = evt.entry:get_completion_item()
				if
					vim.tbl_contains({ cmp_kind.Function, cmp_kind.Method }, cmp_item.kind)
					and (not cmp_item.textEdit or not string.match(cmp_item.textEdit.newText, ".*%(.*%).*"))
				then
					if vim.bo.filetype == "tex" then
						vim.api.nvim_feedkeys(
							"{}" .. vim.api.nvim_replace_termcodes("<Left>", true, true, true),
							"n",
							false
						)
					else
						vim.api.nvim_feedkeys(
							"()" .. vim.api.nvim_replace_termcodes("<Left>", true, true, true),
							"n",
							false
						)
					end
				elseif vim.tbl_contains({ cmp_kind.Property }, cmp_item.kind) and cmp_item.textEdit then
					-- Terrible spaghetti vim :s commands to fix double bracktes on Angular HTML template attributes
					if string.sub(cmp_item.textEdit.newText, 1, 1) == "(" then
						local col = vim.api.nvim_win_get_cursor(0)[2] - string.len(cmp_item.textEdit.newText) - 1
						vim.api.nvim_feedkeys(
							vim.api.nvim_replace_termcodes("<esc>", true, true, true)
								.. ":s/\\%>"
								.. col
								.. "c)\\+/)/"
								.. vim.api.nvim_replace_termcodes("<cr>", true, true, true)
								.. ":s/\\%>"
								.. col
								.. "c(\\+/(/"
								.. vim.api.nvim_replace_termcodes("<cr>", true, true, true),
							"n",
							false
						)
						vim.api.nvim_feedkeys(col .. "lf)a", "n", false)
					elseif string.sub(cmp_item.textEdit.newText, 1, 1) == "[" then
						local col = vim.api.nvim_win_get_cursor(0)[2] - string.len(cmp_item.textEdit.newText) - 1
						vim.api.nvim_feedkeys(
							vim.api.nvim_replace_termcodes("<esc>", true, true, true)
								.. ":s/\\%>"
								.. col
								.. "c]\\+/]/"
								.. vim.api.nvim_replace_termcodes("<cr>", true, true, true)
								.. ":s/\\%>"
								.. col
								.. "c\\[\\+/[/"
								.. vim.api.nvim_replace_termcodes("<cr>", true, true, true),
							"n",
							false
						)
						vim.api.nvim_feedkeys(col .. "lf]a", "n", false)
					end
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
