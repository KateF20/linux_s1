#!/bin/bash

LOG=/home/katef20/linux_s1/logs/monitor.log

{
  echo "===== $(date '+%F %T') ====="

  echo "--- Память и swap ---"
  free -m

  echo "--- CPU ---"
  top -b -n 1 | head -3

  echo "--- Top 3 processes sorted by memory ---"
  ps aux --sort=-%mem | head -4

  echo "--- Critical errors last 5 min ---"
  journalctl -p err --since "5 minutes ago" --no-pager -q

  echo "--- Core: OOM-killer last 5 min ---"
  journalctl -k --since "5 minutes ago" --no-pager -q | grep -i "out of memory"

  echo
} >> "$LOG"
