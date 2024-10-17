#!/bin/bash
#
# Pre-execution script for updating and installing feeds
#

# 1. helloworld feed
# Remove any existing 'helloworld' feed source from feeds.conf.default
sed -i "/helloworld/d" "feeds.conf.default"
# Add the 'helloworld' feed source to feeds.conf.default
echo "src-git helloworld https://github.com/fw876/helloworld.git" >>"feeds.conf.default"
echo "helloworld feed source updated in feeds.conf.default"
