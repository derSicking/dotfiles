local utils = require("frederik.utils")

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local ltex_lang = "en-US"

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
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
	vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = 0 })
	vim.keymap.set("n", "<leader>dj", vim.diagnostic.goto_next, { buffer = 0 })
	vim.keymap.set("n", "<leader>dk", vim.diagnostic.goto_prev, { buffer = 0 })
end

local add_inlay_hint_toggle_bind = function()
	vim.keymap.set("n", "<leader>ih", function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
	end, { buffer = 0 })
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
		"ltex-ls",

		-- Formatters
		"stylua",
		"prettierd",

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

		-- Lua
		["lua_ls"] = function()
			require("lspconfig")["lua_ls"].setup({
				on_attach = function()
					on_attach()
					add_inlay_hint_toggle_bind()
				end,
				capabilities = capabilities,
				settings = { Lua = { hint = { enable = true } } },
			})
		end,

		-- Latex and Markdown: ltex-client.nvim
		["ltex"] = function()
			local ltex_path = vim.env.HOME .. "/.ltex/dictionaries"
			local ltex_language_settings_path = ltex_path .. "/language_settings.json"
			require("ltex-client").setup({
				user_dictionaries_path = ltex_path,
			})
			local settingsFromFile = utils.get_json_file_as_table(ltex_language_settings_path)
			if settingsFromFile ~= nil then
				for _, setting in ipairs(settingsFromFile) do
					if setting.dir == vim.fn.getcwd() then
						ltex_lang = setting.lang
						break
					end
				end
			end
			require("lspconfig")["ltex"].setup({
				on_attach = function(_, bufnr)
					on_attach()
					require("ltex-client.server").update_configuration({ language = ltex_lang })
					vim.api.nvim_buf_create_user_command(bufnr, "SetProjectLanguage", function(args)
						local allLanguageSettings = utils.get_json_file_as_table(ltex_language_settings_path)
						if allLanguageSettings == nil then
							allLanguageSettings = {}
						end
						local exists = false
						for _, setting in ipairs(allLanguageSettings) do
							if setting.dir == vim.fn.getcwd() then
								exists = true
								setting.lang = args.args
								break
							end
						end
						if not exists then
							table.insert(allLanguageSettings, { dir = vim.fn.getcwd(), lang = args.args })
						end
						utils.store_table_as_json(ltex_language_settings_path, allLanguageSettings)
						require("ltex-client.server").update_configuration({ language = args.args })
					end, { nargs = 1 })
				end,
				capabilities = capabilities,
				filetypes = {
					"tex",
					"latex",
					"markdown",
					"text",
				},
				settings = {
					ltex = {
						language = ltex_lang,
					},
				},
			})
		end,

		-- Java: ldtls-nvim
		["jdtls"] = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "java",
				group = vim.api.nvim_create_augroup("jdtls_start", { clear = true }),
				callback = function()
					vim.api.nvim_create_autocmd("LspAttach", {
						buffer = 0,
						group = vim.api.nvim_create_augroup("jdtls_dap_start", { clear = true }),
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
						settings = {
							java = {
								inlayHints = { parameterNames = { enabled = "all" } },
								signatureHelp = { enabled = true },
							},
						},
					})
					on_attach()
					add_inlay_hint_toggle_bind()
				end,
			})
		end,
	},
}
