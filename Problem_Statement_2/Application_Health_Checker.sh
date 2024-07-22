#!/bin/bash

# Configuration
APP_URL="http://www.google.com"    # URL of the application to monitor
STATUS_OK_CODE=200                 # HTTP status code indicating that the application is functioning correctly
LOG_FILE="./application_uptime.log"
CHECK_INTERVAL=10                  # Interval in seconds between checks

# Function to check application status
check_status() {
    local status_code=$(curl -o /dev/null -s -w "%{http_code}" $APP_URL)
    local message="HTTP status code: $status_code"
    
    echo "$(date): $message" | tee -a $LOG_FILE
    
    if [ "$status_code" -eq "$STATUS_OK_CODE" ]; then
        echo "$(date): APPLICATION STATUS: UP" | tee -a $LOG_FILE
    else
        echo "$(date): ALERT - APPLICATION STATUS: DOWN" | tee -a $LOG_FILE
    fi
}

# Create log file if it doesn't exist
touch $LOG_FILE

# Main loop
while true; do
    check_status
    echo "$(date): ----------------------------------------" | tee -a $LOG_FILE
    sleep $CHECK_INTERVAL
done
