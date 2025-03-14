#!/bin/bash
set -e

if [[ $ALLOW_REMOTE_ACCESS == "yes" ]]; then
    EXTRA_FLAGS="$EXTRA_FLAGS --bind-all --allow-remote=1 --allow-remote-access=1"
fi

COMMAND_ARGS="--client-console --live-cache-type memory --live-mem-cache-size 104857600 --disable-sentry --log-stdout --client-console --http-port ${HTTP_PORT} ${EXTRA_FLAGS}"

echo "Running arm image"

# Check if the directory exists before changing to it
if [ -d "/acestream" ]; then
    cd /acestream
    
    # Check if Python exists at the expected path
    if [ -f "/acestream/python/bin/python" ]; then
        exec /acestream/python/bin/python ./main.py $COMMAND_ARGS
    else
        echo "Error: Python executable not found at /acestream/python/bin/python"
        # Try to locate Python
        find / -name python -type f 2>/dev/null
        exit 1
    fi
else
    echo "Error: /acestream directory does not exist"
    # List root directories for debugging
    ls -la /
    exit 1
fi
