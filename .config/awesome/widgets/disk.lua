local awful = require('awful')
local wibox = require('wibox')

local layout = require('util.layout')

-- nf-md-harddisk
local I_DISK = '\u{f02ca}'

local format_bytes = function(bytes)
  local units = {'B', 'K', 'M', 'G', 'T', 'P'}
  local i = 1
  while bytes >= 1024 and i < #units do
    bytes = bytes / 1024
    i = i + 1
  end
  return string.format(bytes < 10 and '%.1f%s' or '%.0f%s', bytes, units[i])
end

return function(colors, fonts, spacing, config)
  local mount = config.mount or '/'
  local warn_percent = config.warn_percent or 90

  local disk_icon = wibox.widget.textbox('')
  local tooltip = awful.tooltip({objects = {disk_icon}})

  local disk_usage =
    awful.widget.watch(
    {'df', '-B1', '--output=used,avail', mount},
    60,
    function(widget, stdout)
      local used, avail = string.match(stdout, '(%d+)%s+(%d+)%s*$')
      used, avail = tonumber(used), tonumber(avail)
      if not used then
        return
      end

      -- On btrfs, size exceeds used + avail by metadata/reserve overhead, so the
      -- percentage is relative to what is actually usable (same as df's Use%).
      local percent = math.ceil(used * 100 / (used + avail))

      local color, text
      if percent >= warn_percent then
        color = colors.warning
        text = format_bytes(avail) .. ' left'
      else
        color = colors.primary
        text = percent .. '%'
      end

      disk_icon:set_markup(layout.create_span({color = color, font = fonts.icon, content = I_DISK}))
      widget:set_markup(layout.create_span({color = color, font = fonts.widget, content = text}))
      tooltip.text =
        string.format('%s: %s used, %s free (%d%%)', mount, format_bytes(used), format_bytes(avail), percent)
    end
  )
  tooltip:add_to_object(disk_usage)

  local disk_widget = {
    disk_icon,
    layout.horizontal_spacer(spacing),
    disk_usage
  }

  return {widget = disk_widget}
end
