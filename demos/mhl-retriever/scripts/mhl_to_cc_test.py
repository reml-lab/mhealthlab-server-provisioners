# Import required libs
import sys

#sys.path.insert(0, '/nfs/obelix/users1/erisinger/projects/cc/CerebralCortex-Kernel')
sys.path.insert(0, '/srv/data1/mhealthlab/cc2/CerebralCortex-Kernel')

from cerebralcortex import Kernel
from datetime import datetime
from cerebralcortex.core.datatypes import DataStream
from cerebralcortex.core.metadata_manager.stream.metadata import Metadata, DataDescriptor, ModuleMetadata
import pandas as pd

sys.path.insert(0, '/srv/data1/mhealthlab/cc2/mhl-retriever/')
import mhl_retriever as mhl

from datetime import datetime

res = mhl.get("test_id", "sensor-accelerometer", size=10)

df = mhl.df_from_results(res)

# CC settings

#config_filepath = "/Users/ali/IdeaProjects/CerebralCortex-2.0/conf/"
config_filepath = "/srv/data1/mhealthlab/cc2/CerebralCortex-Kernel/conf/"
study_name = "default"

CC = Kernel(config_filepath, study_name=study_name, new_study=True)

# stream, user ID

# Create Metadata
metadata = Metadata().set_name("sensor-accelerometer-test2").set_description("Accelerometer readings from the MotionSense HRV.") \
	.add_dataDescriptor(
	DataDescriptor().set_name("timestamp").set_type("datetime").set_attribute("description", "Timestamp")) \
	.add_dataDescriptor(
        DataDescriptor().set_name("localtime").set_type("datetime").set_attribute("description", "Timestamp")) \
	.add_dataDescriptor(
	DataDescriptor().set_name("user").set_type("str").set_attribute("description", "mHealthLab badge ID")) \
	.add_dataDescriptor(
	DataDescriptor().set_name("version").set_type("str").set_attribute("description", "Stream version")) \
	.add_dataDescriptor(
	DataDescriptor().set_name("x").set_type("float").set_attribute("description", "Accelerometer x")) \
	.add_dataDescriptor(
	DataDescriptor().set_name("y").set_type("float").set_attribute("description", "Accelerometer y")) \
	.add_dataDescriptor(
	DataDescriptor().set_name("z").set_type("float").set_attribute("description", "Accelerometer z")) \
	.add_module(
	ModuleMetadata().set_name("CerebralCortex.mHealthLab.integration").set_version("0.1.0").set_attribute("description", "This module demonstrates the integration of mHealthLab and CerebralCortex.").set_author(
	    "Erik Risinger", "erisinger@umass.edu"))

# Pandas demo DataFrame

#lst = [datetime.now(),"234-322-12-23-2","1",4,5,6]


#df = pd.DataFrame([lst])
#df.columns =['timestamp','user', 'version','x','y','z']

ds = DataStream(df, metadata)
CC.save_stream(ds)

ds2 = CC.get_stream("sensor-accelerometer-test2")

ds2.show()
