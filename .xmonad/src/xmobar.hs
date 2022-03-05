import Xmobar

config :: Config
config =
  defaultConfig
    { commands = [Run $ Date "%a %b %_d %l:%M" "date" 10],
      template = "%date%"
    }

main :: IO ()
main = configFromArgs config >>= xmobar
