#!/bin/bash

set -e
cat <<EOF > /tmp/inventory
[girder]
localhost
EOF

These contents will
export PR=https://api.github.com/repos/$TRAVIS_REPO_SLUG/pulls/$TRAVIS_PULL_REQUEST
export BRANCH=$(if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then echo $TRAVIS_BRANCH; else echo `curl -s $PR | jq -r .head.ref`; fi)
echo "TRAVIS_BRANCH=$TRAVIS_BRANCH, PR=$PR, BRANCH=$BRANCH"
echo "TRAVIS_BUILD_DIR=$TRAVIS_BUILD_DIR"

# ansible-playbook -i /tmp/inventory ./devops/ansible/travis-playbook.yml -vv
