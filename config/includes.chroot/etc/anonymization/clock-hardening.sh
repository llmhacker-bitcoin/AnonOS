#!/bin/sh
# AnonOS MVP - Clock and timezone hardening

# Force UTC timezone to avoid leaking local timezone information
ln -sf /usr/share/zoneinfo/UTC /etc/localtime

echo "UTC" > /etc/timezone

# Disable hardware clock local time (use UTC for RTC)
# This is applied via hwclock during boot