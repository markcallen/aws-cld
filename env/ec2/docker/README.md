#

## Install

ansible-galaxy role install -r requirements.yml
ansible-playbook -i dev -u ubuntu docker.yml

## Test

ansible-playbook -i dev --syntax-check docker.yml
