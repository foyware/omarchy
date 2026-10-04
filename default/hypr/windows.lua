-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

o.window(".*", { suppress_event = "maximize" })

-- Tag all windows for default opacity (apps can override with -default-opacity tag).
o.window(".*", { tag = "+default-opacity" })

-- Inhibit idle (screensaver/lock) for any window while it's fullscreen. Some
-- apps opt in individually below (geforce, moonlight, retroarch, steam's own
-- client window), but that only covers windows matching their specific
-- class -- it misses, for example, the separate window a Proton/native Linux
-- game opens, which never shares Steam's own window class. Without this, the
-- idle lock can engage mid-game, and a game holding a fullscreen Vulkan/DX
-- swapchain on a display that's mid-reconfiguration (e.g. during a lock
-- screen transition) can stall its present call long enough to trip the
-- game's own watchdog and crash. Applying this to every window makes the
-- per-app opt-ins below redundant but harmless.
o.window(".*", { idle_inhibit = "fullscreen" })

-- Fix some dragging issues with XWayland.
o.window(
  {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  { no_focus = true }
)

-- App-specific tweaks (may remove default-opacity tag).
require("default.hypr.apps")

-- Apply default opacity after apps have had a chance to opt out.
o.window({ tag = "default-opacity" }, { opacity = "0.985 0.96" })
