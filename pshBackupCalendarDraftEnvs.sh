#!/bin/bash

echo "Creating Snapshot of vancouver.calendar.ubc.ca DRAFT environment";
platform snapshot:create --environment=draft-content-vancouver --project="aktqocgqruqfa" --no-wait --yes

sleep 15
echo "Creating Snapshot of okanagan.calendar.ubc.ca DRAFT environment";
platform snapshot:create --environment=draft-content-okanagan --project="6hlqu3vk3sihm" --no-wait --yes
