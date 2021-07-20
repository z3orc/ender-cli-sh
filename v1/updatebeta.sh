#!/bin/bash

source server.settings
echo "[INFO] Checking latest verions"

OLDVERSION=$(unzip -p paperclip.jar version.json | grep "name" | cut -d\" -f4)

wget -qN https://launchermeta.mojang.com/mc/game/version_manifest.json
NEWVERSION=$(sed -n -e '/\"latest\"/,/}/ s/.*\"snapshot\": \"\([^\"]*\)\".*/\1/p' < version_manifest.json)

echo "[INFO] Current version = $OLDVERSION"
echo "[INFO] Latest version = $NEWVERSION"

tmux has-session -t minecraft 2>/dev/null

if [ $? != 0 ]; then
        echo "[ERROR] Server is not running"
        exit
else
        echo "[INFO] Server running."

fi

if grep -q "w" <<< "$NEWVERSION"; then
    echo "[INFO] Server compatible with latest snapshot version"

else
    echo "[ERROR] Server not compatible with latest snapshot version"
    exit
fi

if [ "$OLDVERSION" = "$NEWVERSION" ]; then

    echo "[INFO] Server is running latest version!"
    rm version_manifest.json
    exit


else
   
    echo "[INFO] Server is not running latest version, updating now!"

    echo "[INFO] Updating server jar-file, this might take a moment."
    mcontrol stop
    mcontrol hourlybackup

    mkdir .update
    cp paperclip.jar .update
    cp -r world .update

    rm paperclip.jar

    if [[ $VERSION == "latest" || $VERSION == "LATEST" ]]; then
        MC_VERSION_URLS=$(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | python -c 'import json,sys,base64;obj=json.load(sys.stdin); print obj["versions"][1]["url"]') 

        MC_LATEST_RELEASE=$(curl -s $MC_VERSION_URLS | python -c 'import json,sys,base64;obj=json.load(sys.stdin); print obj["downloads"]["server"]["url"]')                         

        wget -O paperclip.jar $MC_LATEST_RELEASE

        # NEWVERSION=$(unzip -p paperclip.jar version.json | grep "name" | cut -d\" -f4)

        # sed -i -e 's/VERSION=$VERSION.*/VERSION=$NEWVERSION /g' $DIR/server.settings


    elif [[ $VERSION == "snapshot" || $VERSION == "SNAPSHOT" ]]; then
        MC_VERSION_URLS=$(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | python -c 'import json,sys,base64;obj=json.load(sys.stdin); print obj["versions"][0]["url"]') 

        MC_LATEST_SNAPSHOT=$(curl -s $MC_VERSION_URLS | python -c 'import json,sys,base64;obj=json.load(sys.stdin); print obj["downloads"]["server"]["url"]')                         

        wget -O paperclip.jar $MC_LATEST_SNAPSHOT

        # NEWVERSION=$(unzip -p paperclip.jar version.json | grep "name" | cut -d\" -f4)

        # sed -i -e 's/VERSION=$VERSION.*/VERSION=$NEWVERSION /g' $DIR/server.settings

    fi

    rm version_manifest.json

fi


mcontrol run_no_watcher

sleep 18

tmux has-session -t minecraft 2>/dev/null

        if [ $? != 0 ]; then
                echo "[ERROR] Update failed, reverting changes"
                rm paperclip.jar
                rm -rf world
                cd $DIR/.update
                cp -r world $DIR
                cp paperclip.jar $DIR
        else
                sleep 15
                echo "[INFO] Update completed!"
                tmux new -d -s watcher mcontrol watcher
                exit

        fi


# if [[ $VERSION == "latest" || $VERSION == "LATEST" ]]; then
#         echo "[INFO] Downloading latest jar-file from PAPERMC.IO"
#         wget -O version.latest https://pastebin.com/raw/amFrP6sc
#         source version.latest
#         wget -O server.jar https://papermc.io/api/v1/paper/$LATEST/latest/download
#         rm version.latest

# elif [[ $VERSION == "custom" || $VERSION == "CUSTOM" ]]; then
#         echo "[ERROR] Server running custom, cannot download latest version."
#         exit
# else
#         echo "[INFO] Downloading jar-file from PAPERMC.IO"
#         wget -O server.jar https://papermc.io/api/v1/paper/$VERSION/latest/download

# fi

# echo "[INFO] Latest jar-file has been downloaded."
# echo "[INFO] Update finished"

# mcontrol run