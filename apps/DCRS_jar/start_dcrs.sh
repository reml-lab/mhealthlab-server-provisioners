until java -jar $MHL_ROOT/apps/DCRS_jar/DCRS.jar -port 9595 -kafka localhost:9092,localhost:9093,localhost:9094; do
        echo "DCRS crashed with exit code $?.  respawning..." >&2
        sleep 2
done
