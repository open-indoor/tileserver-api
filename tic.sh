#!/bin/bash
/usr/bin/flock -w 1 /var/tmp/actions.lock /usr/bin/actions.sh