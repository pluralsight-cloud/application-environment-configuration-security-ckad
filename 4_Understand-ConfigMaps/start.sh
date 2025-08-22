#!/bin/sh
echo "=== Startup Script Running ==="
echo "App: ${APP_NAME}"
echo "Mode: ${APP_MODE}"
echo "Env snapshot:"
env | sort
echo "=== Ready ==="
tail -f /dev/null
