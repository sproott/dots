local wibox = require('wibox')

local layout = require('util.layout')

return function(config, fonts, spacing)
  local children = {}

  if config.icon then
    table.insert(
      children,
      wibox.widget.textbox(layout.create_span({color = config.color, font = fonts.icon, content = config.icon}))
    )
    if config.label then
      table.insert(children, layout.horizontal_spacer(spacing))
    end
  end

  if config.label then
    table.insert(
      children,
      wibox.widget.textbox(layout.create_span({color = config.color, font = fonts.widget, content = config.label}))
    )
  end

  return {widget = children}
end
