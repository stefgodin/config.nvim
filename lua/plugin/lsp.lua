return {
    {
        'neovim/nvim-lspconfig',
        config = function()
            -- This is where you enable features that only work
            -- if there is a language server active in the file
            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if not client then return end

                    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end)
                    vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end)
                    vim.keymap.set('n', 'gD', function() vim.lsp.buf.declaration() end)
                    vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation() end)
                    vim.keymap.set('n', 'go', function() vim.lsp.buf.type_definition() end)
                    vim.keymap.set('n', 'grr', function() vim.lsp.buf.references() end)
                    vim.keymap.set('n', 'gs', function() vim.lsp.buf.signature_help() end)
                    vim.keymap.set('n', 'grn', function() vim.lsp.buf.rename() end)
                    vim.keymap.set({'n', 'x'}, '<F3>', function() vim.lsp.buf.format({async = true}) end)
                    vim.keymap.set('n', '<F4>', function() vim.lsp.buf.code_action() end)

                    if client.supports_method('textDocument/formatting') then
                        local opts = {bufnr = args.buf, id = client.id}

                        vim.api.nvim_create_autocmd("BufWritePre", {
                            pattern = "*.go",
                            callback = function()
                                local params = vim.lsp.util.make_range_params()
                                params.context = {only = {"source.organizeImports"}}
                                local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
                                for cid, res in pairs(result or {}) do
                                    for _, r in pairs(res.result or {}) do
                                        if r.edit then
                                            local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                                            vim.lsp.util.apply_workspace_edit(r.edit, enc)
                                        end
                                    end
                                end
                            end
                        })

                        vim.api.nvim_create_autocmd('BufWritePre', {
                            callback = function()
                                vim.lsp.buf.format(opts)
                            end
                        })
                    end
                end,
            })

            -- Setup LSP servers here
            require('lspconfig').gopls.setup({
                single_file_support = false,
                on_attach = function(client, bufnr)
                    client.server_capabilities.semanticTokensProvider = {
                        full = true,
                        legend = {
                            tokenTypes = { 'namespace', 'type', 'class', 'enum', 'interface', 'struct', 'typeParameter', 'parameter', 'variable', 'property', 'enumMember', 'event', 'function', 'method', 'macro', 'keyword', 'modifier', 'comment', 'string', 'number', 'regexp', 'operator', 'decorator' },
                            tokenModifiers = { 'declaration', 'definition', 'readonly', 'static', 'deprecated', 'abstract', 'async', 'modification', 'documentation', 'defaultLibrary'}
                        }
                    }
                end
            })

        end
    }
}
