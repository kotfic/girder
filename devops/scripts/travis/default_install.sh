#!/bin/bash

set -e
pip install -r requirements-dev.txt -e .[plugins] -e clients/python
npm install
