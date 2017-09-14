#!/bin/sh
# Written By: Ramon Brooker <rbrooker@aetherealmind.com>
# (c) 2017




echo "$(date -u +%Y-%m-%d_%Hh%M_UTC)" > /UPDATED
echo " **************************************************"
echo ""
echo "This Image was last updated: $(cat /UPDATED) " 
echo ""
echo " **************************************************"


exit 0
