if [[ $ALLOW_REMOTE_ACCESS == "yes" ]];then
    EXTRA_FLAGS="$EXTRA_FLAGS --bind-all"
fi

echo "Running amd image"

/opt/acestream/start-engine --client-console --http-port $HTTP_PORT $EXTRA_FLAGS

