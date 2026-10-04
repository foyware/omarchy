#!/bin/bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

run_node_test <<'JS'
const fs = require('fs')
const read = (file) => fs.readFileSync(path.join(root, file), 'utf8')
const windows = read('default/hypr/windows.lua')

// Per-app idle_inhibit rules (apps/steam.lua, apps/geforce.lua, ...) only
// cover windows matching their specific class. A Proton/native Linux game
// opens its own window with its own class, so it is not covered by the
// Steam client's rule and would otherwise get no idle protection while
// fullscreen -- letting the idle lock engage mid-game. This must hold for
// every window, not just the ones with their own opt-in.
assert(
  /o\.window\(\s*"\.\*"\s*,\s*\{\s*idle_inhibit\s*=\s*"fullscreen"\s*\}\s*\)/.test(windows),
  'every window is inhibited from idle while fullscreen, not just apps with their own opt-in rule'
)
JS
