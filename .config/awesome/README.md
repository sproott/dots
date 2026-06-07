# AwesomeWM config

Personal AwesomeWM configuration using the Nord theme.

## Per-machine profile label

When you run more than one account on a machine (e.g. personal vs work), you can
show a colored label and/or icon in the **center of the wibar** to tell them apart
at a glance. It is configured outside the checked-in code, so each account sets it
independently and it is never committed.

### Setup

1. Copy the example file:

   ```sh
   cp ~/.config/awesome/local.lua.example ~/.config/awesome/local.lua
   ```

2. Edit `local.lua` and set the fields you want (all optional):

   ```lua
   return {
     profile = {
       label = 'WORK',        -- text shown in the bar
       icon  = '\u{f0b1}',    -- a Nerd Font glyph
       color = '#bf616a',     -- any hex; defaults to the frost accent if omitted
     },
   }
   ```

3. Reload AwesomeWM (`Mod4+Ctrl+r`).

### Notes

- `local.lua` is gitignored — it stays out of version control.
- If `local.lua` is absent, or `profile` has neither `label` nor `icon`, nothing is
  shown and the wibar is unchanged.
- You can supply just a `label`, just an `icon`, or both.
