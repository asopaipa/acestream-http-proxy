if [[ $ALLOW_REMOTE_ACCESS == "yes" ]];then
    EXTRA_FLAGS="$EXTRA_FLAGS --bind-all --allow-remote=1 --allow-remote-access=1"
fi

COMMAND_ARGS="--client-console --live-cache-type memory --live-mem-cache-size 104857600 --disable-sentry --log-stdout --client-console --http-port ${HTTP_PORT} ${EXTRA_FLAGS}"

echo "Running arm image"

cd /acestream
exec /acestream/python/bin/python ./main.py $COMMAND_ARGS
