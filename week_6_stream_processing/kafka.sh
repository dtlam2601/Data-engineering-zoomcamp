# list all topic
bin/kafka-topics.sh --list --bootstrap-server localhost:9092


#Kafka CONNECT-----------------------------
# 2 stand-alone connectors (run in a single,local,dedicated process)
bin/connect-standalone.sh \ 
  config/connect-standalone.properties \
  config/connect-file-source.properties \
  config/connect-file-sink.properties
