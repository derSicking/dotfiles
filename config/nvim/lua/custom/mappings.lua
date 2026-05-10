-- If needed, enable to quickly regenerate uuids with R
-- local util = require("config.custom.utils")
--
-- vim.keymap.set("n", "R", function()
-- 	vim.cmd("normal! ciw" .. util.uuid_no_dash())
-- end)

vim.keymap.set("n", "<leader>t", "<cmd>e ~/todo.md<cr>")
