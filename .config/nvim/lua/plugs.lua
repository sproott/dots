require('globals')

local Plug = require('util.plug')

Plug.beginPlug(PLUG_DIR)

Plug('ms-jpq/coq_nvim', {branch = 'coq'})
Plug('ms-jpq/coq.artifacts', {branch = 'artifacts'})
Plug('ms-jpq/chadtree', {branch = 'chad', run = 'python3 -m chadtree deps'})

Plug('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
Plug('neovim/nvim-lspconfig')

Plug('kyazdani42/nvim-web-devicons')

Plug('morhetz/gruvbox')
Plug('joshdick/onedark.vim')

Plug.endPlug()
