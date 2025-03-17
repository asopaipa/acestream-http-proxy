#!/bin/bash
set -e

if [[ $ALLOW_REMOTE_ACCESS == "yes" ]]; then
    EXTRA_FLAGS="$EXTRA_FLAGS --bind-all --allow-remote=1 --allow-remote-access=1"
fi

COMMAND_ARGS="--client-console --live-cache-type memory --live-mem-cache-size 104857600 --disable-sentry --log-stdout --client-console --http-port ${HTTP_PORT} ${EXTRA_FLAGS}"

echo "Running arm image"

export ACESTREAM_HOME="/acestream"
export ANDROID_ROOT="/system"
export ANDROID_DATA="/data"
export PYTHONHOME="/acestream/python"
export PYTHONPATH="/acestream/python/lib/stdlib:/acestream/python/lib/modules:/acestream/data:/acestream/modules.zip:/acestream/eggs-unpacked:/acestream/lib"
export LD_LIBRARY_PATH="/system/lib64:/system/lib:/acestream/python/lib"
export TEMP="/tmp"
export PATH="/acestream/python/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Check if the directory exists before changing to it
if [ -d "/acestream" ]; then
    cd /acestream
    
    # Check if Python exists at the expected path
    if [ -f "/acestream/python/bin/python" ]; then
        chmod +x /acestream/python/bin/python
        echo "ls -ld /acestream/python/bin: "

        #ls -ld /acestream/python/bin

        echo "file /acestream/python/bin/python: "
        #file /acestream/python/bin/python

        echo "mount | grep noexec: "
        #mount | grep noexec

        echo "ldd /acestream/python/bin/python: "
        #ldd /acestream/python/bin/python


        exec /acestream/python/bin/python ./main.py $COMMAND_ARGS
    else
        echo "Error: Python executable not found at /acestream/python/bin/python"
        exit 1
    fi
else
    echo "Error: /acestream directory does not exist"
    # List root directories for debugging
    ls -la /
    exit 1
fi
