local utils = require("custom.utils")

local capabilities = require("blink.cmp").get_lsp_capabilities()

local rename_symbol = function()
	local old_name = vim.fn.expand("<cword>")
	local new_name = vim.fn.input("Rename " .. old_name .. ": ")
	if new_name and string.len(new_name) > 0 then
		vim.lsp.buf.rename(new_name)
	end
end

local on_attach = function()
	vim.keymap.set({ "n", "v" }, "<leader>f", vim.lsp.buf.code_action, { buffer = 0 })
	vim.keymap.set("n", "<leader>rn", rename_symbol, { buffer = 0 })
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
	vim.keymap.set("n", "gd", function()
		require("snacks").picker.lsp_definitions()
	end, { buffer = 0 })
	vim.keymap.set("n", "gr", function()
		require("snacks").picker.lsp_references()
	end, { buffer = 0 })
	vim.keymap.set("n", "dp", function()
		require("snacks").picker.diagnostics_buffer()
	end, { buffer = 0 })
	vim.keymap.set("n", "dP", function()
		require("snacks").picker.diagnostics()
	end, { buffer = 0 })
end

local add_inlay_hint_toggle_bind = function()
	vim.keymap.set("n", "<leader>ih", function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
	end, { buffer = 0 })
end

-- Set up angularls without mason to have control over the version via package.json
local get_probe_dir = function(root_dir)
	local project_root = vim.fs.dirname(vim.fs.find("node_modules", { path = root_dir, upward = true })[1])
	return project_root and (project_root .. "/node_modules") or ""
end

local default_probe_dir = get_probe_dir(vim.fn.getcwd())

vim.lsp.config("angularls", {
	cmd = {
		"npx",
		"ngserver",
		"--stdio",
		"--tsProbeLocations",
		default_probe_dir,
		"--ngProbeLocations",
		default_probe_dir,
		"--angularCoreVersion",
	},
	on_new_config = function(new_config, new_root_dir)
		local new_probe_dir = get_probe_dir(new_root_dir)
		new_config.cmd = {
			"npx",
			"ngserver",
			"--stdio",
			"--tsProbeLocations",
			new_probe_dir,
			"--ngProbeLocations",
			new_probe_dir,
			"--angularCoreVersion",
		}
	end,
	capabilities = capabilities,
	on_attach = on_attach,
	flags = {
		allow_incremental_sync = false,
		debounce_text_changes = 500,
	},
})

vim.lsp.config("*", {
	on_attach = on_attach,
	capabilities = capabilities,
})

vim.lsp.config("clangd", {
	cmd = {
		"clangd",
		"--background-index",
		"--query-driver=/home/frederik/.espressif/tools/xtensa-esp-elf/esp-14.2.0_20241119/xtensa-esp-elf/xtensa-esp-elf/bin/xtensa-esp32-elf-gcc",
		"--compile-commands-dir=" .. vim.fn.getcwd() .. "/build",
	},
	on_attach = function()
		on_attach()
		add_inlay_hint_toggle_bind()
	end,
	capabilities = capabilities,
})

vim.lsp.config("rust_analyzer", {
	on_attach = function()
		on_attach()
		add_inlay_hint_toggle_bind()
	end,
	capabilities = capabilities,
	settings = {
		["rust-analyzer"] = {
			check = {
				command = "clippy",
			},
		},
	},
})

vim.lsp.config("helm_ls", {
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "yaml", "tpl", "helm", "yaml.helm-values" },
	settings = {
		["helm-ls"] = {
			yamlls = {
				path = "yaml-language-server",
			},
		},
	},
})

vim.lsp.config("emmet_language_server", {
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "html", "htmlangular" },
})

vim.lsp.config("html", {
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "html", "htmlangular" },
})

vim.lsp.config("lua_ls", {
	on_attach = function()
		on_attach()
		add_inlay_hint_toggle_bind()
	end,
	capabilities = capabilities,
	settings = { Lua = { hint = { enable = true } } },
})

vim.lsp.config("eslint", {
	on_attach = function()
		on_attach()
	end,
	capabilities = capabilities,
	flags = {
		allow_incremental_sync = false,
		debounce_text_changes = 3000,
	},
})

vim.lsp.config("ts_ls", {
	on_attach = function()
		on_attach()
		add_inlay_hint_toggle_bind()
	end,
	capabilities = capabilities,
	flags = {
		allow_incremental_sync = false,
		debounce_text_changes = 500,
	},
	settings = {
		completions = {
			completeFunctionCalls = true,
		},
		javascript = {
			inlayHints = {
				includeInlayEnumMemberValueHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayVariableTypeHints = false,
			},
		},

		typescript = {
			inlayHints = {
				includeInlayEnumMemberValueHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayVariableTypeHints = false,
			},
		},
	},
})

return { on_attach = on_attach, capabilities = capabilities }
