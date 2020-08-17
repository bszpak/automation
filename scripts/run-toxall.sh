#!/bin/bash

ssh -T -o StrictHostKeyChecking=no $bamboo_CISERVER <<-EOSSH
    lxc exec $bamboo_VADA_TESTS_LXC -- su ubuntu /bin/bash -c "\
    cd $bamboo_VADA_DIR; \
    source $bamboo_ENV/bin/activate; \
    LANG=en_US.UTF-8 PY27_ONLY=1 NO_BOMBING=1 INSTALL_COMMAND='pip install --find-links=/dev/shm/wheels' PYTEST_ARGS='-n 8' TOX_ARGS='--workdir /dev/shm/tox' PRODUCT_PYTEST_ARGS=--reuse-db ./toxall.sh"
EOSSH

# With --use-wheel flag
#    lxc exec $bamboo_LXC1 -- su ubuntu /bin/bash -c "cd $bamboo_DIR; source $bamboo_ENV/bin/activate; LANG=en_US.UTF-8 PY27_ONLY=1 NO_BOMBING=1 INSTALL_COMMAND='pip install --use-wheel --find-links=/dev/shm/wheels' PYTEST_ARGS='-n 8' TOX_ARGS='--workdir /dev/shm/tox' PRODUCT_PYTEST_ARGS=--reuse-db ./toxall.sh"

# If container running in Proxmox
#ssh -T -o StrictHostKeyChecking=no $bamboo_LXC1_SSH <<-EOSSH
#    cd $bamboo_DIR
#    source $bamboo_ENV/bin/activate
#    LANG=en_US.UTF-8 PY27_ONLY=1 NO_BOMBING=1 INSTALL_COMMAND='pip install --find-links=/dev/shm/wheels' PYTEST_ARGS='-n 8' TOX_ARGS='--workdir /dev/shm/tox' PRODUCT_PYTEST_ARGS=--reuse-db ./toxall.sh
#EOSSH

#$CMD /bin/bash -c "cd $DIR; source /usr/src/ip2av3-env/bin/activate; PY26_ONLY=1 NO_BOMBING=1 INSTALL_COMMAND='pip install --use-wheel --find-links=/dev/shm/wheels' TOX_ARGS='--workdir /dev/shm/tox' PRODUCT_PYTEST_ARGS=--reuse-db ./toxall.sh"
#$CMD /bin/bash -c "cd $DIR; source $ENV/bin/activate; LANG=en_US.UTF-8 PY27_ONLY=1 NO_BOMBING=1 INSTALL_COMMAND='pip install --use-wheel --find-links=/dev/shm/wheels' PYTEST_ARGS='-n 8' TOX_ARGS='--workdir /dev/shm/tox' PRODUCT_PYTEST_ARGS=--reuse-db ./toxall.sh"
