-- Main Imports
import XMonad
import XMonad.Config.Xfce (xfceConfig)
-- Layout Imports

import XMonad.Hooks.ManageDocks (AvoidStruts, avoidStruts)
import XMonad.Layout
import XMonad.Layout.Grid (Grid (Grid))
import XMonad.Layout.LayoutModifier (ModifiedLayout)
import XMonad.Layout.NoBorders (noBorders, smartBorders)
import XMonad.Layout.Reflect (reflectHoriz)
import XMonad.Layout.Spacing
  ( Border (Border),
    Spacing,
    spacingRaw,
  )
import XMonad.StackSet as W
-- Startup Imports

-- Utilities
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Hooks.DynamicProperty (dynamicPropertyChange)

-- My Constants
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

myClickJustFocuses :: Bool
myClickJustFocuses = False

myTerminal :: String
myTerminal = "kitty"

-- Colors & Styles
myNormalBorderColor :: String
myNormalBorderColor = "#000000"

myFocusedBorderColor :: String
myFocusedBorderColor = "#33ff55"

myBorderWidth :: Dimension
myBorderWidth = 1

mySpacingWidth :: Integer
mySpacingWidth = 8

myModMask :: KeyMask
myModMask = mod4Mask

myNamedWorkspaces :: [String]
myNamedWorkspaces = ["Web", "Cmd", "Code", "Comm", "Per", "Mus", "Vid", "Float"]

myAdditionalKeys :: [(String, X ())]
myAdditionalKeys =
  [ ("M-d", spawn "dmenu_run -fn \"Liberation Mono-14\"")
  , ("C-M-b", spawn "brave-browser")
  , ("C-M-s", spawn "slack")
  , ("C-M-z", spawn myTerminal)
  , ("M-s t", namedScratchpadAction myScratchpads "terminal")
  , ("M-z", namedScratchpadAction myScratchpads "terminal")
  , ("M-m", namedScratchpadAction myScratchpads "spotify")
  , ("M-s h", namedScratchpadAction myScratchpads "htop")
  ]

manageFloating = customFloating $ W.RationalRect l t w h
  where
    h = 0.9
    w = 0.9
    t = 0.95 -h
    l = 0.95 -w
floatSpotify = dynamicPropertyChange "WM_CLASS" (resource =? "spotify" --> manageFloating)

myScratchpads =
  [ NS "terminal" spawnTerm findTerm manageFloating
  , NS "htop" spawnHtop findHtop manageFloating
  , NS "spotify" spawnSpot findSpot manageFloating
  ]
  where
    spawnTerm = myTerminal ++ " --name scratchpad-term"
    findTerm = resource =? "scratchpad-term"
    spawnHtop = myTerminal ++ " --name scratchpad-htop htop"
    findHtop = resource =? "scratchpad-htop"
    spawnSpot = "spotify"
    findSpot = resource =? "spotify"

myStartupHook = do
  spawnOnce "picom -cfF -t-9 -l-11 r9 -o.95 -D6&"

-- Utility Functions
symmetricalSpacing :: Integer -> Border
symmetricalSpacing i = Border i i i i

mySpacing :: l a -> ModifiedLayout Spacing l a
mySpacing = spacingRaw True (symmetricalSpacing mySpacingWidth) True (symmetricalSpacing mySpacingWidth) True

-- Layout Definitions
myLayout =
  avoidStruts $ mySpacing $ tall ||| grid ||| mirroredTall ||| full ||| backwardsTall
  where
    backwardsTall = reflectHoriz tall
    mirroredTall = Mirror tall
    tall = Tall 1 (3 / 100) (3 / 5)
    grid = Grid
    full = Full

workspaceFiller = drop (length myNamedWorkspaces) $ map show [1 .. 9]

myWorkspaces :: [String]
myWorkspaces = myNamedWorkspaces ++ workspaceFiller

main :: IO ()
main =
  xmonad $
    xfceConfig
      { focusFollowsMouse = myFocusFollowsMouse
      , clickJustFocuses = myClickJustFocuses
      , modMask = myModMask
      , layoutHook = myLayout
      , borderWidth = myBorderWidth
      , focusedBorderColor = myFocusedBorderColor
      , normalBorderColor = myNormalBorderColor
      , startupHook = myStartupHook
      , manageHook = manageHook xfceConfig <+> namedScratchpadManageHook myScratchpads
      , handleEventHook = handleEventHook xfceConfig <+> floatSpotify
      }
      `additionalKeysP` myAdditionalKeys
