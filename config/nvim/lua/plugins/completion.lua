local snippetDir = "~/.config/nvim-snippets/"

vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1") },
	{ src = "https://github.com/xzbdmw/colorful-menu.nvim" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
})

require("blink.cmp").setup({
	keymap = {
		preset = "none",

		["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },

		["<Up>"] = { "select_prev", "fallback" },
		["<Down>"] = { "select_next", "fallback" },
		["<Right>"] = { "accept", "fallback" },
		["<Left>"] = { "cancel", "fallback" },

		["<C-Up>"] = { "select_prev", "fallback" },
		["<C-Down>"] = { "show", "select_next", "fallback" },
		["<C-Right>"] = { "select_and_accept", "fallback" },
		["<C-Left>"] = { "cancel", "fallback" },

		["<C-k>"] = { "select_prev", "fallback" },
		["<C-j>"] = { "show", "select_next", "fallback" },
		["<C-l>"] = { "select_and_accept", "fallback" },
		["<C-h>"] = { "cancel", "fallback" },

		["<Tab>"] = {
			function(cmp)
				if cmp.snippet_active() then
					return cmp.accept()
				else
					return cmp.select_and_accept()
				end
			end,
			"snippet_forward",
			"fallback",
		},
		["<S-Tab>"] = { "snippet_backward", "fallback" },

		["<Enter>"] = { "accept", "fallback" },
	},

	signature = { enabled = true },

	completion = {
		list = { selection = { preselect = false, auto_insert = false } },

		keyword = { range = "prefix" },

		ghost_text = { enabled = true },

		menu = {
			draw = {
				columns = { { "kind_icon" }, { "label", gap = 1 }, { "kind" } },
				components = {
					label = {
						text = function(ctx)
							return require("colorful-menu").blink_components_text(ctx)
						end,
						highlight = function(ctx)
							return require("colorful-menu").blink_components_highlight(ctx)
						end,
					},
				},
			},
		},
	},

	appearance = {
		nerd_font_variant = "mono",
	},

	snippets = { preset = "luasnip" },

	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
		providers = {
			-- snippets = {
			-- 	opts = {
			-- 		search_paths = { snippetDir },
			-- 	},
			-- },
		},
	},
	fuzzy = { implementation = "prefer_rust_with_warning" },
})

require("luasnip.loaders.from_vscode").lazy_load({ paths = { snippetDir } })

local luasnip = require("luasnip")
local s, sn, d, i = luasnip.snippet, luasnip.snippet_node, luasnip.dynamic_node, luasnip.insert_node

luasnip.filetype_extend("all", { "global" })

local util = require("custom.utils")

luasnip.add_snippets("global", {
	s(
		{ trig = "uuid", name = "UUID", dscr = "Generate a unique UUID" },
		{ d(1, function()
			return sn(nil, i(1, util.uuid()))
		end) }
	),
})

luasnip.add_snippets("sql", {
	s({
		trig = "sqluuid",
		name = "UUID for SQL",
		dscr = "Generate a unique UUID without the dashes and surrounded by single quotes",
	}, {
		d(1, function()
			return sn(nil, i(1, "x'" .. util.uuid_no_dash() .. "'"))
		end),
	}),
})
