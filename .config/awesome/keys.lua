-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")

require("globals")

local keys = {global_keys = {}}

-- General Awesome keys
keys.global_keys = gears.table.join(keys.global_keys,
awful.key({MODKEY}, "s", hotkeys_popup.show_help, {
  description = "show help",
  group = "awesome"
}), awful.key({MODKEY, "Control"}, "r", awesome.restart, {
  description = "reload awesome",
  group = "awesome"
}), awful.key({MODKEY, "Shift"}, "q", awesome.quit, {
  description = "quit awesome",
  group = "awesome"
}), awful.key({MODKEY}, "x", function()
  awful.prompt.run {
      prompt = "Run Lua code: ",
      textbox = awful.screen.focused().mypromptbox.widget,
      exe_callback = awful.util.eval,
      history_path = awful.util.get_cache_dir() .. "/history_eval"
  }
end, {
  description = "lua execute prompt",
  group = "awesome"
}), awful.key({MODKEY}, "Return", function()
  awful.spawn(TERMINAL)
end, {
  description = "open a TERMINAL",
  group = "launcher"
}), awful.key({MODKEY}, "r", function()
  awful.screen.focused().mypromptbox:run()
end, {
  description = "run prompt",
  group = "launcher"
}))

-- Tags related keybindings
keys.global_keys = gears.table.join(keys.global_keys, 
awful.key({MODKEY}, "Left", awful.tag.viewprev, {
  description = "view previous",
  group = "tag"
}), awful.key({MODKEY}, "Right", awful.tag.viewnext, {
  description = "view next",
  group = "tag"
}), awful.key({MODKEY}, "Escape", awful.tag.history.restore, {
  description = "go back",
  group = "tag"
}))

-- Focus related keybindings
keys.global_keys = gears.table.join(keys.global_keys, 
awful.key({MODKEY}, "j", function()
  awful.client.focus.byidx(1)
end, {
  description = "focus next by index",
  group = "client"
}), awful.key({MODKEY}, "k", function()
  awful.client.focus.byidx(-1)
end, {
  description = "focus previous by index",
  group = "client"
}), awful.key({MODKEY}, "Tab", function()
  awful.client.focus.history.previous()
  if client.focus then
      client.focus:raise()
  end
end, {
  description = "go back",
  group = "client"
}), awful.key({MODKEY, "Control"}, "j", function()
  awful.screen.focus_relative(1)
end, {
  description = "focus the next screen",
  group = "screen"
}), awful.key({MODKEY, "Control"}, "k", function()
  awful.screen.focus_relative(-1)
end, {
  description = "focus the previous screen",
  group = "screen"
}), awful.key({MODKEY, "Control"}, "n", function()
  local c = awful.client.restore()
  -- Focus restored client
  if c then
      c:activate{
          raise = true,
          context = "key.unminimize"
      }
  end
end, {
  description = "restore minimized",
  group = "client"
}))

-- Layout related keybindings
keys.global_keys = gears.table.join(keys.global_keys, 
awful.key({MODKEY, "Shift"}, "j", function()
  awful.client.swap.byidx(1)
end, {
  description = "swap with next client by index",
  group = "client"
}), awful.key({MODKEY, "Shift"}, "k", function()
  awful.client.swap.byidx(-1)
end, {
  description = "swap with previous client by index",
  group = "client"
}), awful.key({MODKEY}, "u", awful.client.urgent.jumpto, {
  description = "jump to urgent client",
  group = "client"
}), awful.key({MODKEY}, "l", function()
  awful.tag.incmwfact(0.05)
end, {
  description = "increase master width factor",
  group = "layout"
}), awful.key({MODKEY}, "h", function()
  awful.tag.incmwfact(-0.05)
end, {
  description = "decrease master width factor",
  group = "layout"
}), awful.key({MODKEY, "Shift"}, "h", function()
  awful.tag.incnmaster(1, nil, true)
end, {
  description = "increase the number of master clients",
  group = "layout"
}), awful.key({MODKEY, "Shift"}, "l", function()
  awful.tag.incnmaster(-1, nil, true)
end, {
  description = "decrease the number of master clients",
  group = "layout"
}), awful.key({MODKEY, "Control"}, "h", function()
  awful.tag.incncol(1, nil, true)
end, {
  description = "increase the number of columns",
  group = "layout"
}), awful.key({MODKEY, "Control"}, "l", function()
  awful.tag.incncol(-1, nil, true)
end, {
  description = "decrease the number of columns",
  group = "layout"
}), awful.key({MODKEY}, "space", function()
  awful.layout.inc(1)
end, {
  description = "select next",
  group = "layout"
}), awful.key({MODKEY, "Shift"}, "space", function()
  awful.layout.inc(-1)
end, {
  description = "select previous",
  group = "layout"
}))

keys.global_keys = gears.table.join(keys.global_keys, 
awful.key {
  modifiers = {MODKEY},
  keygroup = "numrow",
  description = "only view tag",
  group = "tag",
  on_press = function(index)
      local screen = awful.screen.focused()
      local tag = screen.tags[index]
      if tag then
          tag:view_only()
      end
  end
}, awful.key {
  modifiers = {MODKEY, "Control"},
  keygroup = "numrow",
  description = "toggle tag",
  group = "tag",
  on_press = function(index)
      local screen = awful.screen.focused()
      local tag = screen.tags[index]
      if tag then
          awful.tag.viewtoggle(tag)
      end
  end
}, awful.key {
  modifiers = {MODKEY, "Shift"},
  keygroup = "numrow",
  description = "move focused client to tag",
  group = "tag",
  on_press = function(index)
      if client.focus then
          local tag = client.focus.screen.tags[index]
          if tag then
              client.focus:move_to_tag(tag)
          end
      end
  end
}, awful.key {
  modifiers = {MODKEY, "Control", "Shift"},
  keygroup = "numrow",
  description = "toggle focused client on tag",
  group = "tag",
  on_press = function(index)
      if client.focus then
          local tag = client.focus.screen.tags[index]
          if tag then
              client.focus:toggle_tag(tag)
          end
      end
  end
}, awful.key {
  modifiers = {MODKEY},
  keygroup = "numpad",
  description = "select layout directly",
  group = "layout",
  on_press = function(index)
      local t = awful.screen.focused().selected_tag
      if t then
          t.layout = t.layouts[index] or t.layout
      end
  end
})

-- Custom keybindings
keys.global_keys = gears.table.join(keys.global_keys, 
  awful.key({MODKEY, "Control"}, "l", function()
  awful.spawn("sxlock")
end, {
  description = "lock the screen",
  group = "custom"
}), awful.key({"Shift"}, "Print", function()
  awful.spawn("selection_screenshot")
end, {
  description = "select area and copy screenshot",
  group = "custom"
}), awful.key({}, "XF86AudioRaiseVolume", function()
  VOLUME_CFG:up()
end, {
  description = "raise volume",
  group = "audio"
}), awful.key({}, "XF86AudioLowerVolume", function()
  VOLUME_CFG:down()
end, {
  description = "lower volume",
  group = "audio"
}), awful.key({}, "XF86AudioMute", function()
  VOLUME_CFG:toggle()
end, {
  description = "mute output",
  group = "audio"
}), awful.key({MODKEY}, ".", function()
  awful.spawn("emoji")
end, {
  description = "emoji picker",
  group = "custom"
}))

root.keys(keys.global_keys)
