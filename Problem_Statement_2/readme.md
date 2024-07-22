# System Health Monitoring and Application Health Checker

## Overview

This repository contains scripts for monitoring the health of a Linux system and an application. The `system_health_monitor.sh` script continuously monitors and logs system metrics like CPU usage, memory usage, disk space, and running processes. The `application_health_checker.sh` script is designed to monitor the health of a specific application, checking metrics like response time, error rates, and resource utilization.

## Scripts

### 1. System Health Monitor Script

**File:** `system_health_monitor.sh`

**Description:**
Monitors and logs the health of a Linux system. It checks CPU usage, memory usage, disk space, and running processes. The script updates metrics every 3 seconds and provides alerts if any metric exceeds predefined thresholds.

**Configuration:**
- `CPU_THRESHOLD`: CPU usage threshold (default: 80%)
- `MEMORY_THRESHOLD`: Memory usage threshold (default: 80%)
- `DISK_THRESHOLD`: Disk space usage threshold (default: 80%)
- `LOG_FILE`: Path to the log file (default: `./system_health.log`)
- `CHECK_INTERVAL`: Interval between checks (default: 3 seconds)

**Usage:**
1. Save the script as `system_health_monitor.sh`.
2. Make it executable:
   ```bash
   chmod +x system_health_monitor.sh
   ```
3. Run the script:
   ```bash
   ./system_health_monitor.sh
   ```
4. Alternatively, run in the background with `nohup`:
   ```bash
   nohup ./system_health_monitor.sh > /dev/null 2>&1 &
   ```

**Features:**
- Logs CPU, memory, and disk usage to both terminal and log file.
- Alerts if usage exceeds thresholds.
- Lists top CPU-consuming processes.

### 2. Application Health Checker Script

**File:** `application_health_checker.sh`

**Description:**
Monitors the health of a specific application. This script checks various metrics related to the application's performance, including response times, error rates, and resource utilization.

**Configuration:**
- `APP_URL`: URL of the application to monitor.
- `RESPONSE_TIME_THRESHOLD`: Maximum acceptable response time (in seconds).
- `ERROR_RATE_THRESHOLD`: Maximum acceptable error rate (percentage).
- `LOG_FILE`: Path to the log file for application health metrics.

**Usage:**
1. Save the script as `application_health_checker.sh`.
2. Make it executable:
   ```bash
   chmod +x application_health_checker.sh
   ```
3. Run the script:
   ```bash
   ./application_health_checker.sh
   ```

**Features:**
- Checks response time and logs results.
- Monitors error rates and logs alerts if the rate exceeds thresholds.
- Records resource usage and performance metrics.

## Notes

- Make sure the required commands and tools (`top`, `free`, `df`, `ps`, `curl`, etc.) are installed on your system.
- Adjust thresholds and log file paths as needed to fit your requirements.
- For continuous monitoring, consider setting up these scripts to run as background services or cron jobs.
