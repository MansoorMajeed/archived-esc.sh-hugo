#!/bin/bash


set -e

npm run build

rclone -P sync public esc-sh:esc.sh
