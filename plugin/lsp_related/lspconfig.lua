local err, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not err then
  return
end
-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = cmp_nvim_lsp.default_capabilities()

-- require'lspconfig'.clangd.setup {
-- capabilities = capabilities,
-- }
