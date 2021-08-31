-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
-- Declarative object management
local ruled = require("ruled")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Global variables
require("globals")

-- Keybindings
require("keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
        message = message
    }
end)
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- {{{ Tag
-- Table of layouts to cover with awful.layout.inc, order matters.
tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({awful.layout.suit.tile, awful.layout.suit.tile.left,
                                         awful.layout.suit.tile.bottom, awful.layout.suit.tile.top,
                                         awful.layout.suit.fair, awful.layout.suit.fair.horizontal,
                                         awful.layout.suit.spiral, awful.layout.suit.spiral.dwindle,
                                         awful.layout.suit.max, awful.layout.suit.max.fullscreen,
                                         awful.layout.suit.magnifier, awful.layout.suit.corner.nw,
                                         awful.layout.suit.floating})
end)
-- }}}

-- {{{ Wibar

-- Keyboard map indicator and switcher
local mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget
local mytextclock = wibox.widget.textclock()

screen.connect_signal("request::desktop_decoration", function(s)
    -- Each screen has its own tag table.
    awful.tag({"1", "2", "3", "4", "5", "6", "7", "8", "9"}, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox {
        screen = s,
        buttons = {awful.button({}, 1, function()
            awful.layout.inc(1)
        end), awful.button({}, 3, function()
            awful.layout.inc(-1)
        end), awful.button({}, 4, function()
            awful.layout.inc(-1)
        end), awful.button({}, 5, function()
            awful.layout.inc(1)
        end)}
    }

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

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = {awful.button({}, 1, function(c)
            c:activate{
                context = "tasklist",
                action = "toggle_minimization"
            }
        end), awful.button({}, 3, function()
            awful.menu.client_list {
                theme = {
                    width = 250
                }
            }
        end), awful.button({}, 4, function()
            awful.client.focus.byidx(-1)
        end), awful.button({}, 5, function()
            awful.client.focus.byidx(1)
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
            s.mypromptbox
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            VOLUME_CFG.widget,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox
        }
    }
end)
-- }}}

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({awful.button({}, 1, function(c)
        c:activate{
            context = "mouse_click"
        }
    end), awful.button({MODKEY}, 1, function(c)
        c:activate{
            context = "mouse_click",
            action = "mouse_move"
        }
    end), awful.button({MODKEY}, 3, function(c)
        c:activate{
            context = "mouse_click",
            action = "mouse_resize"
        }
    end)})
end)

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({awful.key({MODKEY}, "f", function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end, {
        description = "toggle fullscreen",
        group = "client"
    }), awful.key({MODKEY, "Shift"}, "c", function(c)
        c:kill()
    end, {
        description = "close",
        group = "client"
    }), awful.key({MODKEY, "Control"}, "space", awful.client.floating.toggle, {
        description = "toggle floating",
        group = "client"
    }), awful.key({MODKEY, "Control"}, "Return", function(c)
        c:swap(awful.client.getmaster())
    end, {
        description = "move to master",
        group = "client"
    }), awful.key({MODKEY}, "o", function(c)
        c:move_to_screen()
    end, {
        description = "move to screen",
        group = "client"
    }), awful.key({MODKEY}, "t", function(c)
        c.ontop = not c.ontop
    end, {
        description = "toggle keep on top",
        group = "client"
    }), awful.key({MODKEY}, "n", function(c)
        -- The client currently has the input focus, so it cannot be
        -- minimized, since minimized clients can't have the focus.
        c.minimized = true
    end, {
        description = "minimize",
        group = "client"
    }), awful.key({MODKEY}, "m", function(c)
        c.maximized = not c.maximized
        c:raise()
    end, {
        description = "(un)maximize",
        group = "client"
    }), awful.key({MODKEY, "Control"}, "m", function(c)
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
    end, {
        description = "(un)maximize vertically",
        group = "client"
    }), awful.key({MODKEY, "Shift"}, "m", function(c)
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
    end, {
        description = "(un)maximize horizontally",
        group = "client"
    })})
end)

-- }}}

-- {{{ Rules
-- Rules to apply to new clients.
ruled.client.connect_signal("request::rules", function()
    -- All clients will match this rule.
    ruled.client.append_rule {
        id = "global",
        rule = {},
        properties = {
            focus = awful.client.focus.filter,
            raise = true,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
        }
    }

    -- Floating clients.
    ruled.client.append_rule {
        id = "floating",
        rule_any = {
            instance = {"copyq", "pinentry"},
            class = {"Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv", "Tor Browser", "Wpa_gui", "veromix",
                     "xtightvncviewer"},
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {"Event Tester" -- xev.
            },
            role = {"AlarmWindow", -- Thunderbird's calendar.
            "ConfigManager", -- Thunderbird's about:config.
            "pop-up" -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = {
            floating = true
        }
    }

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- ruled.client.append_rule {
    --     rule       = { class = "Firefox"     },
    --     properties = { screen = 1, tag = "2" }
    -- }
end)

-- }}

-- {{{ Notifications

ruled.notification.connect_signal('request::rules', function()
    -- All notifications will match this rule.
    ruled.notification.append_rule {
        rule = {},
        properties = {
            screen = awful.screen.preferred,
            implicit_timeout = 5
        }
    }
end)

naughty.connect_signal("request::display", function(n)
    naughty.layout.box {
        notification = n
    }
end)

-- }}}

-- Autostart applications
awful.spawn.with_shell("wallpaper")
awful.spawn.with_shell("remaps")
