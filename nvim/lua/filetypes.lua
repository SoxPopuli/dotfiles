vim.filetype.add({
  extension = {
    nu = 'nu',
  },
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
    pattern = "*.nu",
    callback = function (ev)
      vim.bo[ev.buf].ft = "nu"
    end
  })
