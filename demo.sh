#! /bin/bash

clear

# GLOBAL VARIABLES
MENU=""
RGNAME=""
HUBNAME=""
DEVICEID=""
BASHSTRING=""
ID=""
CONFIGNAME=""


# MAINMENU SELECTION
mainMenu() {
    clear
    echo "   --------------------"
    echo "   LP Command & Control"
    echo "   --------------------"
    echo
    echo "   1) Create Resource Groups"
    echo "   2) Create Hubs"
    echo "   3) Create Twins"
    echo "   4) View Twins"
    echo "   5) Execute Commands"
    echo
    echo "   c) Connect"
    echo "   x) Disconnect"
    echo "   q) Quit program"
    echo
    echo -n "Please choose: "
    read CHOICE

    case $CHOICE in
        1 )     createNewResourceGroup;;
        2 )     createNewIoTHub;;
        3 )     createNewDevice;;
        4 )     listDevices;;
        5 )     commandRunner;;
        c|C )   azLogin;;
        x|X )   azLogout;;
        q|Q )   clear
                exit;;
        * )     echo "Please make a valid selection."
                sleep 2
                mainMenu;;
    esac
}


# Create New Resource Group (Still need to capture and report any error mesages.)
# Location is hardcoded to EASTUS. Change if necessary.
createNewResourceGroup() {
    clear
    echo -n "Name your Resource Group: "
    read RGNAME

    clear
    echo -n "Creating new resource group $RGNAME... "

    resourceJSON=$(az group create --location eastus --resource-group $RGNAME)
    resourceStatus=$(az group show --resource-group $RGNAME --query "properties.provisioningState" --output tsv)
   
    if [[ $resourceStatus == "Succeeded" ]]
    then
        echo "done!"
        sleep 2
        mainMenu
    else
        echo "failed!"
        exit
    fi
}


# Create new IoT Hub (Still need to capture and report any error mesages.)
createNewIoTHub() {
    clear
    echo -n "Name of the hub: "
    read HUBNAME

    echo -n "Which Resource Group will it belong to: "
    read RGNAME
   
    clear
    echo -n "Creating the $HUBNAME hub... "
    echo

    resourceStatus=$(az iot hub create \
                                --resource-group $RGNAME \
                                --name $HUBNAME \
                                --partition-count 2 \
                                --sku S1 \
                                --query "properties.provisioningState" \
                                --output tsv)

    if [[ $resourceStatus == "Succeeded" ]]
    then
        echo "The $HUBNAME hub has been created!"
        sleep 2
        mainMenu
    else
        clear
        echo "Hub creation failed!"
        exit
    fi
}


# osConfig's CommandRunner Function
commandRunner() {
    clear
    targets=""
    ID=$(echo $RANDOM)

    echo -n "Which Resource Group: "
    read RGNAME

    echo -n "Send command to which hub: "
    read HUBNAME

    echo -n "Enter the command: "
    read BASHSTRING

    echo -n "Name this command: "
    read CONFIGNAME

    commandStatus=$(az iot hub configuration create -c "$CONFIGNAME" \
                                                      --content \
                                                          '{"moduleContent":
                                                               {"properties.desired.CommandRunner":
                                                                  {"commandArguments":
                                                                     {"commandId": "'"$ID"'", 
                                                                        "action":3, 
                                                                        "arguments": "'"$BASHSTRING"'"
                                                                     }
                                                                  }
                                                               }
                                                            }' \
                                                         --target-condition "from devices.modules where moduleId='osconfig'" \
                                                         --resource-group $RGNAME \
                                                         --hub-name $HUBNAME)

    if [[ $? == 0 ]]
    then
        echo "Command applied. Waiting 40 seconds for commmand(s) to execute... "
        sleep 40
    else
        echo "Application of command failed! Exiting."
        exit
    fi

    echo "Verifying command execution... "
    targets=$(az iot hub configuration show --resource-group $RGNAME --hub-name $HUBNAME --config-id $CONFIGNAME --query systemMetrics.results.appliedCount)

    echo "Command successfully applied to $targets targets."
    echo
    echo "Press any key to continue."
    read any

    mainMenu
}


# Create Digital Twin in an IoT Hub (Still need to capture and report any error mesages.)
createNewDevice() {
    clear

    echo -n "Name your twin: "
    read DEVICEID

    echo -n "Which Resource Group will it belong to: "
    read RGNAME

    echo -n "Which hub will control it: "
    read HUBNAME
   
    echo -n "Creating $DEVICEID in the $HUBNAME hub... "

    deviceStatus=$(az iot hub device-identity create --resource-group $RGNAME --hub-name $HUBNAME --device-id $DEVICEID --query "deviceId" --output tsv)

    if [[ $deviceStatus == $DEVICEID ]]
    then
        echo "$DEVICEID created!"
        sleep 2
    else
        echo "unable to create $DEVICEID! Exiting... "
        exit
    fi

    connectionString=$(az iot hub device-identity connection-string show \
                                                    --resource-group $RGNAME \
                                                    --hub-name $HUBNAME \
                                                    --device-id $DEVICEID \
                                                    --query connectionString)
    sed "s|demo_connection_string|$connectionString|" osConfigRemoteInstall.init > $DEVICEID.sh

    mainMenu
}


# List Digitial Twins within an IoT Hub (Still need to capture and report any error mesages.)
listDevices() {
   # Pick your resource group
    PS3=$'\n'"Select a Resource Group: "
    getList=($(az group list --output table | awk 'NR > 2 {print $1}'))

    clear
    echo "Available resource groups: "
    echo

   # Pick your IoT Hub
    select RGNAME in "${getList[@]}"
    do

        PS3=$'\n'"Select an IoT Hub: "
        getList=($(az iot hub list --resource-group $RGNAME --output table | awk 'NR > 2 {print $2}'))

        clear
        echo "Available IoT Hubs: "
        echo

        # Show your devices in the IoT Hub
        select HUBNAME in "${getList[@]}"
        do
            clear
            echo "Available twins in the $HUBNAME hub: "
            echo
            az iot hub query --resource-group $RGNAME --hub-name $HUBNAME -q "select deviceId,moduleId,connectionState from devices.modules where moduleId='osconfig'" --output table
            echo
            echo -n "Press any key to continue."
            read key
            mainMenu
        done

    done
}


# Azure Login Function
azLogin() {
    clear
    echo "Connecting... "
    loginStatus=$(az login)
    if [ "$?" -eq 0 ]; then
        mainMenu
    else
        echo "There was an error connecting!"
        exit
    fi
}


# Azure Logout Function
azLogout() {
    clear
    echo -n "Disconnecting..."
    logoutStatus=$(az logout)
    if [ "$?" -eq 0 ]; then
        echo "done!"
        sleep 2
    else
        echo "There was an error disconnecting!"
        exit
    fi
}


# Start Program
mainMenu
exit
