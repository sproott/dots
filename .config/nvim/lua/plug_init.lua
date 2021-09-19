require('globals')

local cmd = require('util.cmd')
local fs = require('util.fs')

local vim = vim
local f = vim.fn
local g = vim.g

-- Install vim-plug if not installed
if (not f.filereadable(f.expand('~/.local/share/nvim/site/autoload/plug.vim'))) then
  cmd.echo 'Downloading junegunn/vim-plug to manage plugins…'
  cmd.silent 'mkdir -p ~/.local/share/nvim/site/autoload/'
  cmd.silent 'curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ~/.local/share/nvim/site/autoload/plug.vim'
end

-- Remove extra plugins
local extra_plugins =
  f.filter(
  fs.ls(PLUG_DIR),
  function(_, name)
    return g.plugs[name] == nil
  end
)

if (f.len(extra_plugins) > 0) then
  cmd.echo('Removing ' .. #extra_plugins .. ' extra plugins')
  cmd('PlugClean! | q')
end

-- Install missing plugins
local missing_plugins =
  f.filter(
  g.plugs,
  function(_, v)
    return f.isdirectory(v.dir) == 0
  end
)

if (f.len(missing_plugins) > 0) then
  cmd.echo('Installing ' .. #missing_plugins .. ' missing plugins')
  cmd('PlugInstall --sync | q')
end
