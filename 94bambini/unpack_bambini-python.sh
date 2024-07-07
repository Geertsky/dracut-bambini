#!/bin/bash
rm -f /placeholder.img
mkdir -p /local/conda/envs/bambini-python/
tar -xf /tmp/bambini-python.tar.gz -C /local/conda/envs/bambini-python/
rm -f /tmp/bambini-python.tar.gz
