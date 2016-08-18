#!/bin/bash

set -e
cat <<EOF > /tmp/inventory
[girder]
localhost
EOF

export PR=https://api.github.com/repos/$TRAVIS_REPO_SLUG/pulls/$TRAVIS_PULL_REQUEST
export BRANCH=$(if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then echo $TRAVIS_BRANCH; else echo `curl -s $PR | jq -r .head.ref`; fi)
echo "TRAVIS_BRANCH=$TRAVIS_BRANCH, PR=$PR, BRANCH=$BRANCH"
echo "TRAVIS_BUILD_DIR=$TRAVIS_BUILD_DIR"

cat <<EOF > ~/.ansible.cfg
[defaults]
roles_path = /tmp/roles:/etc/ansible/roles
EOF

ansible-galaxy install nodesource.node -p /tmp/roles
ansible-galaxy install Stouts.mongodb -p /tmp/roles

ansible-playbook -i /tmp/inventory ./devops/ansible/travis-playbook.yml -vv
