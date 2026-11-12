#!/usr/bin/env python3

import os
import sys
import time

CHUNK_MB = int(sys.argv[1]) if len(sys.argv) > 1 else 50
SLEEP = float(sys.argv[2]) if len(sys.argv) > 2 else 5

leak = []
total = 0

print(f'PID {os.getpid()}: +{CHUNK_MB} MB every {SLEEP} seconds', flush=True)
while True:
    leak.append(b"x" * CHUNK_MB * 1024 * 1024)  # not only VSZ but also RSS
    total += CHUNK_MB
    print(f'{time.strftime('%H:%M:%S')} allocated {total} MB', flush=True)
    time.sleep(SLEEP)
