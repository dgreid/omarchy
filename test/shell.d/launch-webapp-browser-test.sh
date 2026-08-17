#!/bin/bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

test_tmp=$(mktemp -d)
trap 'rm -rf "$test_tmp"' EXIT

mock_bin="$test_tmp/bin"
home="$test_tmp/home"
call_log="$test_tmp/calls"
mkdir -p "$mock_bin" "$home/.local/share/applications"

cat >"$home/.local/share/applications/google-chrome.desktop" <<'EOF'
[Desktop Entry]
Exec=/usr/bin/google-chrome-stable
EOF

cat >"$home/.local/share/applications/brave-browser.desktop" <<'EOF'
[Desktop Entry]
Exec=/usr/bin/brave
EOF

cat >"$home/.local/share/applications/chromium.desktop" <<'EOF'
[Desktop Entry]
Exec=/usr/bin/chromium
EOF

cat >"$mock_bin/xdg-settings" <<'SH'
#!/bin/bash
printf 'chromium.desktop\n'
SH

cat >"$mock_bin/setsid" <<'SH'
#!/bin/bash
printf 'setsid %s\n' "$*" >>"$CALL_LOG"
SH

cat >"$mock_bin/uwsm-app" <<'SH'
#!/bin/bash
printf 'uwsm-app %s\n' "$*" >>"$CALL_LOG"
SH

chmod +x "$mock_bin"/*

run_webapp() {
  : >"$call_log"
  CALL_LOG="$call_log" HOME="$home" PATH="$mock_bin:$ROOT/bin:$PATH" \
    "$ROOT/bin/omarchy-launch-webapp" "$@"
}

run_webapp --browser chrome https://youtube.com/
grep -Fq "/usr/bin/google-chrome-stable --app=https://youtube.com/" "$call_log" ||
  fail "chrome browser override launches google-chrome" "$(cat "$call_log")"
pass "chrome browser override launches google-chrome"

run_webapp --browser brave https://x.com/
grep -Fq "/usr/bin/brave --app=https://x.com/" "$call_log" ||
  fail "brave browser override launches brave" "$(cat "$call_log")"
pass "brave browser override launches brave"

run_webapp https://omarchy.org/
grep -Fq "/usr/bin/chromium --app=https://omarchy.org/" "$call_log" ||
  fail "default launch uses the default supported browser" "$(cat "$call_log")"
pass "default launch uses the default supported browser"
