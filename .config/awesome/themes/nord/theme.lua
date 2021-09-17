local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')

local xresources = require('beautiful.xresources')
local rnotification = require('ruled.notification')
local dpi = xresources.apply_dpi

local gfs = require('gears.filesystem')
local themes_path = gfs.get_themes_dir()

-- Utils
local layout = require('util.layout')

-- Widget imports
local create_volume_widget = require('widgets.volume')
local create_battery_widget = require('widgets.battery')
local create_taglist_widget = require('widgets.taglist')

-- {{{ Theme properties

local theme = {}

theme.color = {
  polar_night = {
    '#2e3440',
    '#3b4252',
    '#434c5e',
    '#4c566a'
  },
  snow_storm = {
    '#d8dee9',
    '#e5e9f0',
    '#eceff4'
  },
  frost = {
    '#8fbcbb',
    '#88c0d0',
    '#81a1c1',
    '#5e81ac'
  },
  aurora = {
    red = '#bf616a',
    orange = '#d08770',
    yellow = '#ebcb8b',
    green = '#a3be8c',
    purple = '#b48ead'
  }
}

theme.font = 'monospace 10'

theme.fonts = {
  icon = 'monospace 13',
  widget = theme.font
}

theme.bg_normal = theme.color.polar_night[1]
theme.bg_focus = theme.color.frost[4]
theme.bg_urgent = theme.color.aurora.red
theme.bg_minimize = theme.color.polar_night[2]

theme.bg_systray = theme.bg_normal

theme.fg_normal = theme.color.snow_storm[1]
theme.fg_focus = theme.color.snow_storm[3]
theme.fg_urgent = theme.fg_focus
theme.fg_minimize = theme.fg_focus

theme.taglist_fg_empty = theme.color.polar_night[3]

theme.hotkeys_fg = theme.color.snow_storm[3]
theme.hotkeys_modifiers_fg = theme.color.polar_night[4]

theme.useless_gap = dpi(0)
theme.border_width = dpi(1)
theme.border_color_normal = '#000000'
theme.border_color_active = '#535d6c'
theme.border_color_marked = '#91231c'

theme.menu_submenu_icon = themes_path .. 'default/submenu.png'
theme.menu_height = dpi(15)
theme.menu_width = dpi(100)

theme.layout_fairh = themes_path .. 'default/layouts/fairhw.png'
theme.layout_fairv = themes_path .. 'default/layouts/fairvw.png'
theme.layout_floating = themes_path .. 'default/layouts/floatingw.png'
theme.layout_magnifier = themes_path .. 'default/layouts/magnifierw.png'
theme.layout_max = themes_path .. 'default/layouts/maxw.png'
theme.layout_fullscreen = themes_path .. 'default/layouts/fullscreenw.png'
theme.layout_tilebottom = themes_path .. 'default/layouts/tilebottomw.png'
theme.layout_tileleft = themes_path .. 'default/layouts/tileleftw.png'
theme.layout_tile = themes_path .. 'default/layouts/tilew.png'
theme.layout_tiletop = themes_path .. 'default/layouts/tiletopw.png'
theme.layout_spiral = themes_path .. 'default/layouts/spiralw.png'
theme.layout_dwindle = themes_path .. 'default/layouts/dwindlew.png'
theme.layout_cornernw = themes_path .. 'default/layouts/cornernww.png'
theme.layout_cornerne = themes_path .. 'default/layouts/cornernew.png'
theme.layout_cornersw = themes_path .. 'default/layouts/cornersww.png'
theme.layout_cornerse = themes_path .. 'default/layouts/cornersew.png'

theme.icon_theme = nil

theme.spacing = {small = dpi(10), normal = dpi(15)}

theme.wallpaper_dir = 'nord'

-- }}}

rnotification.connect_signal(
  'request::rules',
  function()
    rnotification.append_rule {
      rule = {urgency = 'critical'},
      properties = {bg = theme.bg_urgent, fg = theme.fg_normal}
    }
  end
)

-- {{{ Widgets

local wrap_widget = function(widget)
  return layout.add_margin(layout.fixed_horizontal(widget), {left = theme.spacing.normal, right = theme.spacing.normal})
end

-- Battery widget
local battery =
  create_battery_widget(
  {primary = theme.color.aurora.yellow},
  {icon = theme.fonts.icon, widget = theme.fonts.widget},
  theme.spacing.small
)
local battery_widget = wrap_widget(battery.widget)

-- Volume widget
local volume =
  create_volume_widget(
  {primary = theme.color.aurora.green, background = theme.color.polar_night[3], muted = theme.color.aurora.red},
  {icon = theme.fonts.icon},
  theme.spacing.small
)
local volume_widget = wrap_widget(volume.widget)
theme.update_volume = volume.update_volume

-- Keyboard layout widget
-- TODO make it pretty
local keyboard_layout_widget = awful.widget.keyboardlayout()

-- Clock widget
-- TODO make it pretty
local clock_widget = wibox.widget.textclock()

-- }}}

theme.on_screen_connect = function(s)
  -- Each screen has its own tag table.
  awful.tag({'1', '2', '3', '4', '5', '6', '7', '8', '9'}, s, awful.layout.layouts[1])

  -- Create a taglist widget
  local taglist_widget = create_taglist_widget(s)

  -- Create the wibox
  s.mywibox =
    awful.wibar(
    {
      position = 'top',
      screen = s
    }
  )

  -- Add widgets to the wibox
  s.mywibox.widget = {
    layout = wibox.layout.align.horizontal,
    layout.fixed_horizontal {
      -- Left widgets
      taglist_widget
    },
    layout.fixed_horizontal {},
    layout.fixed_horizontal {
      -- Right widgets
      keyboard_layout_widget,
      battery_widget,
      volume_widget,
      clock_widget
    }
  }
end

return theme
