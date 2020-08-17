#!/bin/bash
# Verify build plan variables are set appropriately for plan to succeed.

# 1. PRODUCT name set incorrectly
if [ "$bamboo_PRODUCT" != "analogout" ] && \
    [ "$bamboo_PRODUCT" != "burnin" ] && \
    [ "$bamboo_PRODUCT" != "digistream" ] && \
    [ "$bamboo_PRODUCT" != "epgdata" ] && \
    [ "$bamboo_PRODUCT" != "ip2av3" ] && \
    [ "$bamboo_PRODUCT" != "ip2av4" ]; then
    echo "ERROR: PRODUCT variable was incorrectly set to \"$bamboo_PRODUCT\"."
    echo "Must be one of the following: analogout, burnin, digistream, epgdata, ip2av3, ip2av4"
    exit 1
    
# 2. DISTRO set incorrectly
#elif [ "$bamboo_OS" != "centos7" ] && [ "$bamboo_OS" != "precise" ]; then
#    echo "ERROR: OS variable was incorrectly set to \"$bamboo_OS\"."
#    echo "Must be one of the following: centos7, precise"
#    exit 2
    
# 3. INSTALL_ON_DOCKER set incorrectly
#elif [ "$bamboo_INSTALL_ON_DOCKER" != "true" ] && [ "$bamboo_INSTALL_ON_DOCKER" != "false" ]; then
#    echo "### ERROR: INSTALL_ON_DOCKER variable was incorrectly set to \"$bamboo_INSTALL_ON_DOCKER\"."
#    echo "### Must be one of the following: true, false"
#    exit 3
    
# 4. TARGET_IP not set if installing on CI-external VM
#elif [ "$bamboo_INSTALL_ON_DOCKER" != "true" ] && [ ! -z "$bamboo_TARGET_USER" ] && [ -z "$bamboo_TARGET_IP" ]; then
#    echo "### ERROR: TARGET_IP variable is empty.  You need to enter a valid target IP address if \
#    installing against a VM and not a Docker container."
#    exit 4

# 5. TARGET_USER is populated but TARGET_PASSWORD is empty
#elif [ ! -z "$bamboo_TARGET_USER" ] && [ -z "$bamboo_TARGET_PASSWORD" ]; then
#    echo "### ERROR: TARGET_PASSWORD is empty. Please ensure to enter the password associated to \"$bamboo_TARGET_USER\"."
#    exit 5
    
# 6. TARGET_PASSWORD is populated but TARGET_USER is empty
#elif [ ! -z "$bamboo_TARGET_PASSWORD" ] && [ -z "$bamboo_TARGET_USER" ]; then
#    echo "ERROR: TARGET_USER is empty. Please ensure to enter the username associated to PASSWORD: \"$bamboo_TARGET_PASSWORD\"."
#    exit 6

# 7. VERSATIVE_VERSION set incorrectly
elif [ "$bamboo_VERSATIVE_VERSION" != "default" ] && [[ ! "$bamboo_VERSATIVE_VERSION" =~ [0-9].[0-9].[0-9].[0-9][0-9][0-9][0-9].[0-9][0-9][0-9] ]]; then
    echo "ERROR: VERSATIVE_VERSION variable was incorrectly set to \"$bamboo_VERSATIVE_VERSION\"."
    echo "Must be one of the following: 'default' or take the format of 'a.b.c.efgh.xyz' (ie. 2.2.1.1170.369)"
    exit 7

else
    exit 0
fi
