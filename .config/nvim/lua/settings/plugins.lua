local cmd = require('util.cmd')
local g = vim.g

g.coq_settings = {
  auto_start = 'shut-up',
  keymap = { recommended = false, jump_to_mark = '<C-y>' }
}

g.chadtree_settings = {
  view = { width = 32, open_direction = 'left' },
  theme = { text_colour_set = 'nerdtree_syntax_dark' }
}

g.livepreview_previewer = 'zathura'

g.user_emmet_install_global = 0
cmd('autocmd FileType html,css EmmetInstall')

g.easy_align_delimiters = { [';'] = { pattern = ';', left_margin = 2 } }
