#!/bin/bash

# Configuration
ROUTES_FILE="routes.txt"
LOG_FILE="/tmp/normal_traffic.log"
MIN_SLEEP=5
MAX_SLEEP=10

# Function to log activities
log_activity() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Function to get random sleep duration
get_random_sleep() {
    # shellcheck disable=SC2004
    echo $(($RANDOM % ($MAX_SLEEP - $MIN_SLEEP + 1) + $MIN_SLEEP))
}

# Function to get random URL based on type needed
get_random_url() {
    local action_type=$1

    case "$action_type" in
        "download")
            # Select only downloadable file types
            grep -E '\.(jpg|css|js|eot|svg|ttf|woff|woff2)$' "$ROUTES_FILE" | shuf -n 1 | tr -d '[:space:]'
            ;;
        "load_test")
            # Select only HTML files
            grep -E '\.html$' "$ROUTES_FILE" | shuf -n 1 | tr -d '[:space:]'
            ;;
        "wrk_test")
            # Select only index.html files
            grep 'index\.html$' "$ROUTES_FILE" | shuf -n 1 | tr -d '[:space:]'
            ;;
        *)
            # For browsing and API calls, any URL is fine
            shuf -n 1 "$ROUTES_FILE" | tr -d '[:space:]'
            ;;
    esac
}

# Function to get random number within range
get_random_number() {
    local min=$1
    local max=$2
    # shellcheck disable=SC2004
    echo $(($RANDOM % ($max - $min + 1) + $min))
}

# Function to simulate basic web browsing
simulate_browsing() {
    # shellcheck disable=SC2155
    local url=$(get_random_url "browse")
    if [[ -n "$url" ]]; then
        log_activity "Browsing: $url"
        curl -s -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" "$url" > /dev/null 2>&1
    fi
}

# Function to simulate file downloads
simulate_download() {
    # shellcheck disable=SC2155
    local url=$(get_random_url "download")
    if [[ -n "$url" ]]; then
        log_activity "Downloading: $url"
        wget -q "$url" -O /dev/null 2>&1
    fi
}

# Function to simulate load testing
simulate_load_test() {
    # shellcheck disable=SC2155
    local url=$(get_random_url "load_test")
    if [[ -n "$url" ]]; then
        # shellcheck disable=SC2155
        local concurrent=$(get_random_number 1 5)
        # shellcheck disable=SC2155
        local requests=$(get_random_number 10 30)
        log_activity "Load testing: $url (concurrent: $concurrent, requests: $requests)"
        ab -n "$requests" -c "$concurrent" -q "$url" > /dev/null 2>&1
    fi
}

# Function to simulate API calls
simulate_api_call() {
    # shellcheck disable=SC2155
    local url=$(get_random_url "api")
    if [[ -n "$url" ]]; then
        log_activity "API call: $url"
        curl -s -H "Accept: application/json" -H "Content-Type: application/json" "$url" > /dev/null 2>&1
    fi
}

# Function to simulate intensive browsing with wrk
simulate_wrk_test() {
    # shellcheck disable=SC2155
    local url=$(get_random_url "wrk_test")
    if [[ -n "$url" ]]; then
        # shellcheck disable=SC2155
        local duration=$(get_random_number 5 15)
        log_activity "WRK test: $url (duration: ${duration}s)"
        wrk -t1 -c10 -d"${duration}"s --timeout 10s "$url" > /dev/null 2>&1
    fi
}

# Check if routes file exists
if [[ ! -f "$ROUTES_FILE" ]]; then
    echo "Error: Routes file '$ROUTES_FILE' not found!"
    exit 1
fi

# Create log file if it doesn't exist
touch "$LOG_FILE"

# Main loop
while true; do
    # Randomize which action to take
    action=$((RANDOM % 5))

    case $action in
        0)
            simulate_browsing
            ;;
        1)
            simulate_download
            ;;
        2)
            simulate_load_test
            ;;
        3)
            simulate_api_call
            ;;
        4)
            simulate_wrk_test
            ;;
    esac

    # Random sleep between actions
    sleep_duration=$(get_random_sleep)
    log_activity "Sleeping for ${sleep_duration} seconds"
    sleep "$sleep_duration"
done
