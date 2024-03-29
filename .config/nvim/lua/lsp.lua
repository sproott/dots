require('treesitter')

local lsp = require('lspconfig')
local coq = require('coq')

local coq_setup = coq.lsp_ensure_capabilities

lsp.astro.setup(coq_setup {})
lsp.bashls.setup(coq_setup {})
lsp.ccls.setup(coq_setup {})
-- lsp.cssls.setup {}
lsp.efm.setup {
  init_options = { documentFormatting = true },
  filetypes = { 'lua', 'python', 'sh', 'html' },
  settings = {
    rootMarkers = { '.git/' },
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
            '%f:%l:%c: %trror: %m', '%f:%l:%c: %tarning: %m',
            '%f:%l:%c: %tote: %m'
          }
        }
      },
      python = { { formatCommand = 'black --quiet -', formatStdin = true } },
      html = {{
        formatCommand = 'prettier --tab-width 2 --single-quote true --parser html'
      }}
    }
  }
}
lsp.hls
    .setup(coq_setup { settings = { haskell = { formattingProvider = 'ormolu' } } })
-- lsp.html.setup {}
lsp.intelephense.setup(coq_setup {
  settings = {
    intelephense = {
      files = {
        maxSize = 1000000;
      },
      format = {
        braces = "k&r"
      }
    }
  }
})
lsp.jsonls.setup(coq_setup {})

lsp.lemminx.setup(coq_setup { cmd = { '/usr/bin/lemminx' } })

lsp.pyright.setup(coq_setup {})

lsp.rust_analyzer.setup(coq_setup {
  settings = {
    ['rust-analyzer'] = { rustfmt = { extraArgs = { '--config', 'tab_spaces=2' } } }
  }
})

local lua_ls_binary_path = 'lua-language-server'
local lua_ls_root_path = '/usr/share/lua-language-server'

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

lsp.lua_ls.setup(coq_setup {
  cmd = { lua_ls_binary_path, '-E', lua_ls_root_path .. '/main.lua' },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT', path = runtime_path },
      diagnostics = { globals = { 'vim' } },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false
      }
    }
  }
})

lsp.svelte.setup(coq_setup {})

lsp.texlab.setup(coq_setup {})

lsp.tsserver.setup(coq_setup {})

lsp.typst_lsp.setup(coq_setup {})
