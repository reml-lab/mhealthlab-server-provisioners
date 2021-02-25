from elasticsearch import Elasticsearch

# by default we don't sniff, ever
es = Elasticsearch()

query_body = {
  "query": {
      "match": {
          "badge-id": "test_id"
      }
  }
}

result = es.search(index="sensor-accelerometer", body=query_body)

print(result)
