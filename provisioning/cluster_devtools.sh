#/bin/bash -aux

echo "> cluster_devtools.sh"

# To avoid message dpkg-preconfigure: unable to re-open stdin: No such file or directory
export DEBIAN_FRONTEND=noninteractive

# Scala
echo "Install Scala"
curl -sSL \
http://www.scala-lang.org/files/archive/scala-2.11.8.tgz \
-o /tmp/scala-2.11.8.tgz && \
mkdir -p /opt/scala && \
tar xzvf /tmp/scala-2.11.8.tgz -C /opt/scala && \
rm -f /tmp/scala-2.11.8.tgz && \
cd /opt/scala && \
chown -R root:javadev /opt/scala && \
ln -s `ls -1` current && \
echo "export SCALA_HOME=/opt/scala/current" >> /home/malima/.bashrc && \
echo "export PATH=\$SCALA_HOME/bin:\$PATH" >> /home/malima/.bashrc

# SBT
echo "Install SBT"
curl -sSL \
https://dl.bintray.com/sbt/native-packages/sbt/0.13.12/sbt-0.13.12.tgz \
-o /tmp/sbt-0.13.12.tgz && \
mkdir -p /opt/sbt && \
tar xzvf /tmp/sbt-0.13.12.tgz -C /opt/sbt && \
rm -f /tmp/sbt-0.13.12.tgz && \
cd /opt/sbt && \
chown -R root:javadev /opt/sbt && \
ln -s `ls -1` current && \
echo "export SBT_HOME=/opt/sbt/current" >> /home/malima/.bashrc && \
echo "export PATH=\$SBT_HOME/bin:\$PATH" >> /home/malima/.bashrc

# Apache Spark
echo "Install Spark"
curl -sSL \
http://d3kbcqa49mib13.cloudfront.net/spark-2.0.2-bin-hadoop2.7.tgz \
-o /tmp/spark-2.0.2-bin-hadoop2.7.tgz && \
mkdir -p /opt/spark && \
tar xzvf /tmp/spark-2.0.2-bin-hadoop2.7.tgz -C /opt/spark && \
rm -f /tmp/spark-2.0.2-bin-hadoop2.7.tgz && \
cd /opt/spark && \
chown -R root:javadev /opt/spark && \
ln -s `ls -1` current && \
rm -f /opt/spark/current/bin/*.bat && \
echo "export PATH=/opt/spark/current/bin:\$PATH" >> /home/malima/.bashrc
echo "export SPARK_JAVA_OPTS=-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005" >> /home/malima/.bashrc

# Cassandra Loader
echo "Install cassandra-loader"
mkdir -p /opt/cassandra-loader/0.0.20/bin && \
curl -sSL \
https://github.com/brianmhess/cassandra-loader/releases/download/v0.0.20/cassandra-loader \
-o /opt/cassandra-loader/0.0.20/bin/cassandra-loader && \
chmod a+x /opt/cassandra-loader/0.0.20/bin/cassandra-loader && \
cd /opt/cassandra-loader && \
chown -R root:javadev /opt/cassandra-loader && \
ln -s `ls -1` current
echo "export PATH=/opt/cassandra-loader/current/bin:\$PATH" >> /home/malima/.bashrc

