module Theme.Nord
  ( -- Colors
    normalBorderColor,
    focusedBorderColor,
    backgroundColor,
    keyboardWidgetColor,
    calendarWidgetColor,
    clockWidgetColor,
    haskellIconColor,
    green,
    red,
  )
where

-- Palette definition
polarNight0, polarNight1, polarNight2, polarNight3 :: String
polarNight0 = "#2e3440"
polarNight1 = "#3b4252"
polarNight2 = "#434c5e"
polarNight3 = "#4c566a"

snowStorm0, snowStorm1, snowStorm2 :: String
snowStorm0 = "#d8dee9"
snowStorm1 = "#e5e9f0"
snowStorm2 = "#eceff4"

frost0, frost1, frost2, frost3 :: String
frost0 = "#8fbcbb"
frost1 = "#88c0d0"
frost2 = "#81a1c1"
frost3 = "#5e81ac"

auroraRed, auroraOrange, auroraYellow, auroraGreen, auroraPurple :: String
auroraRed = "#bf616a"
auroraOrange = "#d08770"
auroraYellow = "#ebcb8b"
auroraGreen = "#a3be8c"
auroraPurple = "#b48ead"

-- Colors
normalBorderColor, focusedBorderColor :: String
normalBorderColor = polarNight0
focusedBorderColor = frost2

backgroundColor :: String
backgroundColor = polarNight0

keyboardWidgetColor, calendarWidgetColor, clockWidgetColor :: String
keyboardWidgetColor = frost1
calendarWidgetColor = auroraOrange
clockWidgetColor = auroraPurple

haskellIconColor :: String
haskellIconColor = frost2

green, red :: String
green = auroraGreen
red = auroraRed
