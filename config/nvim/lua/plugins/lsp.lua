-- Setup language servers safely
local ok, lspconfig = pcall(require, "lspconfig")
if not ok then return end

-- Python (Pyright)
lspconfig.pyright.setup {
    settings = {
        pyright = {
            disableOrganizeImports = true,
        },
        python = {
            analysis = {
                ignore = { "*" }, -- исключительно Ruff для linting
            },
        },
    },
}

-- TypeScript / JavaScript
lspconfig.ts_ls.setup({})  -- вместо tsserver

-- Rust
lspconfig.rust_analyzer.setup {
    settings = {
        ["rust-analyzer"] = {},
    },
}

-- Ruff Linter
lspconfig.ruff.setup {  -- вместо ruff_lsp
    init_options = {
        settings = {
            args = {
                "--select=E,F,UP,N,I,ASYNC,S,PTH",
                "--line-length=79",
                "--respect-gitignore",
                "--target-version=py311"
            },
        }
    }
}

-- Global diagnostics keymaps
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)

-- Buffer-local keymaps after LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "lD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "ld", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "lk", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "i", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set({ "n", "v" }, "<space>r", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<space>f", function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
})
