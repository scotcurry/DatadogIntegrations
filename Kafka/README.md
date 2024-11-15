# Overview

Steps to get a Kafka lab environment up and running.  Should also have a producer and consumer application for testing.  This lab was built on Ubuntu Server 22.04.3 LTS

## Zookeeper Setup
**Note** There is a section in the Kafka setup about adding the commands to the zookeeper.properties file.  Don't do that in this section.

Requirements
- openjdk (sudo apt install openjdk-11-jre-headless)
- zookeeper (sudo apt-get install zookeeperd)
    - validate zookeeper is running
        - telnet localhost 2181
        - type ruok, this should return imok and terminate the connection

## Kafka Setup

- create a service user for Kafka
    - sudo adduser kafka
- add the kafka user to the sudo group
    - sudo adduser kafka sudo
- login with the kafka user
    - su -l kafka

- create a downloads directory (Downloads) and get download kafka to it
    - wget https://downloads.apache.org/kafka/3.5.1/kafka_2.13-3.5.1.tgz (latest version https://kafka.apache.org/downloads)
- validate download
    - shasum -a 512 kafka_2.13-3.5.1.tgz (https://downloads.apache.org/kafka/3.5.1/kafka_2.13-3.5.1.tgz.sha512). Latest linked from downloads link.

- make a kafka directory and change to it (mkdir ~/kafka && cd ~/kafka)
- unzip the kafka binaries to the folder
   - tar -xvzf ~/Downloads/kafka_2.13-3.5.1.tgz --strip 1

- update the zookeeper configuration (~/kafka/config/zookeeper.properties)
    - vim zookeeper.properties insert (4lw.commands.whitelist=ruok, srvr, stat, mntr)

- update the server configuration file (~/kafka/config/server.properties) so you can delete topics
    - vim server.properties insert (delete.topic.enable = true)
    - vim server.properties (uncomment out listeners line)

## Configure the service startup files

### zookeeper.service (in /lib/systemd/service)
```
[Unit]
Requires=network.target remote-fs.target
After=network.target remote-fs.target

[Service]
Type=simple
User=kafka
ExecStart=/home/kafka/kafka/bin/zookeeper-server-start.sh /home/kafka/kafka/config/zookeeper.properties
ExecStop=/home/kafka/kafka/bin/zookeeper-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
```

### kafka.service (in /lib/systemd/service)
```
[Unit]
Requires=zookeeper.service
After=zookeeper.service

[Service]
Type=simple
User=kafka
Environment=JMX_PORT=9999
ExecStart=/bin/sh -c '/home/kafka/kafka/bin/kafka-server-start.sh /home/kafka/kafka/config/server.properties > /home/kafka/kafka/logs/kafka-start.log 2>&1'
ExecStop=/home/kafka/kafka/bin/kafka-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
```

### Make sure both services start every time the system boots
sudo systemctl enable zookeeper  
sudo systemctl enable kafka

## Test the Producer and Consumer
**Note** Make sure you are logged in with kafka user (su -l kafka)
### Create a Topic
```
~/kafka/bin/kafka-topics.sh --create --bootstrap-server localhost:9092  --topic CurrywareTopic
```
### Add an entry into the topic
```
echo "Hello, Scot" | ~/kafka/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic CurrywareTopic > /dev/null
```
### Retrive the entries
```
~/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic CurrywareTopic --from-beginning
```
**Note** If you get NO_LEADER_AVAILABLE you probably didn't uncomment out the listener port.

### Make sure connections can be made from non-localhost machines.
Edit the server.properties file and update the listner line to use the host name
```
listeners=PLAINTEXT://ubuntu-postgres.curryware.org:9092
```


## Troubleshooting - Kafka Setup
- **NOTE:** Look in the Kafka logs folder.  Ran into an issue where the server.log file in the logs folder said "Cluster ID doesn’t match stored clusterId in meta.properties."  That value is stored in the log folder defined in the kafka services file (**NOT LOGS**) folder.  Rather than replace the clusterID value in the meta.properties file just delete the line.  When the server restarted Kafka was working.
- Ran into an issue where I was trying to change the port in the service startup section and zookeeper stopped working.  Copied the code from above and zookeeper was working, but I got an error on the ruok statement and it says the command isn't on the whitelist.
- To get zookeeper working again I add the statement 4lw.commands.whitelist=* to the zookeeper.properties file.

## Troubleshooting Datadog Commands
**List All JMX Metrics**
sudo -u dd-agent -- datadog-agent jmx list everything
