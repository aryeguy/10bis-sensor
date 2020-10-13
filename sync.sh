#!/bin/sh

# RESTART_HA=false
echo $RESTART_HA

# TODO move to python
rsync --verbose \
	--archive \
	--compress \
	--partial \
       	--progress \
	--exclude '.git/' \
	--exclude '**/*.swp' \
      	./ rp:10bis-sensor
