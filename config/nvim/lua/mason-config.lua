return {
  -- Tools to be installed with Mason
  ensure_installed = {
    -- Language Servers
    "lua_ls",
    "eslint-lsp",
    "typescript-language-server",
    "emmet-language-server",
    "html-lsp",
    "css-lsp",
    "ltex-ls",
    "gopls",
    "yamlls",
    "helm_ls",
    "kotlin_lsp",
    "clangd",

    -- Formatters
    "stylua",
    "prettierd",

    -- Linters
    "eslint_d",

    -- Debug Adapters

    -- Tools
    "tree-sitter-cli",
    "jq",
  },
}
