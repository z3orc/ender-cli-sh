#!/bin/bash

#Version: 1.1
#Revision: 136
#Author: z3orc

install(){
        #!/bin/bash

        clear

        echo "_________________________________________________________________________________________________________________/\\\\\\____        
               ________________________________________________________________________________________________________________\////\\\____       
                _______________________________________________________________________/\\\________________________________________\/\\\____      
                 ____/\\\\\__/\\\\\________/\\\\\\\\______/\\\\\______/\\/\\\\\\_____/\\\\\\\\\\\___/\\/\\\\\\\_______/\\\\\________\/\\\____     
                  __/\\\///\\\\\///\\\____/\\\//////_____/\\\///\\\___\/\\\////\\\___\////\\\////___\/\\\/////\\\____/\\\///\\\______\/\\\____    
                   _\/\\\_\//\\\__\/\\\___/\\\___________/\\\__\//\\\__\/\\\__\//\\\_____\/\\\_______\/\\\___\///____/\\\__\//\\\_____\/\\\____   
                    _\/\\\__\/\\\__\/\\\__\//\\\_________\//\\\__/\\\___\/\\\___\/\\\_____\/\\\_/\\___\/\\\__________\//\\\__/\\\______\/\\\____  
                     _\/\\\__\/\\\__\/\\\___\///\\\\\\\\___\///\\\\\/____\/\\\___\/\\\_____\//\\\\\____\/\\\___________\///\\\\\/_____/\\\\\\\\\_ 
                      _\///___\///___\///______\////////______\/////______\///____\///_______\/////_____\///______________\/////______\/////////__"

        PS0="\n"

        textclear(){
        tput rc
        tput ed
        }

        tput sc

        # echo "Which directory would you want to install the server? *eks: /home/minecraft/server"
        # read DIR

        DIR=$(pwd)

        textclear
        echo "Creating settings-file"
        cd $DIR
        touch server.settings

        textclear
        echo "Which version of minecraft would you like? {1.16.4|1.15|1.14|custom|etc}"
        read VERSION

        textclear
        echo "How much ram would you like your server to have?"
        read RAM

        textclear
        echo "Whats the maximun amount of players you want on your server?"
        read PLAYERS

        textclear
        echo "Port (default:25565)"
        read PORT

        textclear
        echo "Seed *can be left empty"
        read SEED

        textclear
        echo "Gamemode (survival, adventure, creative)"
        read GAMEMODE

        textclear
        echo "Difficulty (easy, normal, hard, peaceful)"
        read DIFFICULTY

        textclear
        echo "Whitelist (y/n) *if y then remember to add yourself to the whitelist"
        read WHITELIST

        textclear
        echo "Autoupdate (y/n) *only works with latest or snapshot"
        read AUTOUPDATE

        # textclear
        # echo "Do you want to install Java 11 with OpenJ9? (y/n)"
        # read JAVA

        textclear
        if [[ $JAVA == "y" || $JAVA == "Y" ]]; then
                echo "[INFO] Downloading Java 11 with OpenJ9"
                tput sc
                mkdir bin
                cd bin/
                wget -O java.tar.gz https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.9%2B11_openj9-0.23.0/OpenJDK11U-jdk_x64_linux_openj9_11.0.9_11_openj9-0.23.0.tar.gz
                tar xzf java.tar.gz
                sudo export PATH=$PWD/jdk-11.0.9+11/bin:$PATH
                textclear
                echo "[INFO] Java 11 with OpenJ9 installed"
                tput sc

        else
                textclear
                echo "[WARN] Java 11 and OpenJ9 will not be installed."
                tput sc

        fi

        cd $DIR

        if [[ $VERSION == "latest" || $VERSION == "LATEST" ]]; then
                MC_VERSION_URLS=$(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | python -c 'import json,sys,base64;obj=json.load(sys.stdin); print obj["versions"][1]["url"]') 
                MC_LATEST_RELEASE=$(curl -s $MC_VERSION_URLS | python -c 'import json,sys,base64;obj=json.load(sys.stdin); print obj["downloads"]["server"]["url"]')                         
                wget -O server.jar $MC_LATEST_RELEASE

        elif [[ $VERSION == "snapshot" || $VERSION == "SNAPSHOT" ]]; then
                MC_VERSION_URLS=$(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | python -c 'import json,sys,base64;obj=json.load(sys.stdin); print obj["versions"][0]["url"]') 
                MC_LATEST_SNAPSHOT=$(curl -s $MC_VERSION_URLS | python -c 'import json,sys,base64;obj=json.load(sys.stdin); print obj["downloads"]["server"]["url"]')                         
                wget -O server.jar $MC_LATEST_SNAPSHOT
        
        
        elif [[ $VERSION == "custom" || $VERSION == "CUSTOM" ]]; then
                echo "[WARN] Will not download jarfile"
                $JAR=server.jar

        else
                
                echo "[INFO] Which fork of spigot? {papermc|purpur}"
                read FORK

                if [[ $FORK == "purpur" || $FORK == "PURPUR" ]]; then
                        
                        echo "[INFO] Downloading jar-file from PURPUR.PL3X.NET"
                        tput sc
                        wget -O server.jar https://purpur.pl3x.net/api/v1/purpur/$VERSION/latest/download
                        textclear
                        echo "[INFO] Jarfile downloaded"
                        $JAR=server.jar
                        tput sc

                elif [[ $FORK == "papermc" || $FORK == "papermc" ]]; then
                        echo "[INFO] Downloading jar-file from PAPERMC.IO"
                        tput sc
                        wget -O server.jar https://papermc.io/api/v1/paper/$VERSION/latest/download
                        textclear
                        echo "[INFO] Jarfile downloaded"
                        $JAR=server.jar
                        tput sc

                else
                        echo "[INFO] Downloading jar-file from PAPERMC.IO"
                        tput sc
                        wget -O server.jar https://papermc.io/api/v1/paper/$VERSION/latest/download
                        textclear
                        echo "[INFO] Jarfile downloaded"
                        $JAR=server.jar
                        tput sc
                fi

        fi

        echo "[INFO] Downloading scripts from github"
        tput sc

        cd $DIR
        sudo wget -O server https://gist.githubusercontent.com/z3orc/927accc63953fa1f9c69937c277208b2/raw/mcontrol.sh
        sudo chmod +x server

        cd $DIR
        textclear

        echo "[INFO] Saving settings to server.properties"

        echo max-players=$PLAYERS >> server.properties
        echo gamemode=$GAMEMODE >> server.properties
        echo server-port=$PORT >> server.properties
        echo level-seed=$SEED >> server.properties

        if [[ $WHITELIST == "y" || $WHITELIST == "Y" ]]; then
                echo white-list=true >> server.properties
                echo "[WARN] Whitelist value changed"

        else
                echo "[WARN] Whitelist value not changed"

        fi

        echo "[INFO] Writing settings to server.settings"

        echo DIR=$DIR >> server.settings
        echo JAR=$JAR >> server.settings
        echo VERSION=$VERSION >> server.settings
        echo RAM=$RAM >> server.settings
        echo PLAYERS=$PLAYERS >> server.settings
        echo PORT=$PORT >> server.settings
        echo SEED=$SEED >> server.settings
        echo GAMEMODE=$GAMEMODE >> server.settings
        echo DIFFICULTY=$DIFFICULTY >> server.settings
        echo WHITELIST=$WHITELIST >> server.settings

        if [[ $AUTOUPDATE == "y" || $AUTOUPDATE == "Y" && "$VERSION" == "latest" || "$VERSION" == "snapshot" ]]; then
                echo AUTOUPDATE=true >> server.settings
                echo "[WARN] Autoupdate enabled"

        else
                echo "[WARN] Autoupdate disabled"

        fi


        #Minecraft EULA 
        echo "[WARN] You must accept the minecraft EULA before the server can start."
        echo "[WARN] By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula)."
        tput sc
        echo "[INFO] Do you accept the Minecraft EULA {TRUE|FALSE}"
        read EULA
        textclear

        if [[ $EULA == "TRUE" || $EULA == "true" ]]; then
                textclear
                echo "[INFO] You have now accepted the Minecraft EULA"
                echo eula=true >> eula.txt
                sleep 2
                exit 0
        else
                echo "[WARN] Minecraft EULA not accepted"
                sleep 2
                exit
        fi
}

run(){
        #!/bin/bash    
        source server.settings
        echo "[INFO] Starting server using TMUX."
        tmux new -d -s minecraft java -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar server.jar nogui
        tmux new -d -s watcher mcontrol watcher
}

run_no_watcher(){
        #!/bin/bash    
        source server.settings
        echo "[INFO] Starting server using TMUX."
        tmux new -d -s minecraft java -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar server.jar nogui
}  

restart(){
        #!/bin/bash  
        source server.settings
        echo "[WARN] Restarting down server in 5 seconds."
        tmux kill-session -t watcher
        tmux send-keys -t minecraft "say Server is restarting in 5 seconds" ENTER
        sleep 5

        tmux send-keys -t minecraft "save-all" ENTER
        tmux send-keys -t minecraft "stop" ENTER
        echo "[INFO] Server stopped."

        sleep 3
        tmux new -d -s watcher mcontrol watcher
        echo "[INFO] Server has restarted."
}

stop(){
        #!/bin/bash  
        source server.settings
        echo "[WARN] Shutting down server in 6 seconds."
        tmux kill-session -t watcher

        tmux send-keys -t minecraft "say Server is shutting down in 6 seconds" ENTER
        tmux send-keys -t minecraft "save-all" ENTER
        sleep 6

        echo "[INFO] Server is now shutting down."

        tmux send-keys -t minecraft "stop" ENTER

        echo "[INFO] Server has stopped..."

        sleep 2
}

resume(){
        tmux a -t minecraft
}

hourly(){
        #!/bin/bash
        cd "$(dirname "$0")";  
        source server.settings

        tmux has-session -t minecraft 2>/dev/null

        if [ $? != 0 ]; then
        echo "[ERROR] Server is NOT running"
        exit
        else
        echo "[INFO] Server running."

        fi

        echo "[INFO] Starting backups process"
        echo "[WARN] This might cause server instability"
        tmux send-keys -t minecraft 'say Running automated backup, server going read-only' ENTER
        tmux send-keys -t minecraft 'save-off' ENTER
        tmux send-keys -t minecraft 'save-all' ENTER
        sleep 5
        echo "[INFO] World backup complete!"

        echo "[INFO] Compressing backup"
        mkdir $DIR/hbackups
        tar -cpvzf $DIR/hbackups/world$(date +"%F@%R").tar.gz world
        tar -cpvzf $DIR/hbackups/world_nether$(date +"%F@%R").tar.gz world_nether
        tar -cpvzf $DIR/hbackups/world_the_end$(date +"%F@%R").tar.gz world_the_end
        echo "[INFO] Backup compressed"

        echo "[INFO] Removing old backups"
        find $DIR/hbackups/* -mtime +0 -exec rm -rf {} \;
        echo "[INFO] Old backups removed"

        tmux send-keys -t minecraft 'save-on' ENTER
        tmux send-keys -t minecraft 'say Backup completed' ENTER
        echo "[INFO] Backup process complete."

        #tar --force-local -xvf world(Y:M:D:H:M).tar.gz to unzip tarfile

}

daily(){
        #!/bin/bash
        cd "$(dirname "$0")";  
        source server.settings

        tmux has-session -t minecraft 2>/dev/null

        if [ $? != 0 ]; then
                echo "[ERROR] Server is NOT running"
                exit
        else
                echo "[INFO] Server running."

        fi

        echo "[INFO] Starting backups process"
        echo "[WARN] This might cause server instability"
        tmux send-keys -t minecraft 'say Running automated backup, server going read-only' ENTER
        tmux send-keys -t minecraft 'save-off' ENTER
        tmux send-keys -t minecraft 'save-all' ENTER
        sleep 5
        echo "[INFO] World backup complete!"

        echo "[INFO] Compressing backup"
        mkdir $DIR/dbackups
        tar -cpvzf $DIR/dbackups/world$(date +"%F@%R").tar.gz world
        tar -cpvzf $DIR/dbackups/world_nether$(date +"%F@%R").tar.gz world_nether
        tar -cpvzf $DIR/dbackups/world_the_end$(date +"%F@%R").tar.gz world_the_end
        echo "[INFO] Backup compressed"

        echo "[INFO] Removing old backups"
        find $DIR/dbackups/* -mtime +7 -exec rm -rf {} \;
        echo "[INFO] Old backups removed"

        tmux send-keys -t minecraft 'save-on' ENTER
        tmux send-keys -t minecraft 'say Backup completed' ENTER
        echo "[INFO] Backup process complete."

        #tar --force-local -xvf world(Y:M:D:H:M).tar.gz to unzip tarfile

}

update(){
#!/bin/bash

source server.settings
echo "[INFO] Checking latest verions"


# Gets the current version form the jar-file
OLDVERSION=$(unzip -p server.jar version.json | grep "name" | cut -d\" -f4)

# Downloads manifest and finds the latest version.
wget -qN https://launchermeta.mojang.com/mc/game/version_manifest.json
NEWVERSION=$(sed -n -e '/\"latest\"/,/}/ s/.*\"snapshot\": \"\([^\"]*\)\".*/\1/p' < version_manifest.json)

echo "[INFO] Current version = $OLDVERSION"
echo "[INFO] Latest version = $NEWVERSION"

# Checks if user wants to use update
if [[ "$AUTOUPDATE" == "true" || "$AUTOUPDATE" == "TRUE"  ]]; then
        echo "[INFO] Autoupdate enabled"
else
        echo "[ERROR] Autoupdate NOT enabled"

fi


#Checks if the server is running.
tmux has-session -t minecraft 2>/dev/null

if [ $? = 0 ]; then
        echo "[INFO] Server running."
        
else
        echo "[ERROR] Server is NOT running"
        exit

fi

#Checks if the new version is the same as the old version
if [ "$OLDVERSION" = "$NEWVERSION" ]; then

    echo "[INFO] Server is running latest version!"
    rm version_manifest.json
    exit


else
   
        if [ $VERSION="snapshot" ]; then
                if grep -q "w" <<< "$NEWVERSION"; then
                echo "[INFO] Server compatible with latest snapshot version"

                else
                echo "[ERROR] Server not compatible with latest snapshot version"
                exit
                \n fi
        fi

fi

        echo "[INFO] Server is not running latest version, updating now!"

        echo "[INFO] Updating server jar-file, this might take a moment."
        mcontrol stop
        mcontrol hourlybackup

        mkdir .update
        cp server.jar .update
        cp -r world .update

        rm server.jar

        if [[ $VERSION == "latest" || $VERSION == "LATEST" ]]; then
        MC_VERSION_URLS=$(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | python -c 'import json,sys,base64;obj=json.load(sys.stdin); print obj["versions"][1]["url"]') 

        MC_LATEST_RELEASE=$(curl -s $MC_VERSION_URLS | python -c 'import json,sys,base64;obj=json.load(sys.stdin); print obj["downloads"]["server"]["url"]')                         

        wget -O server.jar $MC_LATEST_RELEASE

        # NEWVERSION=$(unzip -p server.jar version.json | grep "name" | cut -d\" -f4)

        # sed -i -e 's/VERSION=$VERSION.*/VERSION=$NEWVERSION /g' $DIR/server.settings


        elif [[ $VERSION == "snapshot" || $VERSION == "SNAPSHOT" ]]; then
        MC_VERSION_URLS=$(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | python -c 'import json,sys,base64;obj=json.load(sys.stdin); print obj["versions"][0]["url"]') 

        MC_LATEST_SNAPSHOT=$(curl -s $MC_VERSION_URLS | python -c 'import json,sys,base64;obj=json.load(sys.stdin); print obj["downloads"]["server"]["url"]')                         

        wget -O server.jar $MC_LATEST_SNAPSHOT

        # NEWVERSION=$(unzip -p server.jar version.json | grep "name" | cut -d\" -f4)

        # sed -i -e 's/VERSION=$VERSION.*/VERSION=$NEWVERSION /g' $DIR/server.settings

        fi

        rm version_manifest.json

fi

mcontrol run_no_watcher

sleep 18

tmux has-session -t minecraft 2>/dev/null

        if [ $? != 0 ]; then
                echo "[ERROR] Update failed, reverting changes"
                rm server.jar
                rm -rf world
                cd $DIR/.update
                cp -r world $DIR
                cp server.jar $DIR
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
}

revert(){
        #!/bin/bash
        source server.settings
        echo "[WARN] Are you sure you want to revert the update? This will only work if the server.jar file has been updated by the update script."
        echo "y/n"
        read input
        if [[ "$input" = "y" || "$input" = "Y" ]]; then
                rm -rf world
                rm server.jar

                cd $DIR/.update
                cp -r world $DIR
                cp server.jar $DIR
        else
        echo "[INFO] Revert cancelled"

        fi

}

watcher(){
        #!/bin/bash

        while :
        do
        
        tmux has-session -t minecraft 2>/dev/null

        if [ $? != 0 ]; then
                echo "[ERROR] Server is not running"
                mcontrol run_no_watcher
                sleep 120
        else
                echo "[INFO] Server running."
                sleep 60

        fi
        done
}

reload(){
        DIR=$(pwd)
        cd /usr/sbin; sudo rm mcontrol; sudo wget -O mcontrol https://gist.githubusercontent.com/z3orc/927accc63953fa1f9c69937c277208b2/raw/mcontrol.sh; sudo chmod +x mcontrol
        cd $DIR
}

case "$1" in
        install)
                install
                ;;
        run)
                run
                ;;
        restart)
                restart
                ;;
        stop)
                stop
                ;;
        update)
                update
                ;;
        daily)
                daily
                ;;
        hourly)
                hourly
                ;;
        watcher)
                watcher
                ;;
        run_no_watcher)
                run_no_watcher
                ;;
        resume)
                resume
                ;;
        reload)
                reload
                ;;
        revert)
                revert
                ;;
        *)
                echo "Usage: $0 {run|restart|stop|resume|update|revert|install}"
esac