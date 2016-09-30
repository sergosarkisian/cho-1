curl --noproxy localhost -XPUT  http://localhost:9200/.kibana -d '{"index.mapper.dynamic": true}'
curl --noproxy localhost -XPUT http://localhost:9200/_template/mail-delivery -d @/media/sysdata/rev5/techpool/ontology/logitoring/elasticsearch/templates/mail-delivery.json
curl --noproxy localhost -XPUT http://localhost:9200/_template/mail-score -d @/media/sysdata/rev5/techpool/ontology/logitoring/elasticsearch/templates/mail-score.json
curl --noproxy localhost -XPUT http://localhost:9200/_template/mail-delivery -d @/media/sysdata/rev5/techpool/ontology/logitoring/elasticsearch/templates/mail-delivery.json
curl --noproxy localhost -XPUT http://localhost:9200/_template/msg-all -d @/media/sysdata/rev5/techpool/ontology/logitoring/elasticsearch/templates/msg-all.json
curl --noproxy localhost -XPUT http://localhost:9200/_template/net-firewall -d @/media/sysdata/rev5/techpool/ontology/logitoring/elasticsearch/templates/net-firewall.json
curl --noproxy localhost -XPUT http://localhost:9200/_template/web-haproxy -d @/media/sysdata/rev5/techpool/ontology/logitoring/elasticsearch/templates/web-haproxy.json