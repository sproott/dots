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
      commands = [Run Volume, Run $ Date (textColor Theme.accent1 $ calendarIcon <> " %d.%m.%Y") "calendar" 50, Run $ Date (textColor Theme.accent4 $ clockIcon <> " %H:%M") "clock" 50],
      sepChar = "%",
      X.alignSep = alignSep,
      template = alignSep <> intercalate spacer ["%volume%", "%calendar%", "%clock%"] <> spacer
    }
  where
    -- Templating utilities
    alignSep = "}{"
    spacer = "   "

-- Styling functions
textColor c = xmobarColor c Theme.backgroundColor

icon = xmobarFont 1

-- Icons
clockIcon, calendarIcon, volumeMutedIcon, volumeSilentIcon, volumeNormalIcon :: String
clockIcon = icon "\xf64f"
calendarIcon = icon "\xf5ec"
volumeMutedIcon = icon "\xfa80"
volumeSilentIcon = icon "\xf026"
volumeNormalIcon = icon "\xfa7d"

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
    let color = if isMuted then Theme.accent0 else Theme.accent3
    pure $ textColor color $ volumeIcon <> " " <> show volume <> "%"

  rate _ = 1

main :: IO ()
main = do
  configFromArgs config >>= xmobar
