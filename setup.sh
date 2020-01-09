#!/bin/bash

PYTHON_EXECUTABLE=$(salt buildbox grains.get pythonexecutable | sed -n 2p | sed 's/^[ \t]*//;s/[ \t]*$//')

$PYTHON_EXECUTABLE update_pem.py

salt buildbox state.apply prep.bb -ldebug
