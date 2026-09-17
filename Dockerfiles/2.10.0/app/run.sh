#!/bin/sh
# Two steps on purpose (build+save, then load+serve) instead of the one-step
# `--build --save --serve` the older images use: on 2.10.0-SNAPSHOT the
# one-step form served a broken router (every transit search failed with an
# ArrayIndexOutOfBoundsException, upstream #7948, still open), and with two
# steps the graph is always on disk before the server takes traffic — a
# crash-loop can never rebuild the graph on every restart.

file_name="otp-shaded.jar"
[ -z "${JAVA_MAX_MEMORY}" ] && JAVA_MAX_MEMORY='-Xmx2G'

if ! [ -f "./data/graph.obj" ]; then
    echo "Build Graph"
    java $JAVA_MAX_MEMORY -jar $file_name --build --save ./data || exit 1
fi

echo "Load Graph"
exec java $JAVA_MAX_MEMORY -jar $file_name --load --serve ./data
