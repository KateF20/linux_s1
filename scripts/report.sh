#!/bin/bash

LOG=/home/katef20/linux_s1/logs/monitor.log
REPORT=/home/katef20/linux_s1/logs/report.txt

SINCE=$(grep -m1 "=====" "$LOG" | awk '{print $2, $3}')

{
  echo "DIAGNOSTIC REPORT — $(date '+%F %T')"
  echo "Period: since $SINCE"
  echo

  echo "=== 1. MEMORY (MB) ==="
  awk '/^=====/ {t=$3} /^Mem:/ {print t, "used:", $3, "available:", $7}' "$LOG"
  awk '/^Mem:/ {if ($3 > max) max = $3} END {print "Peak used:", max, "MB"}' "$LOG"
  awk '/^=====/ {t=$3} /^Mem:/ && $7 < 300 {print "CRITICAL", t, "- available only", $7, "MB"}' "$LOG"
  echo

  echo "=== 2. CPU ==="
  grep -E "^top -|^%Cpu" "$LOG"
  echo

  echo "=== 3. SWAP (MB) ==="
  awk '/^=====/ {t=$3} /^Swap:/ {print t, "used:", $3, "of", $2}' "$LOG"
  awk '/^Swap:/ {if ($3 > max) max = $3} END {print "Peak swap used:", max, "MB"}' "$LOG"
  echo

  echo "=== 4. CRITICAL EVENTS (err and above) ==="
  journalctl -p err --since "$SINCE" --no-pager -q
  echo

  echo "=== 5. KERNEL: OOM-KILLER ==="
  echo "OOM kills: $(journalctl -k --since "$SINCE" --no-pager -q | grep -c "Killed process")"
  journalctl -k --since "$SINCE" --no-pager -q | grep -E "invoked oom-killer|Killed process"
} > "$REPORT"

cat "$REPORT"
