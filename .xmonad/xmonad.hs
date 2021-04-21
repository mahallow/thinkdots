-- The Liam "I wish I was using AwesomeWM but for some reason I'm here" official XMonad config--

import XMonad hiding ( (|||) ) -- jump to layout
import XMonad.Layout.LayoutCombinators (JumpToLayout(..), (|||)) -- jump to layout
import XMonad.Config.Desktop
import System.Exit
import qualified XMonad.StackSet as W
-- data
import Data.Char (isSpace)
import Data.List
import Data.Monoid
import Data.Maybe (isJust)
import Data.Ratio ((%)) -- for video
import qualified Data.Map as M

-- system
import System.IO (hPutStrLn) -- for xmobar

-- util
import XMonad.Util.Run (safeSpawn, unsafeSpawn, runInTerm, spawnPipe)
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig (additionalKeysP, additionalMouseBindings)  
import XMonad.Util.NamedScratchpad
import XMonad.Util.NamedWindows
import XMonad.Util.WorkspaceCompare

-- hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks (avoidStruts, docksStartupHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.EwmhDesktops -- to show workspaces in application switchers#9d9d9d
import XMonad.Hooks.ManageHelpers (isFullscreen, isDialog,  doFullFloat, doCenterFloat, doRectFloat) 
import XMonad.Hooks.Place (placeHook, withGaps)
import XMonad.Hooks.UrgencyHook

-- actions
import XMonad.Actions.CopyWindow -- for dwm window style tagging
import XMonad.Actions.UpdatePointer -- update mouse postion

-- layout 
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import XMonad.Layout.NoBorders
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Spacing
import XMonad.Layout.Tabbed
import XMonad.Layout.GridVariants
import XMonad.Layout.ResizableTile
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.Gaps

------------------------------------------------------------------------
-- variables
------------------------------------------------------------------------
--myGaps = gaps [(U, gap),(D, gap),(L, gap),(R, gap)]
myModMask = mod4Mask -- Sets modkey to super/windows key
myTerminal = "kitty" -- Sets default terminal
myBorderWidth = 1 -- Sets border width for windows
myNormalBorderColor = "#34495e"

myFocusedBorderColor = "#9d9d9d"
myppCurrent = "#cb4b16"
myppVisible = "#cb4b16"
myppHidden = "#268bd2"
myppHiddenNoWindows = "#93A1A1"
myppTitle = "#FDF6E3"
myppUrgent = "#DC322F"
myWorkspaces = ["1","2","3","4","5","6","7", "8", "9"]
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

------------------------------------------------------------------------
-- desktop notifications -- dunst package required
------------------------------------------------------------------------
 
data LibNotifyUrgencyHook = LibNotifyUrgencyHook deriving (Read, Show)
 
instance UrgencyHook LibNotifyUrgencyHook where
    urgencyHook LibNotifyUrgencyHook w = do
        name     <- getName w
        Just idx <- fmap (W.findTag w) $ gets windowset
 
        safeSpawn "notify-send" [show name, "workspace " ++ idx]
 
------------------------------------------------------------------------
-- Startup hook
------------------------------------------------------------------------

myStartupHook = do
      spawnOnce "nitrogen --restore &" 
      spawnOnce "xmodmap ~/.Xmodmap" 

------------------------------------------------------------------------
-- layout
------------------------------------------------------------------------
-- spacing maybe?
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True
-- end spacing
myLayout = avoidStruts (tiled ||| grid ||| bsp ||| simpleTabbed) 
  where
     -- tiled
     tiled = renamed [Replace "Tall"] 
          -- $ spacingRaw True (Border 10 0 10 0) True (Border 0 10 0 10) True 
	   $ mySpacing 6
           $ ResizableTall 1 (3/100) (1/2) []

     -- grid
     grid = renamed [Replace "Grid"] 
          $ spacingRaw True (Border 10 0 10 0) True (Border 0 10 0 10) True 
	  $ mySpacing 15
          $ Grid (16/10)
     -- bsp
     bsp = renamed [Replace "BSP"] 
	 $ mySpacing 8
         $ emptyBSP

     -- The default number of windows in the master pane
     nmaster = 1
     
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:
------------------------------------------------------------------------

myManageHook = composeAll
    [ className =? "mpv"            --> doRectFloat (W.RationalRect (1 % 4) (1 % 4) (1 % 2) (1 % 2))
    , className =? "Gimp"           --> doFloat
    , className =? "nitrogen"       --> doFloat
    , className =? "Firefox" <&&> resource =? "Toolkit" --> doFloat -- firefox pip
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore 
    , isFullscreen --> doFullFloat
    ]
    
------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
------------------------------------------------------------------------

myKeys =
    [("M-" ++ m ++ k, windows $ f i)
        | (i, k) <- zip (myWorkspaces) (map show [1 :: Int ..])
        , (f, m) <- [(W.view, ""), (W.shift, "S-"), (copy, "S-C-")]]
    ++
    [("S-C-a", windows copyToAll)   -- copy window to all workspaces
     , ("S-C-z", killAllOtherCopies)  -- kill copies of window on other workspaces
     , ("M-a", sendMessage MirrorExpand)
     , ("M-z", sendMessage MirrorShrink)
     , ("M-s", sendMessage ToggleStruts)
     , ("M-f", sendMessage $ JumpToLayout "Full")
     , ("M-t", sendMessage $ JumpToLayout "Tall")
     , ("M-g", sendMessage $ JumpToLayout "Grid")
     , ("M-b", sendMessage $ JumpToLayout "BSP")
     , ("M-,", spawn "rofi -show drun") -- rofi
     , ("M-e", sendMessage $ ToggleGaps)  -- toggle all gaps

     , ("M-k", spawn "kitty") -- rofi
     , ("M-u", spawn "kitty vifm") -- rofi
     , ("M-o", spawn "qutebrowser") -- rofi
     , ("M-S-l", spawn "i3lock-fancy-rapid 8 3") -- lockscreen
     , ("<XF86MonBrightnessUp>", spawn "brightnessctl -d intel_backlight set +300") -- rofi
     , ("<XF86MonBrightnessDown>", spawn "brightnessctl -d intel_backlight set 300-") -- rofi
     , ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- unmute") -- rofi
     , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ unmute") -- rofi
     , ("<XF86AudioMute>", spawn "amixer sset Master toggle") -- rofi
     , ("<XF86AudioMicMute>", spawn "amixer sset Capture toggle") -- rofi
     , ("S-M-t", withFocused $ windows . W.sink) -- flatten floating window to tiled
    ]
    
------------------------------------------------------------------------
-- main
------------------------------------------------------------------------

main = do
    xmproc0 <- spawnPipe "xmobar -x 0 ~/.xmonad/xmobar/xmobarrc"
    xmproc1 <- spawnPipe "/usr/local/bin/xmobar -x 1 ~/.xmonad/xmobar/xmobarrc"
    xmonad $ withUrgencyHook LibNotifyUrgencyHook $ ewmh desktopConfig
        { manageHook = manageDocks <+> myManageHook <+> manageHook desktopConfig
        , startupHook        = myStartupHook
        , layoutHook         = myLayout
        , handleEventHook    = handleEventHook desktopConfig
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , terminal           = myTerminal
        , modMask            = myModMask
        , normalBorderColor  = myNormalBorderColor
        , focusedBorderColor = myFocusedBorderColor
        , logHook = dynamicLogWithPP xmobarPP  
                        { ppOutput = \x -> hPutStrLn xmproc0 x >> hPutStrLn xmproc1 x
                        , ppCurrent = xmobarColor myppCurrent "" . wrap "[" "]" -- Current workspace in xmobar
                        , ppVisible = xmobarColor myppVisible ""                -- Visible but not current workspace
                        , ppHidden = xmobarColor myppHidden "" . wrap "+" ""   -- Hidden workspaces in xmobar
                        , ppHiddenNoWindows = xmobarColor  myppHiddenNoWindows ""        -- Hidden workspaces (no windows)
                        , ppTitle = xmobarColor  myppTitle "" . shorten 80     -- Title of active window in xmobar
                        , ppSep =  "<fc=#586E75> | </fc>"                     -- Separators in xmobar
                        , ppUrgent = xmobarColor  myppUrgent "" . wrap "!" "!"  -- Urgent workspace
                        , ppExtras  = [windowCount]                           -- # of windows current workspace
                        , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                        } >> updatePointer (0.25, 0.25) (0.25, 0.25)
          }
          `additionalKeysP` myKeys
