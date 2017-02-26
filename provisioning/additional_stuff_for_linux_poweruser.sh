#! /bin/bash -aux

echo "> additional_stuff_for_linux_poweruser.sh"

# ZSH
echo "Install ZSH"
apt-get -qq -y install zsh

# virtualenvwrapper (helper commands for virtualenv)
echo "Install virtualenvwrapper"
pip install virtualenvwrapper
