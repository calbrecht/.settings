import XMonad
-- import XMonad.Config
import qualified XMonad.StackSet as W -- to shift and float windows
-- import XMonad.Layout.IndependentScreens
import XMonad.Actions.UpdatePointer
import XMonad.Actions.WindowGo
import XMonad.Actions.OnScreen
import XMonad.Util.EZConfig (additionalKeys)
import Data.List (isInfixOf)
import Control.Monad (liftM2)
import XMonad.Layout.NoBorders
import XMonad.Hooks.ICCCMFocus -- Fix Java App Focus

main = xmonad $ defaultConfig
 
 { borderWidth        = 1
 , terminal           = "urxvt -e /bin/bash"
 , modMask            = mod4Mask -- Take the remapped Caps_Lock as modifier
 , manageHook         = manageHook defaultConfig <+> myManageHook
 , normalBorderColor  = "#002731"
 , focusedBorderColor = "#CB4B16"
 , workspaces         = ["1","2","3","4","5","6"]
 , layoutHook         = lessBorders (OnlyFloat) (Tall 1 (3/100) (1/2) ||| Mirror (Tall 1 (3/100) (1/2)) ||| noBorders Full)
 , logHook            = takeTopFocus -- Fix Java App Focus
                      --  >> updatePointer (Relative 0.5 0.5)

 } `additionalKeys`
   [ ((mod4Mask, xK_p), spawn "dmenu_run")
   , ((mod4Mask, xK_z), spawn "~/bin/timecard dmenu")
   , ((0, 0x1008ff12), spawn "~/bin/audioVolume toggle")
   , ((0, 0x1008ff11), spawn "~/bin/audioVolume lower")
   , ((0, 0x1008ff13), spawn "~/bin/audioVolume raise")
   , ((mod4Mask, xK_q), kill)
   , ((mod1Mask .|. controlMask, xK_l), spawn "xscreensaver-command -lock")
   , ((mod4Mask, xK_u), raiseMaybe     (spawn "urxvt -title mainConsole -e /bin/bash") $ query "mainConsole"     )
   , ((mod4Mask, xK_r), runOrRaise     "gajim"                            $ query "rosterEmpathy"   )
   , ((mod4Mask, xK_t), runOrRaise     "thunderbird"                      $ query "mailThunderbird" )
--   , ((mod4Mask, xK_f), runOrRaise     "chromium"                         $ query "navigatorChromium")
   , ((mod4Mask, xK_f), runOrRaiseNext "firefox"                          $ query "navigatorFirefox")
   , ((mod4Mask, xK_s), runOrRaise     "ZendStudio"                       $ query "ideEclipse"      )
   , ((mod4Mask, xK_w), runOrRaiseNext "/home/alab/bin/phpstorm"          $ query "idePhpStorm"     )
   , ((mod4Mask, xK_o), runOrRaiseNext "okular"                           $ query "okular"          )
   , ((mod4Mask, xK_c), raiseNext                                         $ query "chatGajim"       )
   , ((mod4Mask, xK_d), raiseNext                                         $ query "debuggerFirebug" )
   ]
 where
   myManageHook = composeAll . concat $
     [ [ q --> doF (shiftViewOnScreen c) | (c, q) <- apps ]
     , [ q --> doFloat | (c, q) <- floats ]
     ] 

   desks = [ (0, "1", ["mailThunderbird", "navigatorFirefox", "idePhpStorm", "ideEclipse", "okular"])
           , (1, "2", ["debuggerFirebug"])
           , (0, "3", ["mainConsole"])
           , (0, "4", ["chatGajim", "rosterGajim", "chatEmpathy", "rosterEmpathy", "chatPsi", "rosterPsi"])
           ]

   apps = [ ("mainConsole"      , (appName =? "urxvt"                                                  <&&> title =? "mainConsole"))
	  , ("navigatorChromium", (appName =? "chromium"               <&&> className =? "Chromium"                               )) 
	  , ("navigatorFirefox" , (appName =? "Navigator"              <&&> className =? "Firefox"                                )) 
	  , ("debuggerFirebug"  , (appName =? "Firebug"                <&&> className =? "Firefox"                                ))
	  , ("mailThunderbird"  , (appName =? "Mail"                   <&&> className =? "Thunderbird"                            ))
	  , ("rosterGajim"      , (appName =? "gajim"                  <&&> className =? "Gajim"       <&&> stringProperty "WM_WINDOW_ROLE" =? "roster"))
	  , ("chatGajim"        , (appName =? "gajim"                  <&&> className =? "Gajim"       <&&> stringProperty "WM_WINDOW_ROLE" =? "messages"))
	  , ("rosterEmpathy"    , (appName =? "empathy"                <&&> className =? "Empathy"     <&&> stringProperty "WM_WINDOW_ROLE" =? "contact_list"))
	  , ("chatEmpathy"      , (appName =? "empathy-chat"           <&&> className =? "Empathy"     <&&> stringProperty "WM_WINDOW_ROLE" =? "chat"))
	  , ("chatPsi"          , (appName =? "tabs"                   <&&> className =? "psi"                                    ))
	  , ("rosterPsi"        , (appName =? "main"                   <&&> className =? "psi"         <&&> title =? "Psi+"       ))
	  , ("idePhpStorm"      , (appName =? "sun-awt-X11-XFramePeer"                                 <&&> title =~ "PhpStorm"   ))
	  , ("ideEclipse"       , (appName =? "Zend Studio"            <&&> className =? "Zend Studio"                            ))
	  , ("okular"           , (appName =? "okular"                 <&&> className =? "Okular"                                 ))
          ]

   floats = [ ("mplayer"        , (appName =? "xv"                     <&&> className =? "mplayer2"))
            , ("shrun"          , (appName =? "urxvt"                                                  <&&> title =? "shrun"      ))
            ]

   query a = head [ q | (c, q) <- apps, c == a ]
   screen a = S $ head [ s | (s, w, l) <- desks, a `elem` l ]
   workspace a = head [ w | (s, w, l) <- desks, a `elem` l ]

   (=~) haystack needle = fmap (isInfixOf needle) haystack

   shiftViewOnScreen c = viewOnScreen (screen c) (workspace c) . W.shift (workspace c)
   -- shiftViewOnScreen c = W.shift (workspace c)
