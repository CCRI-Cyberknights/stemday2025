#!/bin/bash
# start_web_hub.sh - Launch the student CTF web hub

echo "🚀 Starting the CCRI CTF Student Hub..."
cd "$(dirname "$0")" || exit 1

# Check if Flask server is already running on port 5000
if lsof -i:5000 >/dev/null 2>&1; then
    echo "🌐 Web server already running on port 5000."
else
    echo "🌐 Starting web server on port 5000..."
    # Start Flask server in background
    nohup python3 server.pyc >/dev/null 2>&1 &
    sleep 1  # Give it a moment to start
fi

# Open browser to the hub (if not already open)
if pgrep -x "firefox" >/dev/null 2>&1; then
    echo "🦊 Firefox already running. Opening new tab..."
    firefox --new-tab http://localhost:5000 >/dev/null 2>&1 &
else
    echo "🦊 Launching Firefox to http://localhost:5000..."
    firefox http://localhost:5000 >/dev/null 2>&1 &
fi

echo "✅ CCRI CTF Student Hub is ready!"
