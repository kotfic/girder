#!/bin/bash

mkdir _build
cd _build
cmake -DPYTHON_COVERAGE:BOOL=${PY_COVG} -DPYTHON_VERSION:STRING=${TRAVIS_PYTHON_VERSION} ..
JASMINE_TIMEOUT=15000 ctest -VV -S ../cmake/travis_continuous.cmake || true
if [ -f test_failed ] ; then false ; fi
cd ..
git fetch --unshallow
