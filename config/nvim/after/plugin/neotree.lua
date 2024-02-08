require("neo-tree").setup({
  close_if_last_window = true,

  -- display harpoon index in neo-tree
  filesystem = {
    hijack_netrw_behavior = "disabled",
    follow_current_file = {
      enabled = true,
      leave_dirs_open = true
    },
    components = {
      harpoon_index = function(config, node, _)
        local Marked = require("harpoon.mark")
        local path = node:get_id()
        local success, index = pcall(Marked.get_index_of, path)
        if success and index and index > 0 then
          return {
            text = string.format(" ⥤ %d ", index), -- <-- Add your favorite harpoon like arrow here
            highlight = config.highlight or "NeoTreeDirectoryIcon",
          }
        else
          return {
            text = "  ",
          }
        end
      end,
    },
    renderers = {
      file = {
        { "icon" },
        { "name", use_git_status_colors = true },
        { "harpoon_index" }, --> This is what actually adds the component in where you want it
        { "diagnostics" },
        { "git_status", highlight = "NeoTreeDimText" },
      },
    },
  },
})

vim.keymap.set("n", "<leader>E", function()
  vim.cmd("Neotree show toggle reveal")
end)

vim.keymap.set("n", "<leader>te", function()
  vim.cmd("Neotree position=current reveal")
end)

vim.keymap.set("n", "<leader>gt", function()
  vim.cmd("Neotree show toggle reveal git_status")
end)
