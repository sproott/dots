local wibox = require('wibox')
local awful = require('awful')

local layout = require('util.layout')

local create = function(colors, fonts, spacing)
  local battery_icon =
    wibox.widget.textbox(string.format('<span color="' .. colors.primary .. '" font="' .. fonts.icon .. '"></span>'))

  local create_battery_icon = function(icon)
    return layout.create_span({color = colors.primary, font = fonts.widget, content = icon})
  end

  local battery_percentage =
    awful.widget.watch(
    'acpi -b',
    60,
    function(widget, stdout)
      local charge = tonumber(string.match(stdout, '.+: %a+, (%d?%d?%d)%%,?.*'))

      local icon

      if (charge < 20) then
        icon = ''
      elseif (charge < 40) then
        icon = ''
      elseif (charge < 60) then
        icon = ''
      elseif (charge < 80) then
        icon = ''
      else
        icon = ''
      end

      battery_icon:set_markup(create_battery_icon(icon))

      widget:set_markup(layout.create_span({color = colors.primary, font = fonts.widget, content = charge .. '%'}))
    end
  )

  local battery_widget = {
    battery_icon,
    layout.horizontal_spacer(spacing),
    battery_percentage
  }

  return {widget = battery_widget}
end

return create
