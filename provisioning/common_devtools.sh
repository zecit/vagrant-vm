#/bin/bash -aux

echo "> common_devtools.sh"

# To avoid message dpkg-preconfigure: unable to re-open stdin: No such file or directory
export DEBIAN_FRONTEND=noninteractive

add-apt-repository -y ppa:ubuntu-desktop/ubuntu-make
apt-get update
apt-get -y install ubuntu-make

echo "Install JDK8"
curl -sSL \
-b "oraclelicense=a" \
http://download.oracle.com/otn-pub/java/jdk/8u101-b13/jdk-8u101-linux-x64.tar.gz \
-o /tmp/jdk-8u101-linux-x64.tar.gz && \
mkdir -p /opt/oraclejdk64 && \
tar xzvf /tmp/jdk-8u101-linux-x64.tar.gz -C /opt/oraclejdk64 && \
rm -f /tmp/jdk-8u101-linux-x64.tar.gz && \
cd /opt/oraclejdk64 && \
chown -R root:javadev /opt/oraclejdk64 && \
ln -s `ls -1` current && \
echo "export JAVA_HOME=/opt/oraclejdk64/current" >> /home/malima/.bashrc && \
echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /home/malima/.bashrc && \
echo "export JAVA_OPTS=\"\$JAVA_OPTS -Dhttp.proxyHost=http://www-cache.aql.fr -Dhttp.proxyPort=3128 -Dhttp.proxyUser=vis -Dhttp.proxyPassword=visiteur\"" >> /home/malima/.bashrc

VERSION=`/opt/oraclejdk64/current/bin/java -version 2>&1 `

if [[ "$VERSION" != *"java version \"1.8.0_101\""* ]]; then
    echo 'Java is not correctly installed'
	exit 1
fi

# Intellij IDEA
echo "Install Intellij IDEA CE"
curl -sSL \
https://download.jetbrains.com/idea/ideaIC-2016.2.5.tar.gz \
-o /tmp/ideaIC-2016.2.5.tar.gz && \
mkdir -p /opt/idea && \
tar xzvf /tmp/ideaIC-2016.2.5.tar.gz -C /opt/idea && \
rm -f /tmp/ideaIC-2016.2.5.tar.gz && \
cd /opt/idea && \
ln -s `ls -1` current && \
chown -R root:javadev /opt/idea

# Atom
echo "Install atom.io"
apt-get -qq -y install gvfs-bin libnspr4 libnss3 libnss3-nssdb gconf2 gconf-service libgtk2.0-0 libnotify4 python xdg-utils
curl -sSL \
https://github.com/atom/atom/releases/download/v1.10.2/atom-amd64.deb \
-o /tmp/atom-amd64.deb && \
dpkg --install /tmp/atom-amd64.deb && \
rm -f /tmp/atom-amd64.deb

# Maven
echo "Install Maven"
curl -sSL \
http://mirrors.sonic.net/apache/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz \
-o /tmp/apache-maven-3.2.5-bin.tar.gz && \
mkdir -p /opt/maven && \
tar -zxf /tmp/apache-maven-3.2.5-bin.tar.gz -C /opt/maven && \
rm -f /tmp/apache-maven-3.2.5-bin.tar.gz && \
cd /opt/maven && \
chown -R root:javadev /opt/maven && \
ln -s `ls -1` current && \
echo "export M2_HOME=/opt/maven/current" >> /home/malima/.bashrc && \
echo "export PATH=\$M2_HOME/bin:\$PATH" >> /home/malima/.bashrc && \
echo "export M2_REPO=/home/malima/.m2" >> /home/malima/.bashrc

# Gradle (to bootstrap the gradle wrapper)
echo "Install Gradle"
curl -sSL \
https://services.gradle.org/distributions/gradle-2.14.1-rc-1-bin.zip \
-o /tmp/gradle-2.14.1-rc-1-bin.zip && \
mkdir /opt/gradle && \
unzip /tmp/gradle-2.14.1-rc-1-bin.zip -d /opt/gradle && \
rm -f /tmp/gradle-2.14.1-rc-1-bin.zip && \
cd /opt/gradle && \
chown -R root:javadev /opt/gradle && \
ln -s `ls -1` current && \
echo "export GRADLE_HOME=/opt/gradle/current" >> /home/malima/.bashrc && \
echo "export PATH=\$GRADLE_HOME/bin:\$PATH" >> /home/malima/.bashrc
