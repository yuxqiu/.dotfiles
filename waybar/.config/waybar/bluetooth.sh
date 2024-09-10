#!/bin/bash

if rfkill -o TYPE,SOFT | grep bluetooth | grep unblocked > /dev/null; then
    # Bluetooth is enabled
    rfkill block bluetooth
else
    rfkill unblock bluetooth
fi
