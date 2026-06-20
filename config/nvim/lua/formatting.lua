local util = require("conform.util")

require("conform").formatters.prettierd_prose_wrap = {
	command = util.from_node_modules("prettierd"),
	args = { "--prose-wrap=always", "$FILENAME" },
	range_args = function(_, ctx)
		local start_offset, end_offset = util.get_offsets_from_range(ctx.buf, ctx.range)
		return { "--prose-wrap=always", "$FILENAME", "--range-start=" .. start_offset, "--range-end=" .. end_offset }
	end,
	cwd = util.root_file({
		".prettierrc",
		".prettierrc.json",
		".prettierrc.yml",
		".prettierrc.yaml",
		".prettierrc.json5",
		".prettierrc.js",
		".prettierrc.cjs",
		".prettierrc.mjs",
		".prettierrc.toml",
		"prettier.config.js",
		"prettier.config.cjs",
		"prettier.config.mjs",
		"package.json",
	}),
}

require("conform").formatters_by_ft = {
	lua = { "stylua" },
	javascript = { "prettierd", "eslint_d", lsp_format = "never" },
	json = { "prettierd" },
	typescript = { "prettierd", "eslint_d", lsp_format = "never" },
	html = { "prettierd", lsp_format = "first" },
	htmlangular = { "prettierd", lsp_format = "first" },
	css = { "prettierd", lsp_format = "never" },
	scss = { "prettierd", lsp_format = "never" },
	markdown = { "prettierd_prose_wrap" },
	go = { lsp_format = "first" },
	c = { lsp_format = "first" },
	cpp = { lsp_format = "first" },
	rust = { lsp_format = "first" },
}
