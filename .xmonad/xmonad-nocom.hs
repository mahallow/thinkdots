import XMonad hiding ( (|||) )
import XMonad.Layout.LayoutCombinators (JumpToLayout(..), (|||))
import XMonad.Config.Desktop
import System.Exit
import qualified XMonad.StackSet as W
import Data.Char (isSpace)
import Data.List
import Data.Monoid
import Data.Maybe (isJust)
import Data.Ratio ((%))
import qualified Data.Map as M
import System.IO (hPutStrLn)
import XMonad.Util.Run (safeSpawn, unsafeSpawn, runInTerm, spawnPipe)
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig (additionalKeysP, additionalMouseBindings)  
import XMonad.Util.NamedScratchpad
import XMonad.Util.NamedWindows
import XMonad.Util.WorkspaceCompare
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks (avoidStruts, docksStartupHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers (isFullscreen, isDialog,  doFullFloat, doCenterFloat, doRectFloat) 
import XMonad.Hooks.Place (placeHook, withGaps)
import XMonad.Hooks.UrgencyHook
import XMonad.Actions.CopyWindow
import XMonad.Actions.UpdatePointer
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.GridVariants
import XMonad.Layout.ResizableTile
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.Gaps
myModMask = mod4Mask
myTerminal = "kitty"
myBorderWidth = 1
myNormalBorderColor = "#839496"
myFocusedBorderColor = "#268BD2"
myppCurrent = "#cb4b16"
myppVisible = "#cb4b16"
myppHidden = "#268bd2"
myppHiddenNoWindows = "#93A1A1"
myppTitle = "#FDF6E3"
myppUrgent = "#DC322F"
myWorkspaces = ["1","2","3","4","5","6","7","8","9"]
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset
data LibNotifyUrgencyHook = LibNotifyUrgencyHook deriving (Read, Show)
instance UrgencyHook LibNotifyUrgencyHook where
    urgencyHook LibNotifyUrgencyHook w = do
        name     <- getName w
        Just idx <- fmap (W.findTag w) $ gets windowset
        safeSpawn "notify-send" [show name, "workspace " ++ idx]
myStartupHook = do
      spawnOnce "nitrogen
myLayout = avoidStruts (tiled ||| grid ||| bsp)
  where
     full = renamed [Replace "Full"] 
          $ spacingRaw True (Border 10 0 10 0) True (Border 0 10 0 10) True 
          $ noBorders (Full)
     tiled = renamed [Replace "Tall"] 
           $ spacingRaw True (Border 10 0 10 0) True (Border 0 10 0 10) True 
           $ ResizableTall 1 (3/100) (1/2) []
     grid = renamed [Replace "Grid"] 
          $ spacingRaw True (Border 10 0 10 0) True (Border 0 10 0 10) True 
          $ Grid (16/10)
     bsp = renamed [Replace "BSP"] 
         $ spacingRaw True (Border 10 0 10 0) True (Border 0 10 0 10) True 
         $ emptyBSP
     nmaster = 1
     
     ratio   = 1/2
     delta   = 3/100
myManageHook = composeAll
    [ className =? "mpv"
    , className =? "Gimp"
    , className =? "nitrogen"
    , className =? "Firefox" <&&> resource =? "Toolkit"
    , resource  =? "desktop_window"
    , resource  =? "kdesktop"
    , isFullscreen
    ] <+> namedScratchpadManageHook myScratchpads
    
myKeys =
    [("M-" ++ m ++ k, windows $ f i)
        | (i, k) <- zip (myWorkspaces) (map show [1 :: Int ..])
        , (f, m) <- [(W.view, ""), (W.shift, "S-"), (copy, "S-C-")]]
    ++
    [("S-C-a", windows copyToAll)
     , ("S-C-z", killAllOtherCopies)
     , ("M-a", sendMessage MirrorExpand)
     , ("M-z", sendMessage MirrorShrink)
     , ("M-s", sendMessage ToggleStruts)
     , ("M-f", sendMessage $ JumpToLayout "Full")
     , ("M-t", sendMessage $ JumpToLayout "Tall")
     , ("M-g", sendMessage $ JumpToLayout "Grid")
     , ("M-b", sendMessage $ JumpToLayout "BSP")
     , ("M-,", spawn "rofi -show drun")
     , ("M-k", spawn "kitty")
     , ("M-u", spawn "kitty vifm")
     , ("M-o", spawn "qutebrowser")
     , ("M-S-l", spawn "i3lock-fancy-rapid 8 3")
     , ("<XF86MonBrightnessUp>", spawn "brightnessctl -d intel_backlight set +300")
     , ("<XF86MonBrightnessDown>", spawn "brightnessctl -d intel_backlight set 300-")
     , ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- unmute")
     , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ unmute")
     , ("S-M-t", withFocused $ windows . W.sink)
     , ("M-C-<Space>", namedScratchpadAction myScratchpads "terminal")
    ]
    
myScratchpads = [ NS "terminal" spawnTerm findTerm manageTerm
              , NS "emacs-scratch" spawnEmacsScratch findEmacsScratch manageEmacsScratch
                ] 
    where
    role = stringProperty "WM_WINDOW_ROLE"
    spawnTerm = myTerminal ++  " -name scratchpad"
    findTerm = resource =? "scratchpad"
    manageTerm = nonFloating
    findEmacsScratch = title =? "emacs-scratch"
    spawnEmacsScratch = "emacsclient -a='' -nc
    manageEmacsScratch = nonFloating
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
                        , ppCurrent = xmobarColor myppCurrent "" . wrap "[" "]"
                        , ppVisible = xmobarColor myppVisible ""
                        , ppHidden = xmobarColor myppHidden "" . wrap "+" ""
                        , ppHiddenNoWindows = xmobarColor  myppHiddenNoWindows ""
                        , ppTitle = xmobarColor  myppTitle "" . shorten 80
                        , ppSep =  "<fc=#586E75> | </fc>"
                        , ppUrgent = xmobarColor  myppUrgent "" . wrap "!" "!"
                        , ppExtras  = [windowCount]
                        , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                        } >> updatePointer (0.25, 0.25) (0.25, 0.25)
          }
          `additionalKeysP` myKeys
