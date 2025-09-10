vim.api.nvim_create_autocmd("BufReadPre", {
  pattern = "*.ui",
  callback = function()
    vim.cmd("silent !designer " .. vim.fn.expand "%:p" .. " &")
    vim.cmd "bd!" -- закрываем текущий буфер .ui в Neovim
  end,
})
