until java -jar $MHL_ROOT/apps/SDCRS_jar/SDCRS.jar -Djavax.net.ssl.keyStore=testserverkeys -Djavax.net.ssl.keyStorePassword=testpass -port 9696 -kafka localhost:9092,localhost:9093,localhost:9094; do
        echo "Secure DCRS crashed with exit code $?.  respawning..." >&2
        sleep 2
done
