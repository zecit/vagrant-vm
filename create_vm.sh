# /bin/bash -aux

rm -rf .first_run_done && \
vagrant up && \
vagrant halt && \
touch .first_run_done && \
vagrant up --provision
