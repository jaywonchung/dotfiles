--
-- xmonad config file
--

import XMonad
import Data.Monoid
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
-- Key bindings.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm,               xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "dmenu_run")

    -- launch gmrun
    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

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
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
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

    --
    -- Audio control with HHKB
    --
    [ ((0, 0x1008FF13), spawn "amixer -q sset Master 5%+")
    , ((0, 0x1008FF11), spawn "amixer -q sset Master 5%-")
    ]

    ++

    --
    -- Scratchpad
    --
    [ ((modm .|. controlMask, xK_Return), namedScratchpadAction scratchpads "kitty")
    , ((modm .|. controlMask, xK_h     ), namedScratchpadAction scratchpads "kitty_l")
    , ((modm .|. controlMask, xK_l     ), namedScratchpadAction scratchpads "kitty_r")
    , ((modm .|. controlMask, xK_v     ), namedScratchpadAction scratchpads "pavucontrol")
    ]

    ++

    --
    -- Applications
    --
    [ ((modm .|. shiftMask,  xK_w      ), spawn "naver-whale-stable")
    ]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
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

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayoutHook = smartBorders $ avoidStruts (tiled ||| Full)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "Kazam"          --> doFloat
    , title =? "Picture in picture" --> doFloat     -- Naver Whale PiP
    , title =? "Chat"               --> doFloat     -- Zoom Chat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    , namedScratchpadManageHook scratchpads      ]

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

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
-- Fullscreen mode fix for Chromium (especially for YouTube)
myEventHook = fullscreenEventHook

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
-- myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
        spawnOnce "xsetroot -cursor_name left_ptr"
        spawnOnce "nitrogen-refresh"
        spawnOnce "stalonetray &"
        spawnOnce "dex -a -s ~/.config/autostart"
        spawnOnce "picom &"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
-- Run xmonad with the settings you specify. No need to modify this.
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

      -- Names of workspaces.
      --   e.g. workspaces = ["web", "irc", "code"] ++ map show [4..9]
      , workspaces         = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

      , keys               = myKeys
      , mouseBindings      = myMouseBindings

      , logHook            = dynamicLogWithPP xmobarPP
            { ppOutput = hPutStrLn xmproc
            , ppTitle = xmobarColor "grey" "" . shorten 50
            , ppCurrent = xmobarColor "#1793d1" ""
            , ppHiddenNoWindows = xmobarColor "#535353" ""
            , ppHidden = xmobarColor "#ffffff" ""
            , ppOrder = \(ws:l:t:_) -> [ws,l,t]
            , ppSep = " | "
            }
      , manageHook         = myManageHook
      , handleEventHook    = myEventHook
      , layoutHook         = myLayoutHook
      , startupHook        = myStartupHook
    }
