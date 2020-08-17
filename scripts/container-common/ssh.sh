#!/bin/bash

source config
ssh -o StrictHostKeyChecking=no atx@localhost -p $PORT
