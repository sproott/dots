require('globals')

local c = require('util.vim_commands')
local fs = require('util.fs')

local vim = vim
local a = vim.api
local f = vim.fn
local g = vim.g

-- Install vim-plug if not installed
if (not f.filereadable(f.expand('~/.local/share/nvim/site/autoload/plug.vim'))) then
  c.echo 'Downloading junegunn/vim-plug to manage plugins…'
  c.silent 'mkdir -p ~/.local/share/nvim/site/autoload/'
  c.silent 'curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ~/.local/share/nvim/site/autoload/plug.vim'
end

-- Remove extra plugins
local extra_plugins =
  f.filter(
  fs.ls(PLUG_DIR),
  function(_, name)
    return g.plugs[name] == nil
  end
)

if (#extra_plugins > 0) then
  c.echo('Removing ' .. #extra_plugins .. ' extra plugins')
  vim.cmd('PlugClean! | q')
end

-- Install missing plugins
local missing_plugins =
  f.filter(
  g.plugs,
  function(_, v)
    return f.isdirectory(v.dir) == 0
  end
)

if (#missing_plugins > 0) then
  c.echo('Installing ' .. #missing_plugins .. ' missing plugins')
  vim.cmd('PlugInstall --sync | q')
end
