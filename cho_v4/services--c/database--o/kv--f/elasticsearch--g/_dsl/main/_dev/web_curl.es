curl --noproxy localhost -XPUT http://localhost:9200/mail-delivery -d '{"mappings":{"events":{"_timestamp":{"enabled": true, "path" : "@timestamp", "store" : true}}}}'
curl --noproxy localhost -XPUT http://localhost:9200/mail-score -d '{"mappings":{"events":{"_timestamp":{"enabled": true, "path" : "@timestamp", "type": "integer"}}}}'
curl --noproxy localhost -XPUT http://localhost:9200/mail-misc -d '{"mappings":{"events":{"_timestamp":{"enabled": true, "path" : "@timestamp", "type": "integer"}}}}'

curl --noproxy localhost -XPUT http://localhost:9200/web-haproxy -d '{"mappings":{"events":{"_timestamp":{"enabled": true, "path" : "@timestamp", "type": "integer"}}}}'
curl --noproxy localhost -XPUT http://localhost:9200/web-nginx -d '{"mappings":{"events":{"_timestamp":{"enabled": true, "path" : "@timestamp", "type": "integer"}}}}'
curl --noproxy localhost -XPUT http://localhost:9200/web-apache -d '{"mappings":{"events":{"_timestamp":{"enabled": true, "path" : "@timestamp", "type": "integer"}}}}'

curl --noproxy localhost -XPUT http://localhost:9200/net-firewall -d '{"mappings":{"events":{"_timestamp":{"enabled": true, "path" : "@timestamp", "type": "integer"}}}}'


curl -XPUT "http://localhost:9200/web/events/_mappings" -d'
{
   "events": {
      "properties": {
         "hostname": { 
            "type": "multi_field",
            "fields": {
                "hostname": {"type": "string"},
                "original": {"type" : "string", "index" : "not_analyzed", "store" : true}
            }         
         },
         "syslogtag": { "type": "string", "index": "not_analyzed" },  
         "programname": { "type": "string", "index": "not_analyzed" },         
         "cone_be_time": {
            "type": "multi_field",
            "fields": {
                "cone_be_time": {"type": "integer"},
                "original": {"type" : "integer", "store" : true}
            }            
         },
         "cone_orx_time": { "type": "integer" },
         "request_uri": { "type": "string", "index": "not_analyzed" }         
      }
   }
}' 

curl --noproxy localhost -XDELETE 'http://localhost:9200/_all'
curl --noproxy localhost -XGET 'http://localhost:9200/_cat/indices?v'

curl --noproxy localhost -v 'http://localhost:9200/mail-delivery-2014.07.04/_search?pretty=1&fields=_source,_timestamp&size=10' -d '{"sort":{"_timestamp": "desc"}}'
curl --noproxy localhost -v 'http://localhost:9200/mail-delivery-2014.07.04/_search?pretty=1&fields=_source,_timestamp&size=10' -d '{"range":{"timestamp":{"gt":"now-1h"} }}'



##TEST#


 curl --noproxy localhost -XPOST 'http://localhost:9200/test3-2014.07.18/test1' -d '{
  "Name": "Serginio333322",
  "Date": "2014-07-07",
  "Age": "320",
  "@timestamp":1405696022000
}'  
  