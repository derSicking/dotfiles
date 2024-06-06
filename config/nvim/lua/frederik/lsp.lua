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

local get_devcontainer_workspace_folder = function(project_dir, callback)
	vim.fn.jobstart({ "devcontainer", "read-configuration", "--workspace-folder", project_dir }, {
		on_stdout = function(_, data, _)
			for _, str in ipairs(data) do
				if str and string.len(str) > 0 then
					local jq_job = vim.fn.jobstart({ "jq", "-r", ".workspace.workspaceFolder" }, {
						on_stdout = function(_, jq_out, _)
							for _, workspace in ipairs(jq_out) do
								if workspace and string.len(workspace) > 0 then
									callback(project_dir, workspace)
								end
							end
						end,
						on_exit = function(_, _, _) end,
					})
					vim.fn.chansend(jq_job, str)
					vim.fn.chanclose(jq_job, "stdin")
				end
			end
		end,
		on_exit = function(_, _, _) end,
	})
	return "/workspaces/open-web-vault/"
end

-- Set up angularls without mason to have control over the version via package.json
local lsputil = require("lspconfig.util")

local get_probe_dir = function(root_dir)
	local project_root = lsputil.find_node_modules_ancestor(root_dir)
	return project_root and (project_root .. "/node_modules") or ""
end

local default_probe_dir = get_probe_dir(vim.fn.getcwd())

require("lspconfig")["angularls"].setup({
	cmd = {
		"npx",
		"ngserver",
		"--stdio",
		"--tsProbeLocations",
		default_probe_dir,
		"--ngProbeLocations",
		default_probe_dir,
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
		}
	end,
	capabilities = capabilities,
	on_attach = on_attach,
})

return {
	-- Tools to be installed with Mason
	ensure_installed = {
		-- Language Servers
		"lua_ls",
		"jdtls",
		"eslint-lsp",
		"typescript-language-server",
		"emmet-language-server",
		"html-lsp",
		"css-lsp",
		"ltex-ls",
		"texlab",

		-- Formatters
		"stylua",
		"prettierd",
		"google-java-format",
		"xmlformatter",
		"latexindent",

		-- Linters
		"eslint_d",

		-- Debug Adapters
		"java-debug-adapter",
		"java-test",

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

		-- Typescript
		["tsserver"] = function()
			require("lspconfig")["tsserver"].setup({
				on_attach = function()
					on_attach()
					add_inlay_hint_toggle_bind()
				end,
				capabilities = capabilities,
				settings = {
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
		end,

		-- LaTeX
		["texlab"] = function()
			get_devcontainer_workspace_folder(vim.fn.getcwd(), function(project_dir, workspace_folder)
				require("lspconfig")["texlab"].setup({
					on_attach = on_attach,
					capabilities = capabilities,
					settings = {
						texlab = {
							forwardSearch = {
								executable = "zathura",
								args = {
									"--synctex-forward",
									"%l:1:%f",
									"%p",
								},
							},
							build = {
								executable = "devcontainer",
								args = {
									"exec",
									"--workspace-folder",
									project_dir,
									"--remote-env",
									"base_len=" .. (string.len(project_dir) + 1),
									"bash",
									"-c",
									workspace_folder
										.. '/texbuild $(echo "'
										.. workspace_folder
										.. '")$(echo "%f" | cut -c $base_len- -)',
								},
								forwardSearchAfter = true,
							},
						},
					},
				})
			end)
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

		-- Java: jdtls-nvim
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
					local bundles = {
						vim.fn.stdpath("data") .. "/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar",
					}
					vim.list_extend(
						bundles,
						vim.split(vim.fn.glob(vim.fn.stdpath("data") .. "/mason/share/java-test/*.jar"), "\n")
					)
					require("jdtls").start_or_attach({
						cmd = { "jdtls" },
						init_options = {
							bundles = bundles,
						},
						settings = {
							java = {
								inlayHints = { parameterNames = { enabled = "all" } },
								cleanup = {
									actionsOnSave = {
										"qualifyMembers",
										"qualifyStaticMembers",
										"addOverride",
										"addFinalModifier",
										"lambdaExpression",
										"switchExpression",
									},
								},
								saveActions = {
									organizeImports = true,
								},
								codeGeneration = {
									generateComments = true,
								},
								completion = {
									enabled = true,
									guessMethodArguments = true,
									overwrite = false,
								},
								format = {
									comments = { enabled = true },
									insertSpaces = true,
									tabSize = 2,
								},
								jdt = { ls = { lombokSupport = true } },
								signatureHelp = {
									enabled = true,
									description = { enabled = true },
								},
							},
						},
					})
					on_attach()
					add_inlay_hint_toggle_bind()
					vim.api.nvim_buf_create_user_command(0, "JdtGenerateTests", require("jdtls.tests").generate, {})
					vim.api.nvim_buf_create_user_command(0, "JdtGoToTests", require("jdtls.tests").goto_subjects, {})
				end,
			})
		end,
	},
}
