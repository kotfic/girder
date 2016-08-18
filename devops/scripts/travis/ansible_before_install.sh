#!/bin/bash

set -e
export ANSIBLE_VERSION=2.1.0
pip install -U pip virtualenv ansible==${ANSIBLE_VERSION}
