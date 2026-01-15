require('treesitter')

local coq = require('coq')

-- Astro
vim.lsp.enable('astro')

-- Bash
vim.lsp.enable('bashls')

-- C/C++
vim.lsp.enable('ccls')

-- EFM (formatting/linting)
vim.lsp.config(
  'efm',
  coq.lsp_ensure_capabilities {
    init_options = {documentFormatting = true},
    filetypes = {'lua', 'python', 'sh', 'html'},
    settings = {
      rootMarkers = {'.git/'},
      languages = {
        lua = {
          {
            formatCommand = 'lua-format -i --indent-width=2 --double-quote-to-single-quote',
            formatStdin = true
          }
        },
        sh = {
          {
            formatCommand = 'shfmt -ci -i 2 -s -bn',
            formatStdin = true,
            lintCommand = 'shellcheck -f gcc -x',
            lintSource = 'shellcheck',
            lintFormats = {
              '%f:%l:%c: %trror: %m',
              '%f:%l:%c: %tarning: %m',
              '%f:%l:%c: %tote: %m'
            }
          }
        },
        python = {{formatCommand = 'black --quiet -', formatStdin = true}},
        html = {
          {
            formatCommand = 'prettier --tab-width 2 --single-quote true --parser html'
          }
        }
      }
    }
  }
)
vim.lsp.enable('efm')

-- Haskell
vim.lsp.config(
  'hls',
  coq.lsp_ensure_capabilities {
    settings = {haskell = {formattingProvider = 'ormolu'}}
  }
)
vim.lsp.enable('hls')

-- PHP
vim.lsp.config(
  'intelephense',
  coq.lsp_ensure_capabilities {
    settings = {
      intelephense = {
        files = {
          maxSize = 1000000
        },
        format = {
          braces = 'k&r'
        }
      }
    }
  }
)
vim.lsp.enable('intelephense')

-- JSON
vim.lsp.enable('jsonls')

-- XML
vim.lsp.config(
  'lemminx',
  coq.lsp_ensure_capabilities {
    cmd = {'/usr/bin/lemminx'}
  }
)
vim.lsp.enable('lemminx')

-- Python
vim.lsp.enable('pyright')

-- Rust
vim.lsp.config(
  'rust_analyzer',
  coq.lsp_ensure_capabilities {
    settings = {
      ['rust-analyzer'] = {rustfmt = {extraArgs = {'--config', 'tab_spaces=2'}}}
    }
  }
)
vim.lsp.enable('rust_analyzer')

-- Lua
local lua_ls_binary_path = 'lua-language-server'
local lua_ls_root_path = '/usr/share/lua-language-server'

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

vim.lsp.config(
  'lua_ls',
  coq.lsp_ensure_capabilities {
    cmd = {lua_ls_binary_path, '-E', lua_ls_root_path .. '/main.lua'},
    settings = {
      Lua = {
        runtime = {version = 'LuaJIT', path = runtime_path},
        diagnostics = {globals = {'vim'}},
        workspace = {
          library = vim.api.nvim_get_runtime_file('', true),
          checkThirdParty = false
        }
      }
    }
  }
)
vim.lsp.enable('lua_ls')

-- Svelte
vim.lsp.enable('svelte')

-- LaTeX
vim.lsp.enable('texlab')

-- TypeScript
vim.lsp.enable('tsserver')

-- Typst
vim.lsp.enable('typst_lsp')
