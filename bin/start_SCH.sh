source ~/.bashrc

echo "starting SCH"
screen -d -m -S sch
sleep 1s
screen -S dcrs -p 0 -X stuff "$MHL_ROOT/apps/schtap/run.sh
"
echo "DCRS running at $(hostname -I) : 9595"

