local g = vim.g
local b = vim.b

g.coq_settings = {auto_start = 'shut-up', keymap = {recommended = false, jump_to_mark = '<C-y>'}}

g.chadtree_settings = {
  view = {
    width = 32,
    open_direction = 'left'
  },
  theme = {
    text_colour_set = 'nerdtree_syntax_dark'
  }
}

g.livepreview_previewer = 'zathura'

b.copilot_enabled = false
