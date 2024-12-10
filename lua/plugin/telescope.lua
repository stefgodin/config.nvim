return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' }
    },
    config = function() 
        require('telescope').setup({
            pickers = {
                find_files = {
                    theme = 'ivy'
                },
                lsp_references = {
                    theme = 'ivy'
                }
            }
        })
        vim.keymap.set("n", "<leader>ff", require('telescope.builtin').find_files)
        vim.keymap.set("n", "<leader>fc", function() 
            require('telescope.builtin').find_files({
                cwd = vim.fn.stdpath('config')
            }) 
        end)
        vim.keymap.set("n", "<leader>fh", require('telescope.builtin').help_tags)
        vim.keymap.set("n", "<leader>fr", require('telescope.builtin').lsp_references)
    end
}
