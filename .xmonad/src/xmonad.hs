-- IMPORTS
import Control.Monad (when)
import Data.Foldable (traverse_)
import qualified Data.Map as M
import Data.Semigroup (All, Endo)
import System.Exit (exitSuccess)
import Theme.Nord
import XMonad
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.ManageDocks (avoidStruts, docks)
import XMonad.Hooks.RefocusLast (refocusLastLayoutHook, toggleFocus)
import XMonad.Hooks.WorkspaceHistory (workspaceHistory, workspaceHistoryHook)
import XMonad.Layout.IndependentScreens (countScreens)
import XMonad.Layout.Tabbed (simpleTabbed)
import qualified XMonad.StackSet as W
import XMonad.Util.SpawnOnce (spawnOnce)

myTerminal :: String
myTerminal = "alacritty"

myFocusFollowsMouse, myClickJustFocuses :: Bool
-- Whether focus follows the mouse pointer.
myFocusFollowsMouse = False
-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses = False

myBorderWidth :: Dimension
myBorderWidth = 1

myModMask :: KeyMask
myModMask = mod4Mask

myWorkspaces :: [[Char]]
myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

-- Key bindings
myKeys :: XConfig l -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@XConfig {XMonad.modMask = modm} =
  M.fromList $
    -- launch a terminal
    [ ((modm, xK_Return), spawn $ XMonad.terminal conf),
      -- rofi run menu
      ((modm, xK_r), spawn "rofi -show run"),
      -- rofi app menu
      ((modm, xK_p), spawn "rofi -show"),
      -- lock the screen
      ((modm .|. controlMask, xK_s), spawn "lockscreen"),
      -- lock the screen
      ((modm .|. shiftMask, xK_Print), spawn "selection_screenshot"),
      -- emoji picker
      ((modm, xK_period), spawn "emoji"),
      -- close focused window
      ((modm, xK_q), kill),
      -- Rotate through the available layout algorithms
      ((modm, xK_space), sendMessage NextLayout),
      -- Toggle previous workspace
      ((modm, xK_Escape), toggleGreedyWS),
      -- Resize viewed windows to the correct size
      ((modm, xK_n), refresh),
      -- Toggle previous window
      ((modm, xK_Tab), toggleFocus),
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
      ((modm .|. controlMask, xK_r), spawn "xmonad --recompile; killall xmobar; xmonad --restart")
      -- TODO implement help window somehow
      -- TODO screen switching
    ]
      ++
      -- mod-[1..9], Switch to workspace N
      [((modm, k), windows $ W.greedyView i) | (i, k) <- workspaceKeys]
      ++
      -- mod-shift-[1..9], Move client to workspace N
      [((modm .|. shiftMask, k), windows $ W.shift i) | (i, k) <- workspaceKeys]
  where
    workspaceKeys :: [(String, KeySym)]
    workspaceKeys = zip (XMonad.workspaces conf) [xK_1 .. xK_9]

    toggleGreedyWS :: X ()
    toggleGreedyWS = do
      history <- workspaceHistory
      when (length history >= 2) $ windows $ W.greedyView $ history !! 1

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
    ]

-- Layouts
myLayout = refocusLastLayoutHook $ avoidStruts (tiled ||| Mirror tiled ||| Full ||| simpleTabbed)
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
myManageHook :: Query (Endo WindowSet)
myManageHook =
  composeAll
    [ className =? "MPlayer" --> doFloat,
      className =? "Gimp" --> doFloat,
      resource =? "desktop_window" --> doIgnore,
      resource =? "kdesktop" --> doIgnore
    ]

-- Event handling
myEventHook :: Event -> X All
myEventHook = mempty

-- Perform an arbitrary action on each internal state change or X event
myLogHook :: X ()
myLogHook =
  workspaceHistoryHook

-- Startup hook
myStartupHook :: X ()
myStartupHook = do
  traverse_
    spawnOnce
    [ "wallpaper nord",
      "remaps",
      "picom &",
      "killall udiskie ; udiskie"
    ]
  nScreens <- countScreens :: X Int
  traverse_ spawn $ ("xmobar -x " <>) . show <$> [0 .. nScreens - 1]

-- Run XMonad
main :: IO ()
main = do
  xmonad $ docks defaults

defaults =
  ewmh $
    def
      { terminal = myTerminal,
        focusFollowsMouse = myFocusFollowsMouse,
        clickJustFocuses = myClickJustFocuses,
        borderWidth = myBorderWidth,
        modMask = myModMask,
        workspaces = myWorkspaces,
        normalBorderColor = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,
        keys = myKeys,
        mouseBindings = myMouseBindings,
        layoutHook = myLayout,
        manageHook = myManageHook,
        handleEventHook = myEventHook,
        logHook = myLogHook,
        startupHook = myStartupHook
      }
