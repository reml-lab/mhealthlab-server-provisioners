import sys
sys.path.insert(0, '/nfs/obelix/users1/erisinger/projects/cc/mhl-retriever/')
import mhl_retriever as mhl

import pandas as pd
from datetime import datetime

res = mhl.get("test_id", "sensor-accelerometer", size=10)

print(res['hits']['hits'][0])

# extract data from results
#vals = [r['_source'] for r in res['hits']['hits']]

# extract values from data
#x_vals = [v['x'] for v in vals]
#y_vals = [v['y'] for v in vals]
#z_vals = [v['z'] for v in vals]
#timestamps = [datetime.fromtimestamp(v['timestamp'] / 1000.0) for v in vals]
#user_ids = [v['badge-id'] for v in vals]
#version_vals = ["1" for u in user_ids]

# build dataframe
#df = pd.DataFrame({"timestamp": timestamps, "user": user_ids, "version": version_vals, "x": x_vals, "y": y_vals, "z": z_vals})
#columns = ["timestamp", "user", "version", "x", "y", "z"]
#df.columns = columns

#print(x_vals[:20], timestamps[:20], user_ids[:20])

df = mhl.df_from_results(res)

print(df.head())

