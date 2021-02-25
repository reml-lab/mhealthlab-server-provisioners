# Import required libs
import sys

sys.path.insert(0, '/nfs/obelix/users1/erisinger/projects/cc/CerebralCortex-Kernel')

from cerebralcortex import Kernel
from datetime import datetime
from cerebralcortex.core.datatypes import DataStream
from cerebralcortex.core.metadata_manager.stream.metadata import Metadata, DataDescriptor, ModuleMetadata
import pandas as pd

# CC settings

#config_filepath = "/Users/ali/IdeaProjects/CerebralCortex-2.0/conf/"
config_filepath = "/nfs/obelix/users1/erisinger/projects/cc/CerebralCortex-Kernel/conf/"
study_name = "default"

CC = Kernel(config_filepath, study_name=study_name, new_study=True)


# Create Metadata
metadata = Metadata().set_name("sample-stream_name").set_description("sample data.") \
	.add_dataDescriptor(
	DataDescriptor().set_name("timestamp").set_type("datetime").set_attribute("description", "sample timestamp")) \
	.add_dataDescriptor(
	DataDescriptor().set_name("user").set_type("int").set_attribute("description", "sample user")) \
	.add_dataDescriptor(
	DataDescriptor().set_name("version").set_type("int").set_attribute("description", "sample version")) \
	.add_dataDescriptor(
	DataDescriptor().set_name("col1").set_type("int").set_attribute("description", "sample col1")) \
	.add_dataDescriptor(
	DataDescriptor().set_name("col2").set_type("int").set_attribute("description", "sample col1")) \
	.add_dataDescriptor(
	DataDescriptor().set_name("col3").set_type("int").set_attribute("description", "sample col1")) \
	.add_module(
	ModuleMetadata().set_name("some.module.path").set_version("2.0.7").set_attribute("description", "this modules generates sample data.").set_author(
	    "test_user", "test_user@test_email.com"))

# Pandas demo DataFrame

lst = [datetime.now(),"234-322-12-23-2","1",4,5,6]
df = pd.DataFrame([lst])
df.columns =['timestamp','user', 'version','col1','col2','col3']

ds = DataStream(df, metadata)
CC.save_stream(ds)

ds2 = CC.get_stream("sample-stream_name")

ds2.show()
