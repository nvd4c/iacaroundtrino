#!/bin/bash
cd /trino
sudo sed -i "s/node.id = 52a97247-trino-worker-02/node.id = $(uuidgen)/g" trino-server/etc/node.properties
sudo python3 trino-server/bin/launcher.py restart