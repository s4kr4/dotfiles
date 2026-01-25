vim.lsp.config("*", {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  -- オプション: 追加設定が必要な場合
  -- settings = {
  --   typescript = {
  --     inlayHints = {
  --       includeInlayParameterNameHints = "all",
  --       includeInlayFunctionParameterTypeHints = true,
  --     }
  --   }
  -- }
})

vim.lsp.config("vtsls", {
  keys = {
    {
      "gD",
      function()
        local win = vim.api.nvim_get_current_win()
        local params = vim.lsp.util.make_position_params(win, "utf-16")
        LazyVim.lsp.execute({
          command = "typescript.goToSourceDefinition",
          arguments = { params.textDocument.uri, params.position },
          open = true,
        })
      end,
      desc = "Goto Source Definition",
    },
    {
      "gR",
      function()
        LazyVim.lsp.execute({
          command = "typescript.findAllFileReferences",
          arguments = { vim.uri_from_bufnr(0) },
          open = true,
        })
      end,
      desc = "File References",
    },
  }
})

vim.lsp.enable("vtsls")

