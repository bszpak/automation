#! /bin/bash
# This script must be ran from a Build-Server machine
# as it sources a pre-configured virtualenv (vada-env)

VENV=vada-36-env

set -e
source ~/$VENV/bin/activate

function _fabtask_()
{

task_opts=("analogout" "burnin" "digistream" "digistream2" "ip2av3" "ip2av4" "epgdata" "Quit")

echo
echo "Select target product:"
select PRODUCT in "${task_opts[@]}"
do
    case $PRODUCT in
        "analogout")
            #IP=10.1.1.41
            read -p "Target IP: " IP
            cd ~/vada/$PRODUCT
            export DEFAULT_SKU=$PRODUCT;
            if [ "$1" = "create_product_user" ]; then
                fab -H $IP -p atxpassword "$1"
            else
                fab -H $IP --port=20022 --disable-known-hosts --sudo-password=appraisal-PROPOSED-worried-sig-OPT "$1"
            fi
            break
            ;;
        "burnin")
            IP=10.1.1.42
            #read -p "Target IP: " IP
            cd ~/vada/$PRODUCT
            export TARGET_OS=centos7;
	    export DJANGO_SETTINGS_MODULE=$PRODUCT.settings;
            if [ "$1" = "create_product_user" ]; then
                fab -H $IP -p atxpassword "$1"
            else
                fab -H $IP --disable-known-hosts --sudo-password=Deployment.withdrawal.Kyle.GUESS.Trusts "$1"
            fi
            break
            ;;
        "digistream")
            read -p "Are you sure this is being ran from a 'Digistream' build-server? (y/n) " SURE
            if [ $SURE == 'y' ]; then
                IP=10.1.1.43
               #read -p "Target IP: " IP
                cd ~/vada/$PRODUCT
                export DEFAULT_SKU=edgeqam;
                if [ "$1" = "create_product_user" ]; then
                    fab -H $IP -p atxpassword "$1"
                else
                    fab -H $IP --disable-known-hosts --sudo-password=Do!2StreamDigi "$1"
                fi
                break
            elif [ $SURE == 'n' ]; then
                echo "Exiting ..."
                exit 0
                break
            else
                echo "Invalid entry"
                exit 0
                break
            fi
            ;;
        "digistream2")
            IP=10.1.1.58
            #read -p "Target IP: " IP
            cd ~/vada/$PRODUCT
            export TARGET_OS=centos7;
            export DJANGO_SETTINGS_MODULE=$PRODUCT.settings;
            if [ "$1" = "create_product_user" ]; then
                fab -H $IP -p atxpassword "$1"
            else
                fab -H $IP --disable-known-hosts --sudo-password=DECLARE-ROOMS-Qty-chad-side "$1"
            fi
            break
            ;;
	"ip2av3")
            IP=10.1.1.44
           #read -p "Target IP: " IP
            cd ~/vada/$PRODUCT
	    export DEFAULT_SKU=$PRODUCT
            export DJANGO_SETTINGS_MODULE=$PRODUCT.settings;
            if [ "$1" = "create_product_user" ]; then
                fab -H $IP -p atxpassword "$1"
            else
                fab -H $IP --disable-known-hosts --sudo-password=Prairie.MANCHESTER.HEAVY.stanley.critical "$1"
            fi
            break
            ;;	
        "ip2av4")
            IP=10.1.1.54
            #read -p "Target IP: " IP
            cd ~/vada/$PRODUCT
            export TARGET_OS=centos7;
            export DJANGO_SETTINGS_MODULE=$PRODUCT.settings;
            if [ "$1" = "create_product_user" ]; then
                fab -H $IP -p atxpassword "$1"
            else
                fab -H $IP --disable-known-hosts --sudo-password=legislative-pets-sql-Attract-GUIDE "$1"
            fi
            break
            ;;
        "epgdata")
            IP=10.1.1.45
           #read -p "Target IP: " IP
            cd ~/vada/$PRODUCT
            export DJANGO_SETTINGS_MODULE=$PRODUCT.settings;
            if [ "$1" = "create_product_user" ]; then
                fab -H $IP -p atxpassword "$1"
            else
                fab -H $IP --disable-known-hosts --sudo-password=Hull\ jones\ WALLPAPERS\ Ghana\ Santa "$1"
            fi
            break
            ;;
        "videorouter")
            IP=unknown
           #read -p "Target IP: " IP
            cd ~/vada/$PRODUCT
            export DJANGO_SETTINGS_MODULE=$PRODUCT.settings;
            if [ "$1" = "create_product_user" ]; then
                fab -H $IP -p atxpassword "$1"
            else
                fab -H $IP --disable-known-hosts --sudo-password=calculations.chorus.utility.Rankings.HELPED "$1"
            fi
            break
            ;;
        "Quit")
            echo "Exiting ..."
            exit 0
            break
            ;;
        *) echo invalid option;;
    esac
done
}


options=("create_product_user" "initial_install" "upgrade_pips" "upgrade_migration_pips" "release" "upload_firmware" "Quit")

echo
echo "What fab task would you like to run?"

select opt in "${options[@]}"
do
  case $opt in
    "create_product_user")
        _fabtask_ create_product_user
        break
        ;;
    "initial_install")
        _fabtask_ initial_install
        break
        ;;
    "upgrade_pips")
        _fabtask_ upgrade_pips
        break
        ;;
    "upgrade_migration_pips")
        _fabtask_ upgrade_migration_pips
        break
        ;;
    "release")
        _fabtask_ release
        break
        ;;
    "upload_firmware")
        _fabtask_ upload_firmware
        break
        ;;
    "Quit")
        echo "Exiting ..."
        exit 0
        break;;
    *) echo invalid option;;
  esac
done
