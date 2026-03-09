-- plugins/treesitter.lua

-- Пытаемся подключить модуль безопасно
local ok, configs = pcall(require, "nvim-treesitter.configs")
if not ok then
    return  -- плагин ещё не готов, выходим безопасно
end

configs.setup {
    ensure_installed = {
        "bash",
        "css",
        "dockerfile",
        "html",
        "javascript",
        "json",
        "json5",
        "lua",
        "python",
        "vim",
        "yaml",
        "c",
        "go",
        "rust",
    },

    sync_install = false,
    auto_install = true,

    highlight = {
        enable = true,
    },
}
