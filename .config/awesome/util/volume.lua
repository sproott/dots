local awful = require('awful')

local controls = {}

local set = function(value)
  awful.spawn.with_shell('pamixer ' .. value)
end

controls.up = function()
  set('--increase 5')
end

controls.down = function()
  set('--decrease 5')
end

controls.toggle = function()
  set('--toggle-mute')
end

return controls
