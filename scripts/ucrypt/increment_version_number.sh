#!/bin/bash

awk -F'[.]' '{print $1"."$2"."$3+1}' OFS=, version_number >tmp && mv tmp version_number
cat version_number
