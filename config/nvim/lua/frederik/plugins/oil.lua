return {
	"stevearc/oil.nvim",
	lazy = false,
	priority = 500,
	dependencies = {
		{ "nvim-tree/nvim-web-devicons", lazy = true },
	},
	opts = {
		default_file_explorer = true,
		columns = {
			"icon",
			-- "permissions",
			-- "size",
			-- "mtime",
		},
		buf_options = {
			buflisted = false,
			bufhidden = "hide",
		},
		win_options = {
			wrap = false,
			signcolumn = "no",
			cursorcolumn = false,
			foldcolumn = "0",
			spell = false,
			list = false,
			concealcursor = "nvic",
		},
		delete_to_trash = true,
		skip_confirm_for_simple_edits = false,
		prompt_save_on_select_new_entry = true,
		cleanup_delay_ms = 2000,
		constrain_cursor = "name",
		use_default_keymaps = false,
		keymaps = {
			["g?"] = "actions.show_help",
			["<CR>"] = "actions.select",
			["<C-v>"] = "actions.preview",
			["<F5>"] = "actions.refresh",
			["-"] = "actions.parent",
			["_"] = "actions.open_cwd",
			["gs"] = "actions.change_sort",
			["gx"] = "actions.open_external",
			["g."] = "actions.toggle_hidden",
			["g\\"] = "actions.toggle_trash",
		},
		view_options = {
			show_hidden = false,
			is_hidden_file = function(name, bufnr)
				return vim.startswith(name, ".")
			end,
			is_always_hidden = function(name, bufnr)
				return false
			end,
			sort = {
				{ "type", "asc" },
				{ "name", "asc" },
			},
		},
	},
	keys = {
		{ "-", vim.cmd.Oil },
	},
}
