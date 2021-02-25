source ~/.bashrc

#echo "starting SDCRS"
#screen -d -m -S sdcrs
#sleep 1s
##screen -S sdcrs -p 0 -X exec /vagrant/apps/SDCRS_jar/start_sdcrs.sh
#screen -S sdcrs -p 0 -X stuff "$MHL_ROOT/apps/SDCRS_jar/start_sdcrs.sh
#"
#echo "SDCRS running at $(hostname -I) : 9696"

echo "starting DCRS"
screen -d -m -S dcrs
sleep 1s
#screen -S dcrs -p 0 -X exec /vagrant/apps/DCRS_jar/start_dcrs.sh
screen -S dcrs -p 0 -X stuff "$MHL_ROOT/apps/DCRS_jar/start_dcrs.sh
"
echo "DCRS running at $(hostname -I) : 9595"

