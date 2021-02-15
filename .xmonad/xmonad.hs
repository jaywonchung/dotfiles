------------------------------------------------------------------------
-- Jae-Won's Xmonad config file
------------------------------------------------------------------------

import XMonad
import System.Exit
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Util.NamedScratchpad
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Layout.NoBorders

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

------------------------------------------------------------------------
-- Key bindings
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm,               xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "dmenu_run")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm .|. shiftMask, xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    -- Miscellaneous custom bindings
    -- Audio control with HHKB
    [ ((0, 0x1008FF13), spawn "amixer -q sset Master 5%+")
    , ((0, 0x1008FF11), spawn "amixer -q sset Master 5%-")

    -- Scratchpads
    , ((modm .|. controlMask, xK_Return), namedScratchpadAction scratchpads "kitty")
    , ((modm .|. controlMask, xK_h     ), namedScratchpadAction scratchpads "kitty_l")
    , ((modm .|. controlMask, xK_l     ), namedScratchpadAction scratchpads "kitty_r")
    , ((modm .|. controlMask, xK_v     ), namedScratchpadAction scratchpads "pavucontrol")

    -- Taking screenshots
    , ((modm .|. controlMask, xK_3), spawnOnce "import -window root Screenshots/`date +'%Y-%m-%dT%H:%M:%S%Z'`.png")
    , ((modm .|. controlMask, xK_4), spawnOnce "import Screenshots/`date +'%Y-%m-%dT%H:%M:%S%Z'`.png")

    -- Application shortcuts
    , ((modm .|. shiftMask,  xK_w      ), spawn "naver-whale-stable")
    ]


------------------------------------------------------------------------
-- Mouse bindings
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

-----------------------------------------------------------------------
-- Clickable workspaces
--
myWorkspaces = clickable $ ["1","2","3","4","5","6","7","8","9"]
  where
    clickable l = [ "<action=xdotool key super+" ++ show (n) ++ ">" ++ ws ++ "</action>" |
                        (i,ws) <- zip [1..9] l,
                       let n = i ]

-----------------------------------------------------------------------
-- Scratchpad definitions
--
scratchpads = 
    [ NS "kitty" "WELCOME=no kitty --class=scratchpad" (className =? "scratchpad")
          (customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3))
    , NS "kitty_r" "WELCOME=no kitty --class=scratchpad_r" (className =? "scratchpad_r")
          (customFloating $ W.RationalRect (2/3) (0) (1/3) (1/2))
    , NS "kitty_l" "WELCOME=no kitty --class=scratchpad_l" (className =? "scratchpad_l")
          (customFloating $ W.RationalRect (0) (0) (1/3) (1/2))
    , NS "pavucontrol" "pavucontrol" (className =? "Pavucontrol")
          (customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3))
    ] 

-----------------------------------------------------------------------
-- Main configuration
--
main = do
  xmproc <- spawnPipe "xmobar -x 0 ~/.config/xmobar/xmobarrc"
  xmonad $ docks def
      -- The preferred terminal.
      { terminal           = "kitty"

      -- Whether focus follows the mouse pointer.
      , focusFollowsMouse  = True

      -- Whether clicking on a window to focus also passes the click to the window
      , clickJustFocuses   = False

      -- Width of the window border in pixels.
      , borderWidth        = 2

      -- Border colors for unfocused and focused windows, respectively.
      , normalBorderColor  = "#dddddd"
      , focusedBorderColor = "#ff0000"

      -- Modkey to use.
      --   e.g. Left alt (mod1Mask), right alt (mod3Mask), super (mod4Mask)
      , modMask            = mod4Mask

      -- Workspaces.
      , workspaces         = myWorkspaces

      -- Key and mouse bindings.
      , keys               = myKeys
      , mouseBindings      = myMouseBindings

      -- Various hooks.
        -- When an internal state changes or an X event occurs.
        -- Send workspace info and window name to xmobar.
      , logHook = dynamicLogWithPP xmobarPP
            { ppOutput = hPutStrLn xmproc
            , ppTitle = xmobarColor "grey" "" . shorten 50
            , ppCurrent = xmobarColor "#1793d1" ""
            , ppHiddenNoWindows = xmobarColor "#535353" ""
            , ppHidden = xmobarColor "#ffffff" ""
            , ppOrder = \(ws:l:t:_) -> [ws,l,t]
            , ppSep = " | "
            }

        -- Custom handler functions for X events.
        -- Fullscreen mode fix for Chromium (especially for YouTube).
      , handleEventHook = fullscreenEventHook

        -- When a new window is created.
        -- The xprop tool can be helpful.
      , manageHook = composeAll
            [ className =? "MPlayer"        --> doFloat
            , className =? "Gimp"           --> doFloat
            , className =? "Kazam"          --> doFloat
            , title =? "Picture in picture" --> doFloat     -- Naver Whale PiP
            , title =? "Chat"               --> doFloat     -- Zoom Chat
            , resource  =? "desktop_window" --> doIgnore
            , resource  =? "kdesktop"       --> doIgnore
            , namedScratchpadManageHook scratchpads
            ]

      , layoutHook = smartBorders $ avoidStruts (Tall (1) (1/2) (3/100) ||| Full)

        -- When Xmonad starts or restarts with mod-q.
        -- spawnOnce: only on fresh start, spawn: always.
      , startupHook = do
            spawn     "~/.dotmodules/bin/nitrogen-refresh"
            spawnOnce "stalonetray &"
            spawnOnce "picom &"
            spawnOnce "dex -a -s ~/.config/autostart"
    }
