{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE MultiWayIf #-}
{-# LANGUAGE TypeApplications #-}

import Data.List (intercalate, isInfixOf)
import qualified Theme.Nord as Theme
import XMonad.Hooks.StatusBar.PP (xmobarColor, xmobarFont)
import XMonad.Prompt.Man (getCommandOutput)
import Xmobar hiding (alignSep)
import qualified Xmobar as X (alignSep)

config :: Config
config =
  defaultConfig
    { font = "xft:monospace:size=10:antialias=true:hinting=true",
      additionalFonts = ["xft:Symbols Nerd Font:size=14"],
      textOffset = 18,
      textOffsets = [19],
      position = TopH 25,
      bgColor = Theme.backgroundColor,
      commands =
        [ Run KeyboardLayout,
          Run Volume,
          Run $ Date (textColor Theme.calendarWidgetColor $ calendarIcon <> " %d.%m.%Y") "calendar" 50,
          Run $ Date (textColor Theme.clockWidgetColor $ clockIcon <> " %H:%M") "clock" 50
        ],
      sepChar = "%",
      X.alignSep = alignSep,
      template =
        alignSep
          <> intercalate
            spacer
            [ "%keyboardLayout%",
              "%volume%",
              "%calendar%",
              "%clock%"
            ]
          <> spacer
    }
  where
    -- Templating utilities
    alignSep = "}{"
    spacer = "    "

-- Styling functions
textColor :: String -> String -> String
textColor c = xmobarColor c Theme.backgroundColor

icon :: String -> String
icon = xmobarFont 1

-- Icons
clockIcon, calendarIcon, volumeMutedIcon, volumeSilentIcon, volumeNormalIcon, keyboardIcon :: String
clockIcon = icon "\xf64f"
calendarIcon = icon "\xf5ec"
volumeMutedIcon = icon "\xfa80"
volumeSilentIcon = icon "\xf026"
volumeNormalIcon = icon "\xfa7d"
keyboardIcon = icon "\xf11c"

data Volume = Volume deriving (Read, Show)

instance Exec Volume where
  alias _ = "volume"
  run _ = do
    volume <- read @Int <$> getCommandOutput "pamixer --get-volume"
    isMuted <-
      ( \out ->
          if
              | "true" `isInfixOf` out -> True
              | "false" `isInfixOf` out -> False
              | otherwise -> error "Unexpected output"
        )
        <$> getCommandOutput "pamixer --get-mute"
    let volumeIcon =
          if
              | isMuted -> volumeMutedIcon
              | volume == 0 -> volumeSilentIcon
              | otherwise -> volumeNormalIcon
    let color = if isMuted then Theme.red else Theme.green
    pure $ textColor color $ volumeIcon <> " " <> show volume <> "%"
  rate _ = 1

data KeyboardLayout = KeyboardLayout deriving (Read, Show)

instance Exec KeyboardLayout where
  alias _ = "keyboardLayout"
  run _ = do
    layout <- getCommandOutput "xkblayout-state print \"%s\""
    pure $ textColor Theme.keyboardWidgetColor $ keyboardIcon <> " " <> layout
  rate _ = 1

main :: IO ()
main = do
  configFromArgs config >>= xmobar
