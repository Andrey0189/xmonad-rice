-- Important stuff
import XMonad
import XMonad.Core

-- Hotkeys 
import XMonad.Util.EZConfig
import XMonad.Util.Ungrab

-- ThreeCol Layout
import XMonad.Layout.ThreeColumns

-- Fullscreen
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.NoBorders

-- Swap master
import qualified XMonad.StackSet as W

-- Xmobar
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Util.Loggers


term 	   = "st"
rofi 	   = "~/.config/rofi/launchers/type-7/launcher.sh"
sstool 	   = "flameshot gui"
web 	   = "chromium"
restartCmd = "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi"

volmute    = "~/.config/xmonad/dunstvol mute"
volup      = "~/.config/xmonad/dunstvol up"
voldown    = "~/.config/xmonad/dunstvol down"
recordrofi = "~/.config/xmonad/recordrofi"

colorFocused = "#71337a"
colorNormal  = "#333333"

-- Layouts configuration
myLayout = smartBorders tiled ||| threeCol ||| Mirror tiled ||| noBorders Full
  where
    threeCol = ThreeColMid nmaster delta ratio
    tiled    = Tall nmaster delta ratio
    nmaster  = 1      -- Default number of windows in the master pane
    ratio    = 1/2    -- Default proportion of screen occupied by master pane
    delta    = 3/100  -- Percent of screen to increment by when resizing panes

-- Floating rules
myManageHook = composeAll
    [ className =? "feh" --> doFloat
    , className =? "mpv" --> doFloat
    ]

-- Main config
myConfig = def 
	{ layoutHook         = myLayout
	, modMask            = mod4Mask
	, terminal           = term
	, borderWidth        = 3
	, workspaces         = [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]
	, normalBorderColor  = colorNormal
	, focusedBorderColor = colorFocused
	, manageHook = myManageHook <+> manageHook def
	}
	`additionalKeysP`
	[ ("M-<Return>", 	spawn term            	)
	, ("M-q", 		kill			)

	, ("M-<Space>", 	sendMessage NextLayout 	)
	, ("M-S-<Return>",	windows W.swapMaster 	)

	, ("M-C-q",		spawn restartCmd	)

	, ("M-d", 		spawn rofi              )
	, ("<Print>", 		unGrab *> spawn sstool  )
	, ("M-w"  , 		spawn web               )
	, ("M-r"  , 		spawn recordrofi        )

	, ("<XF86AudioMute>", 	spawn volmute		)
	, ("<XF86AudioRaiseVolume>", spawn volup	)
	, ("<XF86AudioLowerVolume>", spawn voldown	)
	]

myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = grey  "   •   "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = pureWhite . wrap " " "" . xmobarBorder "VBoth" colorFocused 4
    , ppHidden          = lowWhite . wrap " " ""
    , ppHiddenNoWindows = grey . wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    , ppExtras          = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused   = wrap (white    "[ ") (white    " ]") . blue    . ppWindow
    formatUnfocused = wrap (lowWhite "[ ") (lowWhite " ]") . magenta . ppWindow

    -- | Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    pureWhite = xmobarColor "#ffffff" ""
    magenta   = xmobarColor "#8f3f71" ""
    blue      = xmobarColor "#cc6493" ""
    white     = xmobarColor "#f8f8f2" ""
    yellow    = xmobarColor "#f1fa8c" ""
    red       = xmobarColor "#ff5555" ""
    lowWhite  = xmobarColor "#bbbbbb" ""
    grey      = xmobarColor "#696969" ""

main :: IO ()
main =    xmonad 
	. ewmhFullscreen 
	. ewmh 
	. withEasySB (statusBarProp "xmobar" (pure myXmobarPP)) defToggleStrutsKey
	$ myConfig
