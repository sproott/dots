-- Keeps each client on its home screen (laptop or external) and tag number
-- across monitor unplugs, autorandr profile switches and awesome restarts.
local awful = require('awful')
local gears = require('gears')

local HOME_SCREEN = 'home_screen'
local HOME_TAG = 'home_tag'

awful.client.property.persist(HOME_SCREEN, 'string')
awful.client.property.persist(HOME_TAG, 'number')

-- Moves made here, and tagging during startup, must not overwrite the
-- remembered home.
local restoring = false
local started = false

-- Output names are unstable (the external monitor alternates between
-- DisplayPort-5 and DisplayPort-6), so screens are told apart only as
-- laptop panel vs. external.
local function kind(s)
  for k, v in pairs(s.outputs or {}) do
    local name = type(k) == 'string' and k or v.name
    if name and name:match('^eDP') then
      return 'internal'
    end
  end
  return 'external'
end

local function screen_of_kind(k)
  for s in screen do
    if kind(s) == k then
      return s
    end
  end
end

-- Unset persisted properties read back as '' or 0, not nil.
local function home_of(c)
  local k = awful.client.property.get(c, HOME_SCREEN)
  local i = awful.client.property.get(c, HOME_TAG)
  if k == 'internal' or k == 'external' then
    return k, i
  end
end

local function remember(c, t)
  if restoring or not started or not c.valid or not t or not t.screen then
    return
  end
  -- While a client's home screen is unplugged it only visits the other one.
  local home = home_of(c)
  if home and not screen_of_kind(home) then
    return
  end
  awful.client.property.set(c, HOME_SCREEN, kind(t.screen))
  awful.client.property.set(c, HOME_TAG, t.index)
end

local function is_home(c, t)
  return c.screen == t.screen and gears.table.hasitem(c:tags(), t) ~= nil
end

-- Clients whose home screen is unplugged are placed on the same tag number
-- of `s` when `s` is the fallback screen.
local function restore(s)
  if not s.valid then
    return
  end
  local k = kind(s)
  local fallback = s == screen.primary or screen.count() == 1
  restoring = true
  for _, c in ipairs(client.get()) do
    local home, index = home_of(c)
    if home == k or (fallback and home and not screen_of_kind(home)) then
      local t = s.tags[index]
      if t and not is_home(c, t) then
        c:move_to_tag(t)
      end
    end
  end
  restoring = false
end

client.connect_signal('tagged', remember)

-- Replaces awesome's default rescue, which dumps every client of a removed
-- screen onto tag 1 of the remaining one.
tag.connect_signal(
  'request::screen',
  function(t, context)
    if context ~= 'removed' then
      return
    end
    local target
    for s in screen do
      if s ~= t.screen and #s.tags > 0 then
        target = s
        break
      end
    end
    if not target then
      return
    end
    local dest = target.tags[t.index] or target.tags[1]
    restoring = true
    for _, c in ipairs(t:clients()) do
      c:move_to_tag(dest)
    end
    restoring = false
  end
)

-- Delayed so the new screen's tags exist.
screen.connect_signal(
  'added',
  function(s)
    gears.timer.delayed_call(restore, s)
  end
)

awesome.connect_signal(
  'startup',
  function()
    for s in screen do
      restore(s)
    end
    started = true
    for _, c in ipairs(client.get()) do
      if not home_of(c) then
        remember(c, c.first_tag)
      end
    end
  end
)
