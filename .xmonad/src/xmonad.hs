-- IMPORTS

import Data.Foldable (traverse_)
import qualified Data.Map as M
import System.Exit
import Theme.Nord
import XMonad
import XMonad.Hooks.ManageDocks
import qualified XMonad.StackSet as W
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.SpawnOnce

myTerminal, myTextEditor :: String
myTerminal = "alacritty"
myTextEditor = "nvim"

myFocusFollowsMouse, myClickJustFocuses :: Bool
-- Whether focus follows the mouse pointer.
myFocusFollowsMouse = False
-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses = False

myBorderWidth = 1

myModMask = mod4Mask

myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

-- Key bindings
myKeys conf@(XConfig {XMonad.modMask = modm}) =
  M.fromList $
    -- launch a terminal
    [ ((modm, xK_Return), spawn $ XMonad.terminal conf),
      -- rofi run menu
      ((modm, xK_r), spawn "rofi -show run"),
      -- rofi app menu
      ((modm, xK_p), spawn "rofi -show"),
      -- close focused window
      ((modm, xK_q), kill),
      -- Rotate through the available layout algorithms
      ((modm, xK_space), sendMessage NextLayout),
      -- Resize viewed windows to the correct size
      ((modm, xK_n), refresh),
      -- Move focus to the next window
      -- TODO focus previous window somehow
      -- , ((modm,               xK_Tab   ), windows undefined)

      -- Move focus to the next window
      ((modm, xK_j), windows W.focusDown),
      -- Move focus to the previous window
      ((modm, xK_k), windows W.focusUp),
      -- Move focus to the master window
      -- , ((modm .|. controlMask,               xK_m     ), windows W.focusMaster  )

      -- Swap the focused window and the master window
      ((modm .|. controlMask, xK_Return), windows W.swapMaster),
      -- Swap the focused window with the next window
      ((modm .|. shiftMask, xK_j), windows W.swapDown),
      -- Swap the focused window with the previous window
      ((modm .|. shiftMask, xK_k), windows W.swapUp),
      -- Shrink the master area
      ((modm, xK_h), sendMessage Shrink),
      -- Expand the master area
      ((modm, xK_l), sendMessage Expand),
      -- Push window back into tiling
      ((modm, xK_t), withFocused $ windows . W.sink),
      -- Increment the number of windows in the master area
      ((modm .|. shiftMask, xK_l), sendMessage (IncMasterN 1)),
      -- Deincrement the number of windows in the master area
      ((modm .|. shiftMask, xK_h), sendMessage (IncMasterN (-1))),
      -- Toggle the status bar gap
      -- Use this binding with avoidStruts from Hooks.ManageDocks.
      -- See also the statusBar function from Hooks.DynamicLog.
      --
      -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

      -- Quit xmonad
      ((modm .|. shiftMask, xK_q), io exitSuccess),
      -- Restart xmonad
      ((modm .|. controlMask, xK_r), spawn "xmonad --recompile; xmonad --restart")
      -- TODO implement help window somehow
    ]
      ++
      --
      -- mod-[1..9], Switch to workspace N
      -- mod-shift-[1..9], Move client to workspace N
      --
      [ ((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9],
          (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
      ]

-- TODO screen switching and moving windows

-- Mouse bindings
myMouseBindings :: XConfig l -> M.Map (KeyMask, Button) (Window -> X ())
myMouseBindings XConfig {XMonad.modMask = modm} =
  M.fromList
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ( (modm, button1),
        \w ->
          focus w >> mouseMoveWindow w
            >> windows W.shiftMaster
      ),
      -- mod-button2, Raise the window to the top of the stack
      ((modm, button2), \w -> focus w >> windows W.shiftMaster),
      -- mod-button3, Set the window to floating mode and resize by dragging
      ( (modm, button3),
        \w ->
          focus w >> mouseResizeWindow w
            >> windows W.shiftMaster
      )
      -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

-- Layouts
myLayout = avoidStruts (tiled ||| Mirror tiled ||| Full)
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled = Tall nmaster delta ratio

    -- The default number of windows in the master pane
    nmaster = 1

    -- Default proportion of screen occupied by master pane
    ratio = 1 / 2

    -- Percent of screen to increment by when resizing panes
    delta = 3 / 100

-- Window rules
myManageHook =
  composeAll
    [ className =? "MPlayer" --> doFloat,
      className =? "Gimp" --> doFloat,
      resource =? "desktop_window" --> doIgnore,
      resource =? "kdesktop" --> doIgnore
    ]

-- Event handling
myEventHook = mempty

-- Perform an arbitrary action on each internal state change or X event
myLogHook = return ()

-- Startup hook
myStartupHook :: X ()
myStartupHook =
  traverse_
    spawnOnce
    [ "wallpaper nord",
      "remaps",
      "picom &",
      "killall udiskie ; udiskie"
    ]

-- Run XMonad
main = do
  -- xmproc <- spawnPipe "xmobar -x 0 $HOME/.config/xmobar/.xmobarrc"
  -- xmproc <- spawnPipe "xmobar -x 1 $HOME/.config/xmobar/.xmobarrc"
  xmonad $ docks defaults

defaults =
  def
    { -- simple stuff
      terminal = myTerminal,
      focusFollowsMouse = myFocusFollowsMouse,
      clickJustFocuses = myClickJustFocuses,
      borderWidth = myBorderWidth,
      modMask = myModMask,
      workspaces = myWorkspaces,
      normalBorderColor = myNormalBorderColor,
      focusedBorderColor = myFocusedBorderColor,
      -- key bindings
      keys = myKeys,
      mouseBindings = myMouseBindings,
      -- hooks, layouts
      layoutHook = myLayout,
      manageHook = myManageHook,
      handleEventHook = myEventHook,
      logHook = myLogHook,
      startupHook = myStartupHook
    }
