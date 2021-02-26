cd $MHL_ROOT/apps/schtap/
touch monitored_processes.txt
java -jar $MHL_ROOT/apps/schtap/SCHTap.jar localhost:9092,localhost:9093,localhost:9094 domino monitored_processes.txt '/nfs/obelix/users1/erisinger/projects/sch/stress-detection-active-learning-system/memphis_main.py --chunk_size 60' test 1

