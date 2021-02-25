source ~/.profile

echo "starting visualization server"
screen -d -m -S vs
sleep 1s
screen -S vs -p 0 -X stuff "${MHL_ROOT}/apps/VisualizationServer_jar/run.sh
"
echo "visualization server running"
