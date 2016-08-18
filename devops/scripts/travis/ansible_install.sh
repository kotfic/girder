#!/bin/bash

set -e

# Create a local inventory
cat <<EOF > /tmp/inventory
[girder]
localhost
EOF


# Set up configuration
cat <<EOF > ~/.ansible.cfg
[defaults]
host_key_checking = False
roles_path        = /tmp/roles:/etc/ansible/roles
EOF


# Install required roles
ansible-galaxy install nodesource.node -p /tmp/roles
ansible-galaxy install Stouts.mongodb -p /tmp/roles

# Export variables needed by travis-playbook.yml
export PR=https://api.github.com/repos/$TRAVIS_REPO_SLUG/pulls/$TRAVIS_PULL_REQUEST
export BRANCH=$(if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then echo $TRAVIS_BRANCH; else echo `curl -s $PR | jq -r .head.ref`; fi)
echo "TRAVIS_BRANCH=$TRAVIS_BRANCH, PR=$PR, BRANCH=$BRANCH"
echo "TRAVIS_BUILD_DIR=$TRAVIS_BUILD_DIR"


# Check syntax
ansible-playbook -i /tmp/inventory ./devops/ansible/travis-playbook.yml --syntax-check

# Provision localhost
ansible-playbook -i /tmp/inventory ./devops/ansible/travis-playbook.yml -vv
