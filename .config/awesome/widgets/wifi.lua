local wibox = require('wibox')
local awful = require('awful')

local layout = require('util.layout')

local I_DISCONNECTED = '󰖪'
local I_CONNECTING = '󱚵'
local I_CONNECTED = '󰖩'

return function(colors, fonts, spacing, device)
  colors.wifi_connecting = colors.wifi_connecting or colors.primary
  colors.wifi_disconnected = colors.wifi_disconnected or colors.primary

  local wifi_icon = wibox.widget.textbox('')
  local wifi_name = wibox.widget.textbox('')

  local create_wifi_icon = function(icon, color)
    return layout.create_span({color = color, font = fonts.icon, content = icon})
  end

  local listener =
    awful.spawn.with_line_callback(
    'nmcli monitor',
    {
      stdout = function(status)
        if (not string.match(status, device)) then
          return
        end

        if (string.match(status, ': using connection')) then
          NAME = string.match(status, ": using connection '(.*)'")
        end

        local icon
        local color

        if (string.match(status, ': disconnected')) then
          icon = I_DISCONNECTED
          color = colors.wifi_disconnected
          NAME = nil
        elseif (string.match(status, ': connecting')) then
          icon = I_CONNECTING
          color = colors.wifi_connecting
        elseif (string.match(status, ': connected')) then
          icon = I_CONNECTED
          color = colors.primary
        else
          return
        end

        wifi_icon:set_markup(create_wifi_icon(icon, color))
        wifi_name:set_markup(layout.create_span({font = fonts.widget, color = color, content = NAME or ''}))
      end
    }
  )

  awesome.connect_signal(
    'exit',
    function()
      awesome.kill(listener, awesome.unix_signal.SIGTERM)
    end
  )

  -- Initial status check
  awful.spawn.easy_async_with_shell(
    'nmcli connection show --active',
    function(stdout)
      local process = function(stdout)
        local lines = {}

        -- Split string by lines
        for line in string.gmatch(stdout, '([^\r\n]+)') do
          table.insert(lines, line)
        end

        -- Find index of the place the UUID column starts
        local index_of_UUID_column, _, _ = string.find(lines[1] or '', 'UUID')

        -- If it's not found then there is no active connection
        if (index_of_UUID_column == nil) then
          return I_DISCONNECTED, colors.wifi_disconnected
        end

        -- Get SSID and trim whitespace
        NAME = string.gsub(string.sub(lines[2], 1, index_of_UUID_column - 1), '%s*$', '')

        return I_CONNECTED, colors.primary
      end

      local icon, color = process(stdout)

      wifi_icon:set_markup(create_wifi_icon(icon, color))
      wifi_name:set_markup(layout.create_span({font = fonts.widget, color = color, content = NAME or ''}))
    end
  )

  local wifi_widget = {
    wifi_icon,
    layout.horizontal_spacer(spacing),
    wifi_name
  }

  return {widget = wifi_widget}
end
