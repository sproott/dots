local wibox = require('wibox')

local layout = require('util.layout')

return function(colors, fonts, spacing)
  local clock_icon =
    wibox.widget.textbox(layout.create_span({color = colors.primary, font = fonts.icon, content = '󰅐'}))
  local clock =
    wibox.widget.textclock(layout.create_span({color = colors.primary, font = fonts.widget, content = '%R'}))

  local clock_widget = {
    clock_icon,
    layout.horizontal_spacer(spacing),
    wibox.container.place(clock)
  }

  return {widget = clock_widget}
end

