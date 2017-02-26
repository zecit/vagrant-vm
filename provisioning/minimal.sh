#/bin/bash -aux

#Read locale setting, if it exists
if [ $# -gt 0 ]; then
  locale=$1
  echo "Locale is set to $locale"
fi

echo "> minimal.sh"

if [ "$locale" != "English" ]; then
  echo "Set default locale to fr"
  sed -i "s/^LANG=.*/LANG=\"fr_FR.UTF-8\"/" /etc/default/locale

  echo "Set default keyboard layout to fr"
  sed -i "s/^XKBLAYOUT=.*/XKBLAYOUT=\"fr\"/" /etc/default/keyboard
  sed -i "s/^XKBVARIANT=.*/XKBVARIANT=\"oss\"/" /etc/default/keyboard

  echo "Set default timezone to Europe/Paris"
  timedatectl set-timezone Europe/Paris

else
  echo "Set default timezone to Europe/Bucharest"
  timedatectl set-timezone Europe/Bucharest
fi





echo "Create group javadev"
groupadd javadev
echo "Create group docker"
groupadd docker
echo "Create user malima"
useradd -m -U -G adm,dialout,cdrom,floppy,sudo,audio,dip,video,plugdev,netdev,lxd,javadev,docker -p uL4Xmb9vdVvmQ malima
echo "Add docker to group of malima user"
usermod -aG docker malima
echo "Add ~/bin in the PATH of malima user"
echo "export PATH=~/bin:\$PATH" >> /home/malima/.bashrc

# To avoid message dpkg-preconfigure: unable to re-open stdin: No such file or directory
export DEBIAN_FRONTEND=noninteractive

echo "Add repository for Docker"
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
rm -f /etc/apt/sources.list.d/docker.list && \
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" > /etc/apt/sources.list.d/docker.list

echo "Update system and install minimal stuffs"
apt-get update && \
apt-get -qq -y upgrade && \
apt-cache policy docker-engine && \
apt-get -qq -y install language-pack-fr xorg xdm xfce4 terminator curl vim virtualbox-guest-x11 virtualbox-guest-dkms \
  python-pip virtualenv git apt-transport-https ca-certificates openssh-server unzip gedit apache2 firefox gitk \
  docker-engine
mkdir /etc/systemd/system/docker.service.d && \
echo "[Service]" >> /etc/systemd/system/docker.service.d/http-proxy.conf && \
echo "Environment=\"HTTP_PROXY=http://vis:visiteur@www-cache.aql.fr:3128/\" \"NO_PROXY=localhost,127.0.0.1,docker-registry.somecorporation.com\"" >> /etc/systemd/system/docker.service.d/http-proxy.conf && \
# echo "export DOCKER_HOST=tcp://127.0.0.1:2375" >> /home/malima/.bashrc
echo "DOCKER_OPTS=\"--dns 192.168.64.64 --dns 192.168.64.65 --dns 8.8.8.8 --insecure-registry=192.168.46.255 -H fd:// -H tcp://127.0.0.1:2375\"" >> /etc/default/docker
# see http://doctech-oab.si.fr.intraorange/docker/starting-guide/
echo "[Service]" >> /etc/systemd/system/docker.service.d/default.conf && \
echo "EnvironmentFile=-/etc/default/docker" >> /etc/systemd/system/docker.service.d/default.conf && \
echo "ExecStart=" >> /etc/systemd/system/docker.service.d/default.conf && \
echo "ExecStart=/usr/bin/docker daemon $DOCKER_OPTS" >> /etc/systemd/system/docker.service.d/default.conf
systemctl enable docker && \
systemctl start docker

VERSION=`docker --version 2>&1 `

if [[ "$VERSION" != *"Docker version"* ]]; then
    echo 'Docker is not correctly installed'
	exit 1
fi


# Docker-compose
echo "Install docker-compose"
curl -sSL \
https://github.com/docker/compose/releases/download/1.7.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && \
chmod +x /usr/local/bin/docker-compose

VERSION=`docker-compose version 2>&1 `

if [[ "$VERSION" != *"1.7.1"* ]]; then
    echo 'Docker compose is not correctly installed'
	exit 1
fi

# Dos2unix
echo "Install dos2unix"
apt install dos2unix

# Git aliases
echo "Config git aliases"
git config --global alias.co "checkout"
git config --global alias.br "branch"
git config --global alias.ci "commit"
git config --global alias.st "status"
git config --global alias.hist "log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short"
git config --global alias.type "cat-file -t"
git config --global alias.dump "cat-file -p"
git config --global alias.mg "merge --no-ff"

# Development folder
echo "Create project development directory"
mkdir /home/malima/Projects && chown -R malima: /home/malima/Projects


