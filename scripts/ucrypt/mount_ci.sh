#!/bin/bash

cd "$(dirname "$0")"
THIS_DIR="$(pwd)"

mkdir -p "${THIS_DIR}/Safe"
echo "a29fe138-cd3f-4f47-93bf-812d50d956b1" | encfs -S "${THIS_DIR}/.Safe" "${THIS_DIR}/Safe"
