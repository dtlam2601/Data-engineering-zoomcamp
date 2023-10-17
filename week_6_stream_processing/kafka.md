wget https://archive.apache.org/dist/kafka/3.5.1/kafka_2.13-3.5.1.tgz
tar -xzf kafka_2.13-3.5.1.tgz

### set env
nano .bashrc
export KAFKA_HOME="${HOME}/kafka/kafka_2.13-3.5.1"
export PATH="${KAFKA_HOME}/bin:${PATH}"
source .bashrc
logout

### Start ZooKeeper
cd $KAFKA_HOME
$KAFKA_HOME/bin/zookeeper-server-start.sh $KAFKA_HOME/config/zookeeper.properties
  
### Start the Kafka broker service
cd $KAFKA_HOME
$KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties
  
### Create a topic
cd $KAFKA_HOME
$KAFKA_HOME/bin/kafka-topics.sh --create --topic news --bootstrap-server localhost:9092
  
### Start Producer
cd $KAFKA_HOME
$KAFKA_HOME/bin/kafka-console-producer.sh --topic news --bootstrap-server localhost:9092

- Once the producer starts, and you get the '>' prompt, type any text message and press enter.
- Or you can copy the text below and paste. The below text sends three messages to kafka.
```
Good morning
Good day
Enjoy the Kafka lab
```
  
### Start Consumer
cd $KAFKA_HOME
$KAFKA_HOME/bin/kafka-console-consumer.sh --topic news --from-beginning --bootstrap-server localhost:9092
