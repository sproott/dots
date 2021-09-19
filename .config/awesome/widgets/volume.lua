local gears = require('gears')
local wibox = require('wibox')
local awful = require('awful')

local layout = require('util.layout')

return function(colors, fonts, spacing)
  colors.muted = colors.muted or colors.primary

  local volume_bar =
    wibox.widget {
    max_value = 100,
    value = 0,
    forced_width = 100,
    forced_height = 2,
    border_width = 2,
    color = colors.primary,
    background_color = colors.background,
    shape = gears.shape.rounded_bar,
    margins = {
      top = 8,
      bottom = 8
    },
    widget = wibox.widget.progressbar
  }

  local volume_icon = wibox.widget.textbox('')

  local create_volume_icon = function(icon, muted)
    local color
    if muted then
      color = colors.muted
    else
      color = colors.primary
    end
    return layout.create_span({color = color, font = fonts.icon, content = icon})
  end

  local muted_icon = create_volume_icon('婢', true)
  local silent_icon = create_volume_icon('', false)
  local normal_icon = create_volume_icon('墳', false)

  local update_volume = function()
    awful.spawn.easy_async_with_shell(
      'echo $(pamixer --get-volume) $(pamixer --get-mute)',
      function(status)
        local is_muted = status:match('(true)') == 'true'
        local volume = tonumber(status:match('^(%d+)'))

        if is_muted then
          volume_icon:set_markup(muted_icon)
          volume_bar:set_color(colors.muted)
        elseif volume == 0 then
          volume_icon:set_markup(silent_icon)
          volume_bar:set_color(colors.primary)
        else
          volume_icon:set_markup(normal_icon)
          volume_bar:set_color(colors.primary)
        end

        volume_bar:set_value(volume)
      end
    )
  end

  local volume_widget = {
    volume_icon,
    layout.horizontal_spacer(spacing),
    volume_bar
  }

  update_volume()

  local listener = awful.spawn.with_line_callback({'stdbuf', '-oL', 'alsactl', 'monitor'}, {stdout = update_volume})

  awesome.connect_signal(
    'exit',
    function()
      awesome.kill(listener, awesome.unix_signal.SIGTERM)
    end
  )

  return {widget = volume_widget, update_volume = update_volume}
end

