#!/bin/bash

function isPortBinded {
    STATUS=$(nc -z 127.0.0.1 $1 && echo "USE" || echo "FREE")

    if [[ $STATUS == "USE" ]]; then
        true
        return
    else
        false
        return
    fi
}

function isSessionRunning {
    tmux has-session -t $1 2>/dev/null

    if [[ $? = 0 ]]; then
        true
        return
    else
        false
        return
    fi
}

function isServerRunning {
    if doesFileExist "$DIR/.offline"; then
        false
        return
    else
        true
        return
    fi
}

doesFileExist(){
    file=$1
    if test -f "$file"; then
        true
        return
    else
        false
        return
    fi
}

doesFolderExist(){
    folder=$1
    if test -d "$folder"; then
        true
        return
    else
        false
        return
    fi
}

function setServerState {
    source ender.config

    if [ $1 = "offline" ]; then
        touch $DIR/.offline
    elif [ $1 = "online" ]; then
        rm -rf $DIR/.offline
    else 
        echo "Unknown argument!"
    fi
}

function logGood {
    echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] $1"
}

function logNeutral {
    echo "[  $(tput setaf 3).....$(tput sgr 0)  ] $1"
}

function logBad {
    echo "[  $(tput setaf 1)ERROR$(tput sgr 0)  ] $1 "
}

function haltServer {
    tmux send-keys -t minecraft-$ID "stop" ENTER
}

function killServer {
    tmux kill-session -t $1 2>/dev/null
}

function bootServer {
    tmux new -d -s $1 ./ender.sh bootServerLoop
}

function bootServerLoop {
    source ender.config

    cd $DIR/serverfiles || exit

    i=0
    while [ $i -lt 4 ] 
    do
            rm -rf $DIR/.offline
            java -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar $JAR nogui
            touch $DIR/.offline
            sleep 120;
            i=$[$i+1]
    done
}

function save {
    logNeutral "Starting backups process and saving world. This might cause server instability"

    sleep 10
    
    logGood "World save complete!"

    logNeutral "Running rdiff-backup."
    nice -n 10 rdiff-backup $DIR/serverfiles $DIR/backups 2>/dev/null
    logGood "rdiff-backup complete."

    logNeutral "Removing old backups."
    nice -n 10 rdiff-backup --force --remove-older-than 2W $DIR/backups 2>/dev/null
    logGood "Old backups removed."

    logGood "Backup process complete."
}

# Functions for controlling the server

textclear(){
    tput rc
    tput ed
}

setup() {
    #!/bin/bash
    
    clear

    # echo "                    [MControl]"
    # echo "----------------------------------------------------"

    # echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Gathering system information"

    # distro=$(lsb_release -i | cut -f 2-)

    # memTotal=$(grep MemTotal /proc/meminfo | awk '{print $2 / 1024}')

    # echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] Gathering complete!"


    # echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Checking compatibility"

    # if [[ $distro != [Uu][Bb][Uu][Nn][Tt][Uu] || $distro != [Cu][Ee][Nn][Tt][Oo][Ss] || $distro != [Aa][Rr][Cc][Hh] ]]; then 
    #         echo "[  $(tput setaf 1)ERROR$(tput sgr 0)  ] MControl only works with Ubuntu, CentOS and Arch!"
    #         sleep 6
    #         exit

    # fi

    # if (( "${memTotal%.*}" < "999" )); then
    #         echo "[  $(tput setaf 1)ERROR$(tput sgr 0)  ] Your machine does not have enough ram to run a minecraft server. Need atleast 1GB of memory"
    #         sleep 6
    #         exit

    # fi

    # echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] Compatibility checked!"

    
    # sleep 1


    # echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Installing packages."
    
    # if [[ "$distro" = [Uu][Bb][Uu][Nn][Tt][Uu] ]]; then 
    #         sudo apt install -y tmux unzip curl wget tar nano
    # elif [[ "$distro" = [Cu][Ee][Nn][Tt][Oo][Ss] ]]; then 
    #         sudo yum install -y tmux unzip curl wget tar nano
    # elif [[ "$distro" = [Aa][Rr][Cc][Hh] ]]; then 
    #         yes | pacman -S jre-openjdk-headless tmux curl unzip tar wget nano gnu-netcat lsb-release
    #         useradd -m minecraft
    # fi

    # sleep 1

    DIR=$PWD

    clear

    echo "              [Minecraft server setup]"
    echo "----------------------------------------------------"

    rm -rf $DIR/ender.config 2>/dev/null
    touch $DIR/ender.config

    mkdir $DIR/serverfiles 2>/dev/null && mkdir $DIR/backups 2>/dev/null && mkdir $DIR/bin 2>/dev/null
    
    cd serverfiles 2>/dev/null

    rm -rf server.properties 2>/dev/null
    rm -rf eula.txt 2>/dev/null

    touch server.properties 2>/dev/null
    touch eula.txt 2>/dev/null

    IFS= read -r -p "Enter server version: " VERSION

    IFS= read -r -p "Enter server flavour (vanilla, paper, purpur, fabric): " FLAVOUR

    IFS= read -r -p "Enter the amount of ram: " RAM

    IFS= read -r -p "Enter the maximum playercount: " PLAYER_COUNT

    IFS= read -r -p "World seed (can be left empty) : " WORLD_SEED

    IFS= read -r -p "Enter gamemode (survival, adventure, creative): " GAMEMODE

    IFS= read -r -p "Enter difficulty (easy, normal, hard, peaceful): " DIFFICULTY

    IFS= read -r -p "Enter port (*25565): " PORT

    IFS= read -r -p "Whitelist (y/n): " WHITELIST

    tput sc

    echo "You must accept the minecraft EULA before the server can start. By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula)."

    IFS= read -r -p "Do you accept the Minecraft EULA (TRUE/FALSE) : " EULA

    if [[ $EULA == "TRUE" || $EULA == "true" ]]; then
            textclear
            echo "Minecraft EULA (true/false): true"
            echo eula=true >> eula.txt
            sleep 2
    else
            textclear
            echo "[  $(tput setaf 1)ERROR$(tput sgr 0)  ] Minecraft EULA not accepted"
            sleep 2
            exit 0
    fi

    RCONPASS=$(openssl rand -base64 14)
    ID=$RANDOM

    tput sc

    #Writings settings to settingsfile

    echo DIR="${DIR// /}" >> $DIR/ender.config | xargs
    # echo VERSION="${VERSION// /}" >> $DIR/ender.config | xargs
    echo FLAVOUR="${FLAVOUR// /}" >> $DIR/ender.config | xargs
    echo RAM="${RAM// /}" >> $DIR/ender.config | xargs
    echo PLAYER_COUNT="${PLAYER_COUNT// /}" >> $DIR/ender.config | xargs
    echo WORLD_SEED="${WORLD_SEED// /}" >> $DIR/ender.config | xargs
    echo PORT="${PORT// /}" >> $DIR/.ender.config | xargs
    echo GAMEMODE="${GAMEMODE// /}" >> $DIR/ender.config | xargs
    echo DIFFICULTY="${DIFFICULTY// /}" >> $DIR/ender.config | xargs
    echo PORT="${PORT// /}" >> $DIR/ender.config | xargs
    echo WHITELIST="${WHITELIST// /}" >> $DIR/ender.config | xargs
    echo JAR="server.jar" >> $DIR/ender.config | xargs
    # echo RCONPASS="${RCONPASS// /}" >> $DIR/ender.config | xargs
    echo ID="${ID// /}" >> $DIR/ender.config | xargs

    #Writing certain settings to server.properties

    echo max-players="${PLAYER_COUNT// /}" >> server.properties | xargs
    echo level-seed="${WORLD_SEED// /}" >> server.properties | xargs
    echo gamemode="${GAMEMODE// /}" >> server.properties | xargs
    echo difficulty="${DIFFICULTY// /}" >> server.properties | xargs
    # echo enable-rcon="true" >> $DIR/serverfiles/server.properties | xargs
    # echo rcon.password="${RCONPASS// /}" >> $DIR/serverfiles/server.properties | xargs
    
    if [[ $WHITELIST == "y" || $WHITELIST == "Y" ]]; then
        echo white-list="true" >> server.properties | xargs
    fi

    if [[ $FLAVOUR == "fabric" ]]; then
        echo JAR="fabric-server-launch.jar" >> $DIR/ender.config | xargs
    else
        echo JAR="server.jar" >> $DIR/ender.config | xargs
    fi

    textclear


    echo "            [Downloading dependencies]"
    echo "----------------------------------------------------"
    sleep 2

    if [[ $FLAVOUR == "fabric" ]]; then
        wget -O fabric-installer.jar 'https://maven.fabricmc.net/net/fabricmc/fabric-installer/0.9.0/fabric-installer-0.9.0.jar'
        mv fabric-installer.jar $DIR/bin/
        java -jar $DIR/bin/fabric-installer.jar server -downloadMinecraft -snapshot -dir "$DIR/serverfiles" -mcversion "$VERSION"
    else
        echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Downloading server-jar VERSION=$VERSION, FLAVOUR=$FLAVOUR."
        tput sc
        cd $DIR/serverfiles
        curl -L -o server.jar 'https://mcdl.z3orc.com/'$FLAVOUR'/'$VERSION'/download' --progress-bar
        textclear
        echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] Server-jar downloaded!"
    fi



    cd $DIR/bin

    # echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Downloading and unpacking java."

    # tput sc

    # curl -L -o openjdk.tar.gz 'https://github.com/AdoptOpenJDK/openjdk16-binaries/releases/download/jdk-16.0.1%2B9/OpenJDK16U-jre_x64_linux_hotspot_16.0.1_9.tar.gz' --progress-bar

    # tar -xzf openjdk.tar.gz

    # rm openjdk.tar.gz

    # textclear

    # echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] Java downloaded and unpacked!"

    # echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Downloading and unpacking mcrcon."

    # tput sc

    # curl -L -o mcrcon.tar.gz "https://github.com/Tiiffi/mcrcon/releases/download/v0.7.1/mcrcon-0.7.1-linux-x86-64.tar.gz" --progress-bar

    # tar -xvf mcrcon.tar.gz

    # rm -rf mcrcon.tar.gz

    # mv $DIR/bin/mcrcon-0.7.1-linux-x86-64/mcrcon $DIR/bin

    # rm  mcrcon-0.7.1-linux-x86-64

    # textclear

    # echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] mcrcon downloaded and unpacked!"


    sleep 2


    # echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Downloading lazymc"

    # tput sc

    # curl -L -o lazymc "https://github.com/timvisee/lazymc/releases/download/v0.1.0/lazymc-v0.1.0-linux-x64" --progress-bar

    # chmox u+a lazymc

    # textclear

    # echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] lazymc downloaded."


    sleep 2


    echo "             [Validating installation]"
    echo "----------------------------------------------------"

    echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Validating settings file"
    FILE=$DIR/ender.config
    if test -f "$FILE"; then
            echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] Settings file validated"
    else
            echo "[  $(tput setaf 1)ERROR$(tput sgr 0)  ] Could not validate settings file, try the setup again."
            exit
    fi


    echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Validating server.jar download"
    FILE=$DIR/serverfiles/server.jar
    if test -f "$FILE"; then
            echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] Server.jar validated"
    else
            echo "[  $(tput setaf 1)ERROR$(tput sgr 0)  ] Could not validate server.jar, try the setup again."
            exit
    fi

    # echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Validating Java download"
    # FILE=$DIR/bin/jdk-16.0.1+9-jre
    # if test -d "$FILE"; then
    #         echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] Java validated"
    # else
    #         echo "[  $(tput setaf 1)ERROR$(tput sgr 0)  ] Could not validate Java, try the setup again."
    #         exit
    # fi

    # echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Validating mcrcon download"
    # FILE=$DIR/bin/mcrcon
    # if test -f "$FILE"; then
    #         echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] mcrcon validated"
    # else
    #         echo "[  $(tput setaf 1)ERROR$(tput sgr 0)  ] Could not validate mcrcon, try the setup again."
    #         exit
    # fi

    echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Validating ender"
    FILE=$DIR/ender.sh
    if test -f "$FILE"; then
            echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] ender validated"
    else
            echo "[  $(tput setaf 1)ERROR$(tput sgr 0)  ] Could not validate ender, try the setup again."
            exit
    fi

    # echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Validating lazymc"
    # FILE=$DIR/lazymc
    # if test -f "$FILE"; then
    #         echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] lazymc validated"
    # else
    #         echo "[  $(tput setaf 1)ERROR$(tput sgr 0)  ] Could not validate lazymc, try the setup again."
    #         exit
    # fi


    echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Validating server integrity"
    
    cd $DIR

    tput sc

    ./ender.sh start

    sleep 15

    textclear
    
    STATUS=$(nc -z 127.0.0.1 25565 && echo "USE" || echo "FREE")
    tmux has-session -t minecraft-$ID 2>/dev/null

    if isPortBinded $PORT && isSessionRunning minecraft-$ID && isServerRunning; then
        echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] Server integrity validated"
        exit
    else
        echo "[  $(tput setaf 1)ERROR$(tput sgr 0)  ] Could not validate server integrity, server did not boot."
        exit

    fi
}

function start {
    #!/bin/bash
    source ender.config

    if [[ $1 = "" ]]; then
        logNeutral "Starting server!"

        bootServer minecraft-$ID

        i=0
        while [ $i -lt 60 ];
        do
            if isPortBinded $PORT && isSessionRunning minecraft-$ID && isServerRunning; then
                logGood "Server booted successfully"
                setServerState online
                break
            else
                echo "..."
                i=$[$i+1]
                sleep 2
            fi
        done

        if ! isPortBinded $PORT || ! isServerRunning || ! isSessionRunning minecraft-$ID; then
        logBad "Could not boot server."
        setServerState offline
        exit 1
        fi 

    elif [[ $1 = "lazymc" ]]; then
        tmux new -d -s minecraft-$ID $DIR/bin/lazymc/lazymc start
    fi
}

function stop {
    #!/bin/bash

    source ender.config

    if isPortBinded $PORT || isServerRunning || isSessionRunning minecraft-$ID; then
        logNeutral "Stopping server."

        haltServer

        i=0
        while [[ $i -lt 60 ]];
        do
            if ! isPortBinded $PORT && ! isServerRunning; then
                logGood "Server halted successfully"
                killServer minecraft-$ID
                setServerState offline
                if ! isSessionRunning minecraft-$ID; then
                    break
                fi
            else
                echo "..."
                i=$[$i+1]
                sleep 2
            fi
        done

        if isPortBinded $PORT || isServerRunning || isSessionRunning minecraft-$ID; then
            logBad "Could not halt server."
            setServerState online
            exit 1
        fi
    else
        logBad "Could not perform request. Server not running."
    fi

    
}

function backup {
    #!/bin/bash

    source ender.config

    if [[ $1 = "list" ]]; then
            nice -n 10 rdiff-backup --list-increments $DIR/backups
    elif [[ $1 = "revert" ]]; then
            rdiff-backup -r now $DIR/backups $DIR/serverfiles
    else
        if isPortBinded $PORT && isSessionRunning minecraft-$ID && isServerRunning; then
            stop && save && start
        else
            save && start
        fi
    fi

}

function upgrade {
    #!/bin/bash

    source ender.config

        cd $DIR
        clear

        echo "             [Upgrade server version]"
        echo "----------------------------------------------------"

        if [[ -z "$1" ]]; then
                IFS= read -r -p "Enter new server version: " NEW_VERSION
        else
                NEW_VERSION="$1"
        fi

        logNeutral "Backing up serverfiles and stopping server... This might take some time."

        stop && save

        if ! isSessionRunning; then
            logNeutral "Removing old server.jar"
            cd $DIR/serverfiles

            if [[ $FLAVOUR == "fabric" ]]; then
                rm -rf server.jar
                rm -rf fabric-server-launch.jar
                rm -rf oldMods
                mv mods oldMods
            else
                rm -rf server.jar
            fi

            if ! doesFileExist "$DIR/serverfiles/server.jar"; then
                logGood "Server.jar successfully removed!"
            else
                logBad "Could not remove server.jar. Halting upgrade!"
                exit 1
            fi

            logNeutral "Downloading new server.jar for version $NEW_VERSION"

            if [[ $FLAVOUR == "fabric" ]]; then
                java -jar $DIR/bin/fabric-installer.jar server -downloadMinecraft -snapshot -dir "$DIR/serverfiles" -mcversion "$NEW_VERSION"
            else
                curl -L -o server.jar 'https://mcdl.z3orc.com/'$FLAVOUR'/'$VERSION'/download' --progress-bar
            fi

            
            if doesFileExist "$DIR/serverfiles/server.jar"; then
                logGood "New server.jar successfully downloaded"
            else
                logBad "Could not download new server.jar. Halting upgrade!"
                exit 1
            fi
        else
            logBad "Could not halt server. Halting upgrade!"
            exit 1
        fi

        logNeutral "Verifying server integrity"
        cd $DIR
        start
        if isPortBinded $PORT && isSessionRunning minecraft-$ID && isServerRunning; then
            logGood "Server integrity has been successfully verified!" 
            exit 0
        else
            logBad "Could not validate server integrity."
        fi

        logNeutral "Reverting changes."
        killServer minecraft-$ID
        cd $DIR
        cp -r serverfiles corrupt-serverfiles
        rm -rf serverfiles
        rdiff-backup -r now $DIR/backups $DIR/serverfiles
        
        logNeutral "Validating server integrity."

        tput sc
        start
        textclear
        if isPortBinded $PORT && isSessionRunning minecraft-$ID && isServerRunning; then
            logGood "Server integrity has been successfully verified and changes has been reverted!" 
            exit 0
        else
            logBad "Could not repair server."
            exit 1
        fi

}

function console {
    source ender.config
    tmux a -t minecraft-$ID
}

case "$1" in
        setup)
                setup
                ;;
        start)
                start "${2}"
                ;;
        bootServerLoop)
                bootServerLoop
                ;;
        stop)
                stop
                ;;
        backup)
                backup "${2}"
                ;;
        upgrade)
                upgrade "${2}"
                ;;
        console)
                console
                ;;
        *)
                echo "Usage: $0 {start|resume|stop|upgrade|backup|setup}"
esac