#!/bin/bash
set -o errexit
set -o nounset

# This script is used by the bamboo server to execute builds each long
# options supports a specific task.  The script facilitates testing by
# providing a --dry-run which causes it to just print the requested
# action and a --verbose option which causes the script do `set -x`.

# TODO: [SB2-909] Re-enable sky build.

# mkfs.ubifs support
export PATH=${PATH}:/usr/sbin

NPROC=1

BUILD_BLADE=0
BUILD_BLADE_ALL=0
BUILD_PICO=0
BUILD_SKY=0
BUILD_DISHIP=0
BUILD_FACTORY=0
BUILD_PRODUCTION=0
BUILD_HOST=0
DRY_RUN=0
DIRTY=0

LONGOPTIONS="\
blade-pico,\
blade-diship,\
blade-factory,\
blade-production,\
blade-all,\
host,\
nproc,\
dirty,\
dry-run,\
verbose"

OPTIONS=$(getopt --name ${0##*/} --longoptions "${LONGOPTIONS}" \  -- "$@")
eval set "$OPTIONS"
while [ $# -gt 0 ]; do
    case "$1" in
        --verbose)
            set -x
            ;;
        --dry-run)
            DRY_RUN=1
            ;;
        --blade-pico)
            BUILD_BLADE=1
            BUILD_PICO=1
            ;;
        --blade-diship)
            BUILD_BLADE=1
            BUILD_DISHIP=1
            ;;
        --blade-factory)
            BUILD_BLADE=1
            BUILD_FACTORY=1
            ;;
        --blade-production)
            BUILD_BLADE=1
            BUILD_PRODUCTION=1
            ;;
        --blade-all)
            BUILD_BLADE=1
            BUILD_BLADE_ALL=1
            BUILD_PICO=1

            BUILD_DISHIP=1
            BUILD_FACTORY=1
            BUILD_PRODUCTION=1
            ;;
        --host)
            BUILD_HOST=1
            ;;
        --nproc)
            NPROC=$2
            shift
            ;;
        --dirty)
            DIRTY=1
            ;;
        *)
            echo Unknown option "${1}"
            echo "Options are: ${LONGOPTIONS}"
            exit 1
            ;;
    esac
    shift
done

function run_command() {
    if [ ${DRY_RUN} -eq 1 ]; then
        echo $@
    else
        $@
    fi
}

function build_prep() {
    local BUILT_TOOLCHAIN=$(cat build/toolchain/.pd-git-hash || echo none)
    local CURRENT_TOOLCHAIN=$(git log -1 --format=%H -- meta-picodigital)
    if [ ${CURRENT_TOOLCHAIN} != ${BUILT_TOOLCHAIN} ]; then
        run_command ./build/generate-cmake.sh
        if [ ${DRY_RUN} -eq 1 ]; then
            echo "echo ${CURRENT_TOOLCHAIN} > build/toolchain/.pd-git-hash"
        else
            echo ${CURRENT_TOOLCHAIN} > build/toolchain/.pd-git-hash
        fi
    fi
}

function prod_blade_deploy() {
    # Save artifacts
    run_command cp build/blade/${MAKE_TARGET_IMAGE} deploy/${PACKAGENAME}.pkg
    run_command cp --dereference meta-picodigital/build/tmp/deploy/images/imx6solo${PRODUCT}_prod/u-boot.imx deploy/${PRODUCT}-production-u-boot.imx
}

function dev_blade_deploy() {
    # Save artifacts
    run_command cp build/blade/${MAKE_TARGET_CPIO_IMAGE} deploy/${PACKAGENAME}.pkg
    run_command cp --dereference meta-picodigital/build/tmp/deploy/images/imx6solo${PRODUCT}_dev/u-boot.imx deploy/${PRODUCT}-development-u-boot.imx
}

function dev_blade_legacy_deploy() {
    run_command cp build/blade/${MAKE_TARGET_UBIFS_IMAGE} deploy/${PACKAGENAME}-legacy.pkg
}

if [ ${DIRTY} -eq 0 ]; then
    # Clean up old build
    run_command ./scripts/cleanup.sh
fi

# Limit how parallel bitbake will run so we can do multiple builds at once without running out of ram
export BB_ENV_EXTRAWHITE="BB_NUMBER_THREADS BB_NUMBER_PARSE_THREADS"
export BB_NUMBER_THREADS=${NPROC}
export BB_NUMBER_PARSE_THREADS=${NPROC}

if [ ${BUILD_BLADE} -eq 1 ]; then
    run_command rm -rf deploy
    run_command mkdir deploy

    # Get the version info early so it applies to all
    export VERSION=`./cmake-utils/rootfs/version.sh --default-version-delimited`
    export HASH=`git describe --match=invalid-tag-name --dirty --always`
fi

# Build the images
BLADE_IMAGE_TARGETS=""

if [ ${BUILD_BLADE_ALL} -eq 1 ]; then
    BLADE_IMAGE_TARGETS="${BLADE_IMAGE_TARGETS} dev prod factory"
else
    if [ ${BUILD_PICO} -eq 1 ]; then
        BLADE_IMAGE_TARGETS="${BLADE_IMAGE_TARGETS} dev-pico"
        if [ ${BUILD_PRODUCTION} -eq 1 ]; then
            BLADE_IMAGE_TARGETS="${BLADE_IMAGE_TARGETS} prod-pico"
        fi
    fi

    if [ ${BUILD_DISHIP} -eq 1 ]; then
        BLADE_IMAGE_TARGETS="${BLADE_IMAGE_TARGETS} dev-diship-cpio-pkg"
        if [ ${BUILD_PRODUCTION} -eq 1 ]; then
            BLADE_IMAGE_TARGETS="${BLADE_IMAGE_TARGETS} prod-diship-a-cpio-pkg"
        fi
    fi

    if [ ${BUILD_FACTORY} -eq 1 ]; then
        BLADE_IMAGE_TARGETS="${BLADE_IMAGE_TARGETS} factory"
    fi
fi

if [ ! -z "${BLADE_IMAGE_TARGETS}" ]; then
    build_prep
    run_command make -C build/blade -j ${NPROC} ${BLADE_IMAGE_TARGETS}
fi

# Deploy the images
if [ ${BUILD_PICO} -eq 1 ]; then
    PRODUCT=pd1600
    PACKAGENAME=dev-pico-${VERSION}-${HASH}
    MAKE_TARGET_UBIFS_IMAGE=dev-pico-ubifs.pkg
    MAKE_TARGET_CPIO_IMAGE=dev-pico-cpio.pkg
    dev_blade_deploy
    dev_blade_legacy_deploy

    if [ ${BUILD_PRODUCTION} -eq 1 ]; then
        PACKAGENAME=pd1600-pico-${VERSION}-${HASH}
        MAKE_TARGET_IMAGE=prod-pico-c-cpio.pkg
        prod_blade_deploy
    fi
fi

if [ ${BUILD_SKY} -eq 1 ]; then
    PRODUCT=pd1600
    PACKAGENAME=dev-sky-${VERSION}-${HASH}
    MAKE_TARGET_UBIFS_IMAGE=dev-sky-ubifs.pkg
    MAKE_TARGET_CPIO_IMAGE=dev-sky-cpio.pkg
    dev_blade_deploy
    dev_blade_legacy_deploy

    if [ ${BUILD_PRODUCTION} -eq 1 ]; then
        PACKAGENAME=pd1600-sky-${VERSION}-${HASH}
        MAKE_TARGET_IMAGE=prod-sky-c-cpio.pkg
        prod_blade_deploy
    fi
fi

if [ ${BUILD_DISHIP} -eq 1 ]; then
    PRODUCT=pd1600
    PACKAGENAME=dev-diship-${VERSION}-${HASH}
    MAKE_TARGET_CPIO_IMAGE=dev-diship-cpio.pkg
    dev_blade_deploy

    if [ ${BUILD_PRODUCTION} -eq 1 ]; then
        PACKAGENAME=dish-diship-${VERSION}-${HASH}
        MAKE_TARGET_IMAGE=prod-diship-a-cpio.pkg
        prod_blade_deploy
    fi
fi

if [ ${BUILD_FACTORY} -eq 1 ]; then
    PRODUCT=pd1600
    PACKAGENAME=pd1600-unsecure-factory-${VERSION}-${HASH}
    MAKE_TARGET_IMAGE=factory-pd1600-unsecure-cpio.pkg
    prod_blade_deploy

    PACKAGENAME=dish-unsecure-factory-${VERSION}-${HASH}
    MAKE_TARGET_IMAGE=factory-pd1600-unsecure-cpio.pkg
    prod_blade_deploy

    PACKAGENAME=pd1600-factory-${VERSION}-${HASH}
    MAKE_TARGET_IMAGE=factory-pd1600-secure-c-cpio.pkg
    prod_blade_deploy

    PACKAGENAME=dish-factory-${VERSION}-${HASH}
    MAKE_TARGET_IMAGE=factory-pd1600-secure-a-cpio.pkg
    prod_blade_deploy
fi

if [ ${BUILD_HOST} -eq 1 ]; then
    # Build
    build_prep
    run_command make -C build/host -j ${NPROC} all

    # Run tests
    # Set locale to generic C, which is what we run on the target
    export LC_ALL="C"
    # Unset LD_PRELOAD to avoid host interference in libraries
    unset LD_PRELOAD
    CTEST_OUTPUT_ON_FAILURE=1 run_command make -C build/host test
fi
