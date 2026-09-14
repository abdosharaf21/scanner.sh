#!/bin/bash

# =================================
# Mini Network Scanner
# =================================

echo "================================="
echo "Mini Network Scanner"
echo "================================="

# Service lookup table
declare -A SERVICES=(
    [21]="FTP"
    [22]="SSH"
    [23]="Telnet"
    [25]="SMTP"
    [53]="DNS"
    [80]="HTTP"
    [110]="POP3"
    [143]="IMAP"
    [443]="HTTPS"
    [3306]="MySQL"
    [5432]="PostgreSQL"
    [6379]="Redis"
    [8080]="HTTP-Proxy"
)

# Ask for target
read -p "Enter target host (127.0.0.1 / localhost / scanme.nmap.org): " TARGET

# =================================
# Reachability Check
# =================================

echo
echo "Checking if target is reachable..."

if ping -c 1 "$TARGET" > /dev/null 2>&1; then
    echo "Status: Reachable"
else
    echo "Target Unreachable."
    exit 1
fi

# =================================
# Ask for port range
# =================================

read -p "Enter port range (example: 1-100): " RANGE

START_PORT="${RANGE%-*}"
END_PORT="${RANGE#*-}"

# Validate range
if ! [[ "$START_PORT" =~ ^[0-9]+$ ]] || ! [[ "$END_PORT" =~ ^[0-9]+$ ]]; then
    echo "Invalid port range."
    exit 1
fi

if [ "$START_PORT" -lt 1 ] || [ "$END_PORT" -gt 65535 ] || [ "$START_PORT" -gt "$END_PORT" ]; then
    echo "Invalid port range. Use values between 1 and 65535."
    exit 1
fi

# =================================
# Reports folder
# =================================

mkdir -p Reports

# Replace characters that are unsafe in filenames
SAFE_TARGET="${TARGET//\//_}"
REPORT_FILE="Reports/scan_${SAFE_TARGET}.txt"

# Temporary directory for parallel jobs
TEMP_DIR=$(mktemp -d)

# =================================
# Start timer
# =================================

START_TIME=$(date +%s.%N)

# =================================
# Header
# =================================

{
    echo
    echo "================================="
    echo "Mini Network Scanner"
    echo "================================="
    echo
    echo "Target: $TARGET"
    echo "Status: Reachable"
    echo "Port Range: $START_PORT-$END_PORT"
    echo
    printf "%-8s %-8s %-15s\n" "PORT" "STATE" "SERVICE"
    echo "---------------------------------"
} | tee "$REPORT_FILE"

# =================================
# Parallel Port Scanning
# =================================

for ((PORT=START_PORT; PORT<=END_PORT; PORT++)); do

    (
        if timeout 1 bash -c "echo > /dev/tcp/$TARGET/$PORT" 2>/dev/null; then

            if [[ -v SERVICES[$PORT] ]]; then
                SERVICE="${SERVICES[$PORT]}"
            else
                SERVICE="Unknown"
            fi

            echo "$PORT OPEN $SERVICE" > "$TEMP_DIR/$PORT"

        else

            if [[ -v SERVICES[$PORT] ]]; then
                SERVICE="${SERVICES[$PORT]}"
            else
                SERVICE="Unknown"
            fi

            echo "$PORT CLOSED $SERVICE" > "$TEMP_DIR/$PORT"

        fi
    ) &

done

# Wait for all background scans
wait

# =================================
# Merge results
# =================================

for ((PORT=START_PORT; PORT<=END_PORT; PORT++)); do

    if [ -f "$TEMP_DIR/$PORT" ]; then

        read -r PORT_NUMBER STATE SERVICE < "$TEMP_DIR/$PORT"

        printf "%-8s %-8s %-15s\n" \
            "$PORT_NUMBER" "$STATE" "$SERVICE" | tee -a "$REPORT_FILE"

    fi

done

# =================================
# End timer
# =================================

END_TIME=$(date +%s.%N)

DURATION=$(awk "BEGIN {printf \"%.2f\", $END_TIME - $START_TIME}")

echo | tee -a "$REPORT_FILE"
echo "Scan completed in $DURATION seconds" | tee -a "$REPORT_FILE"
echo "=================================" | tee -a "$REPORT_FILE"
echo "End" | tee -a "$REPORT_FILE"

# Cleanup
rm -rf "$TEMP_DIR"
