vim.pack.add({ { src = "https://github.com/alexghergh/nvim-tmux-navigation" } })

local nvim_tmux_nav = require("nvim-tmux-navigation")

nvim_tmux_nav.setup({
  disable_when_zoomed = false,
})

local function exit_terminal_mode()
  if vim.fn.mode() == "t" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, true, true), "n", true)
  end
end

local directions = {
  h = { dir = "Left", key = "<C-h>" },
  j = { dir = "Down", key = "<C-j>" },
  k = { dir = "Up", key = "<C-k>" },
  l = { dir = "Right", key = "<C-l>" },
  Left = { dir = "Left", key = "<C-Left>" },
  Down = { dir = "Down", key = "<C-Down>" },
  Up = { dir = "Up", key = "<C-Up>" },
  Right = { dir = "Right", key = "<C-Right>" },
}

for _, mode in ipairs({ "n", "t" }) do
  for _, spec in pairs(directions) do
    vim.keymap.set(mode, spec.key, function()
      exit_terminal_mode()
      nvim_tmux_nav["NvimTmuxNavigate" .. spec.dir]()
    end)
  end
end
