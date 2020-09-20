#!/bin/bash
vboxmanage startvm puppetagent01 --type headless
sleep 3
vboxmanage list runningvms
sleep 6
ssh root@127.0.0.1 -p 2223
