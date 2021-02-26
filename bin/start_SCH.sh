source ~/.bashrc

echo "starting SCH"
screen -d -m -S sch
sleep 1s
screen -S sch -p 0 -X stuff "bash $MHL_ROOT/apps/schtap/run.sh
"
echo "SCH running."

