from elasticsearch import Elasticsearch
from datetime import datetime
import pandas as pd

def get(user_id, index, size=1000, generate=False):
	
	es = Elasticsearch()
	
	query_body = {
	  "query": {
	      "match": {
	          "badge-id": user_id
	      }
	  }
	}
	
	result = es.search(index=index, body=query_body, size=size)
	
	return result


def df_from_results(res):
	# extract data from results
	vals = [r['_source'] for r in res['hits']['hits']]
	
	# extract values from data
	x_vals = [v['x'] for v in vals]
	y_vals = [v['y'] for v in vals]
	z_vals = [v['z'] for v in vals]
	timestamps = [datetime.fromtimestamp(v['timestamp'] / 1000.0) for v in vals]
	user_ids = [v['badge-id'] for v in vals]
	version_vals = ["1" for u in user_ids]
	
	# build dataframe
	df = pd.DataFrame({"timestamp": timestamps, "localtime": timestamps, "user": user_ids, "version": version_vals, "x": x_vals, "y": y_vals, "z": z_vals})	

	return df

