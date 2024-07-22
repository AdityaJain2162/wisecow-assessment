#!/bin/bash

# Configuration
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80
LOG_FILE="./system_health.log"
CHECK_INTERVAL=3  # Interval in seconds between checks

# Function to check CPU usage
check_cpu() {
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    local message="CPU usage: $cpu_usage%"
    echo "$(date): $message" | tee -a $LOG_FILE
    if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then
        echo "$(date): ALERT - CPU usage is above threshold: $cpu_usage%" | tee -a $LOG_FILE
    fi
}

# Function to check memory usage
check_memory() {
    local memory_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    local message="Memory usage: $memory_usage%"
    echo "$(date): $message" | tee -a $LOG_FILE
    if (( $(echo "$memory_usage > $MEMORY_THRESHOLD" | bc -l) )); then
        echo "$(date): ALERT - Memory usage is above threshold: $memory_usage%" | tee -a $LOG_FILE
    fi
}

# Function to check disk space usage
check_disk() {
    local disk_usage=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
    local message="Disk space usage: $disk_usage%"
    echo "$(date): $message" | tee -a $LOG_FILE
    if (( disk_usage > DISK_THRESHOLD )); then
        echo "$(date): ALERT - Disk space usage is above threshold: $disk_usage%" | tee -a $LOG_FILE
    fi
}

# Function to check running processes
check_processes() {
    local high_cpu_processes=$(ps aux --sort=-%cpu | awk 'NR<=5 {print $1, $3, $11}' | grep -vE 'USER|^$')
    if [ -n "$high_cpu_processes" ]; then
        echo "$(date): Top CPU consuming processes:" | tee -a $LOG_FILE
        echo "$high_cpu_processes" | tee -a $LOG_FILE
    fi
}

# Create log file if it doesn't exist
touch $LOG_FILE

# Main loop
while true; do
    check_cpu
    check_memory
    check_disk
    check_processes
    echo "$(date): ----------------------------------------" | tee -a $LOG_FILE
    sleep $CHECK_INTERVAL
done
