vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.lazy")

vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.statuscolumn='%=%{v:relnum?v:relnum:v:lnum} '
vim.opt.numberwidth=3
vim.opt.scrolloff = 999
vim.opt.wrap = true

-- Tabs are now 4 spaces
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlights when yanking text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', {clear = true}),
    callback = function() vim.highlight.on_yank() end
})
