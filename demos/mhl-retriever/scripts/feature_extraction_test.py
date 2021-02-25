import statistics as stats
import sys
sys.path.insert(0, '/nfs/obelix/users1/erisinger/projects/cc/CerebralCortex-Kernel')
from cerebralcortex import Kernel
from cerebralcortex.algorithms.stats.features import statistical_features

config_filepath = "/srv/data1/mhealthlab/cc2/CerebralCortex-Kernel/conf/"
study_name = "default"

CC = Kernel(config_filepath, study_name=study_name, new_study=False)

accel = CC.get_stream("sensor-accelerometer-test2")
accel.show(truncate=False)


#avg_acc = accel.compute(
#avg_acc.show()

windowed_acc = accel.window(windowDuration=1)
features = statistical_features(windowed_acc)
features.show(truncate=False)


#acc_features = statistical_features(windowed_acc)
#acc_features.show()






#window_min = accel.compute_min(windowDuration=60)
#window_min.show()





