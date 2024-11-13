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
	javascript = { "prettierd", "eslint_d", lsp_format = "fallback" },
	json = { "prettierd" },
	typescript = { "prettierd", "eslint_d", lsp_format = "fallback" },
	html = { "prettierd", lsp_format = "last" },
	css = { "prettierd" },
	markdown = { "prettierd_prose_wrap" },
	java = { "google-java-format" },
	xml = { "xmlformat" },
	c = { "clang-format", lsp_format = "first" },
}
