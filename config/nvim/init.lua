-- === LuaRocks 5.1 paths ===
local home = os.getenv("HOME")
local rocks_path = home .. "/.luarocks"

package.path  = package.path  .. ";" .. rocks_path .. "/share/lua/5.1/?.lua"
package.path  = package.path  .. ";" .. rocks_path .. "/share/lua/5.1/?/init.lua"
package.cpath = package.cpath .. ";" .. rocks_path .. "/lib/lua/5.1/?.so"
-- Basic
require('core.plugins')
require('core.mappings')
require('core.colors')
require('core.configs')

-- Plugins
require('plugins.nvim-tree')
require('plugins.treesitter')
-- require('plugins.lsp')
require('plugins.cmp')
require('plugins.mason')
require('plugins.telescope')
require('plugins.dashboard')
require('plugins.colorizer')
require('plugins.lualine')
require('plugins.cellular')
require('plugins.comment')
require('plugins.bufferline')
require('plugins.todo')
require('plugins.trouble')
require('plugins.toggleterm')
require('plugins.whichkey')
require('plugins.mini')
require('plugins.better-escape')
