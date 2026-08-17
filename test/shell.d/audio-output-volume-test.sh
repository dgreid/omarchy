#!/bin/bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

test_tmp=$(mktemp -d)
trap 'rm -rf "$test_tmp"' EXIT

mock_bin="$test_tmp/bin"
call_log="$test_tmp/calls"
mkdir -p "$mock_bin"

cat >"$mock_bin/omarchy-audio-output-sink" <<'SH'
#!/bin/bash
printf 'mock_sink\n'
SH

cat >"$mock_bin/pactl" <<'SH'
#!/bin/bash
printf 'pactl %s\n' "$*" >>"$CALL_LOG"

case "$*" in
  "get-sink-volume mock_sink")
    printf 'Volume: front-left: 32768 / %s%% / 0.00 dB\n' "${SINK_VOLUME:-50}"
    ;;
  "get-sink-mute mock_sink")
    printf 'Mute: %s\n' "${SINK_MUTE:-no}"
    ;;
esac
SH

cat >"$mock_bin/omarchy-osd" <<'SH'
#!/bin/bash
printf 'osd %s\n' "$*" >>"$CALL_LOG"
SH

chmod +x "$mock_bin"/*

run_volume() {
  : >"$call_log"
  CALL_LOG="$call_log" SINK_VOLUME="${SINK_VOLUME:-50}" SINK_MUTE="${SINK_MUTE:-no}" \
    PATH="$mock_bin:$ROOT/bin:$PATH" \
    "$ROOT/bin/omarchy-audio-output-volume" "$@"
}

run_volume mute
grep -Fxq "pactl set-sink-mute mock_sink 1" "$call_log" ||
  fail "mute asserts mute when currently unmuted"
pass "mute asserts mute when currently unmuted"

SINK_MUTE=yes run_volume mute
if grep -q "set-sink-mute" "$call_log"; then
  fail "mute is a no-op when already muted"
fi
pass "mute is a no-op when already muted"

SINK_MUTE=yes SINK_VOLUME=40 run_volume raise-or-unmute
grep -Fxq "pactl set-sink-mute mock_sink 0" "$call_log" ||
  fail "raise-or-unmute unmutes a non-zero muted sink"
if grep -q "set-sink-volume" "$call_log"; then
  fail "raise-or-unmute does not change level when unmuting a non-zero sink"
fi
pass "raise-or-unmute unmutes a non-zero muted sink without raising"

SINK_MUTE=yes SINK_VOLUME=0 run_volume raise-or-unmute
grep -Fxq "pactl set-sink-mute mock_sink 0" "$call_log" ||
  fail "raise-or-unmute unmutes a zero muted sink"
grep -Fxq "pactl set-sink-volume mock_sink 5%" "$call_log" ||
  fail "raise-or-unmute raises a zero muted sink"
pass "raise-or-unmute unmutes and raises a zero muted sink"

SINK_MUTE=no SINK_VOLUME=40 run_volume raise-or-unmute
grep -Fxq "pactl set-sink-volume mock_sink 45%" "$call_log" ||
  fail "raise-or-unmute raises when already unmuted"
pass "raise-or-unmute raises when already unmuted"
