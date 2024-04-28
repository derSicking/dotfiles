return {
	"stevearc/conform.nvim",

	config = function()
		require("conform").setup({
			-- log_level = vim.log.levels.DEBUG,
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		})
		require("frederik.formatter")
	end,
}
