-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		-- or                          , branch = '0.1.x',
		requires = { { "nvim-lua/plenary.nvim" } },
	})

	use("folke/tokyonight.nvim")
	use("lukas-reineke/indent-blankline.nvim")

	use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
	use("theprimeagen/harpoon")
	use("mbbill/undotree")
	use("tpope/vim-fugitive")
	use("tpope/vim-commentary")
	use("smjonas/inc-rename.nvim")
	use("kylechui/nvim-surround")

	use({
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		requires = {
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },
		},
	})

	use("mhartington/formatter.nvim")

	use({
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
	})

	use({
		"stevearc/oil.nvim",
		requires = {
			"nvim-tree/nvim-web-devicons",
		},
	})

	use("lewis6991/gitsigns.nvim")
	use("https://git.sr.ht/~whynothugo/lsp_lines.nvim")

	use("christoomey/vim-tmux-navigator")

	use({ "nvim-pack/nvim-spectre", requires = {
		"nvim-lua/plenary.nvim",
	} })

	use("epwalsh/obsidian.nvim")

	use({ "prurigro/vim-markdown-concealed", requires = {
		"godlygeek/tabular",
	} })

	use("~/devcontainer.nvim")
end)
