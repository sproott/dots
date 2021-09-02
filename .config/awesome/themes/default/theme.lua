-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local rnotification = require("ruled.notification")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local layout = require("util.layout")

local theme = {}

theme.color = {
  polar_night = {
    "#2e3440",
    "#3b4252",
    "#434c5e",
    "#4c566a",
  },
  snow_storm = {
    "#d8dee9",
    "#e5e9f0",
    "#eceff4",
  },
  frost = {
    "#8fbcbb",
    "#88c0d0",
    "#81a1c1",
    "#5e81ac",
  },
  aurora = {
    red = "#bf616a",
    orange = "#d08770",
    yellow = "#ebcb8b",
    green = "#a3be8c",
    purple = "#b48ead",
  }
}

theme.font = "monospace 10"

theme.fonts = {
  icon = "monospace 13",
  widget = theme.font,
}

theme.bg_normal     = theme.color.polar_night[1]
theme.bg_focus      = theme.color.frost[4]
theme.bg_urgent     = theme.color.aurora.red
theme.bg_minimize   = theme.color.polar_night[2]
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = theme.color.snow_storm[3]
theme.fg_focus      = theme.color.snow_storm[1]
theme.fg_urgent     = theme.color.snow_storm[1]
theme.fg_minimize   = theme.color.snow_storm[1]

theme.useless_gap         = dpi(0)
theme.border_width        = dpi(1)
theme.border_color_normal = "#000000"
theme.border_color_active = "#535d6c"
theme.border_color_marked = "#91231c"

local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv = themes_path.."default/layouts/fairvw.png"
theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"

theme.icon_theme = nil

rnotification.connect_signal('request::rules', function()
    rnotification.append_rule {
        rule       = { urgency = 'critical' },
        properties = { bg = '#ff0000', fg = '#ffffff' }
    }
end)

-- Volume control
local volume_bar = wibox.widget {
  max_value     = 100,
  value         = 0,
  forced_width  = 100,
  forced_height = 2,
  border_width  = 2,
  color         = theme.color.aurora.green,
  background_color = theme.color.polar_night[2],
  shape     = gears.shape.rounded_bar,
  margins       = {
      top    = 8,
      bottom = 8,
  },
  widget        = wibox.widget.progressbar,
}

local volume_icon = wibox.widget.textbox('')

local volume_icon_markup = function(icon)
  return '<span color="'..theme.color.aurora.green..'" font="'..theme.fonts.icon..'">'..icon..'</span>'
end

theme.update_volume = function()
  awful.spawn.easy_async_with_shell([[
    printf "%s" $(amixer get Master)]], function(status)
    local state  = status:match("%[(o[nf]*)%]")
    local volume = tonumber(status:match("(%d?%d?%d)%%"))

    if state == "off" then
      volume_icon:set_markup(volume_icon_markup("婢"))
    elseif volume == 0 then
      volume_icon:set_markup(volume_icon_markup(""))
    else
      volume_icon:set_markup(volume_icon_markup("墳"))
    end

    volume_bar:set_value(volume)
  end)
end

local volume_widget = {
  layout = wibox.layout.fixed.horizontal,
  layout.padding, 
  volume_icon, 
  layout.padding, 
  volume_bar, 
  layout.padding
}

theme.update_volume()

theme.on_screen_connect = function(s)
    -- Each screen has its own tag table.
    awful.tag({"1", "2", "3", "4", "5", "6", "7", "8", "9"}, s, awful.layout.layouts[1])

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = {awful.button({}, 1, function(t)
            t:view_only()
        end), awful.button({MODKEY}, 1, function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end), awful.button({}, 3, awful.tag.viewtoggle), awful.button({MODKEY}, 3, function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end), awful.button({}, 4, function(t)
            awful.tag.viewprev(t.screen)
        end), awful.button({}, 5, function(t)
            awful.tag.viewnext(t.screen)
        end)}
    }

    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top",
        screen = s
    })

    -- Add widgets to the wibox
    s.mywibox.widget = {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
        },
        { -- Center widget
			      layout = wibox.layout.align.horizontal
		    },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            volume_widget,
            wibox.widget.systray(),
        }
    }
end

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
