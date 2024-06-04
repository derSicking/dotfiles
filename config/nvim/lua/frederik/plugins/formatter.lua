return {
	"stevearc/conform.nvim",

	config = function()
		require("conform").setup({
			log_level = vim.log.levels.DEBUG,
			format_after_save = { lsp_fallback = true },
		})
		require("frederik.formatter")
	end,
}
