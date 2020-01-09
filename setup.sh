#!/bin/bash

echo "You really must update the pillar/deploy.sls file to contain an actual private pem key"
salt-call state.apply prep.bb -ldebug
