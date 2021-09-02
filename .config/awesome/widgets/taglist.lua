local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local create = function(screen, params)
  params = params or {}
  params.spacing = params.spacing or dpi(10)
  params.margin = params.margin or dpi(2)

  return awful.widget.taglist {
    screen = screen,
    filter = awful.widget.taglist.filter.all,
    style = {
      shape = gears.shape.circle
    },
    widget_template = {
      {
        {
          {
            {
              id = 'text_role',
              widget = wibox.widget.textbox,
            },
            layout = wibox.layout.align.horizontal,
          },
          left = params.spacing,
          right = params.spacing,
          widget = wibox.container.margin
        },
        id = 'background_role',
        widget = wibox.container.background,
      },
      top = params.margin,
      bottom = params.margin,
      widget = wibox.container.margin
    },
    buttons = {
      awful.button({}, 1, function(t) t:view_only() end), 
      awful.button({MODKEY}, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
      end),
      awful.button({}, 3, awful.tag.viewtoggle), 
      awful.button({MODKEY}, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
      end),
      awful.button({}, 4, function(t) awful.tag.viewprev(t.screen) end),
      awful.button({}, 5, function(t) awful.tag.viewnext(t.screen) end),
    }
  }
end

return create
