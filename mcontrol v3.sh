#!/bin/bash

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

        rm $DIR/mcontrol.config 2>/dev/null
        touch $DIR/mcontrol.config

        mkdir $DIR/serverfiles 2>/dev/null && mkdir $DIR/backups 2>/dev/null && mkdir $DIR/bin 2>/dev/null
        
        cd serverfiles 2>/dev/null

        rm server.properties 2>/dev/null
        rm eula.txt 2>/dev/null

        touch server.properties 2>/dev/null
        touch eula.txt 2>/dev/null

        IFS= read -r -p "Enter server version: " VERSION

        IFS= read -r -p "Enter server flavour (vanilla, paper, purpur): " FLAVOUR

        IFS= read -r -p "Enter the amount of ram: " RAM

        IFS= read -r -p "Enter the maximum playercount: " PLAYER_COUNT

        IFS= read -r -p "World seed (can be left empty) : " WORLD_SEED

        IFS= read -r -p "Enter gamemode (survival, adventure, creative): " GAMEMODE

        IFS= read -r -p "Enter difficulty (easy, normal, hard, peaceful): " DIFFICULTY

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
        PORT=25565

        tput sc

        #Writings settings to settingsfile

        echo DIR="${DIR// /}" >> $DIR/mcontrol.config | xargs
        # echo VERSION="${VERSION// /}" >> $DIR/mcontrol.config | xargs
        echo FLAVOUR="${FLAVOUR// /}" >> $DIR/mcontrol.config | xargs
        echo RAM="${RAM// /}" >> $DIR/mcontrol.config | xargs
        echo PLAYER_COUNT="${PLAYER_COUNT// /}" >> $DIR/mcontrol.config | xargs
        echo WORLD_SEED="${WORLD_SEED// /}" >> $DIR/mcontrol.config | xargs
        echo PORT="${PORT// /}" >> $DIR/.mcontrol.config | xargs
        echo GAMEMODE="${GAMEMODE// /}" >> $DIR/mcontrol.config | xargs
        echo DIFFICULTY="${DIFFICULTY// /}" >> $DIR/mcontrol.config | xargs
        echo WHITELIST="${WHITELIST// /}" >> $DIR/mcontrol.config | xargs
        echo JAR="server.jar" >> $DIR/mcontrol.config | xargs
        echo RCONPASS="${RCONPASS// /}" >> $DIR/mcontrol.config | xargs

        #Writing certain settings to server.properties

        echo max-players="${PLAYER_COUNT// /}" >> server.properties | xargs
        echo level-seed="${WORLD_SEED// /}" >> server.properties | xargs
        echo gamemode="${GAMEMODE// /}" >> server.properties | xargs
        echo difficulty="${DIFFICULTY// /}" >> server.properties | xargs
        echo enable-rcon="true" >> $DIR/serverfiles/server.properties | xargs
        echo rcon.password="${RCONPASS// /}" >> $DIR/serverfiles/server.properties | xargs
        
        if [[ $WHITELIST == "y" || $WHITELIST == "Y" ]]; then
            echo white-list="true" >> server.properties | xargs
        fi

        textclear


        echo "            [Downloading dependencies]"
        echo "----------------------------------------------------"
        sleep 2

        echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Downloading server-jar VERSION=$VERSION, FLAVOUR=$FLAVOUR."

        tput sc

        cd $DIR/serverfiles

        curl -L -o server.jar 'https://mcdl.z3orc.com/get?version='$VERSION'&flavour='$FLAVOUR --progress-bar

        textclear

        echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] Server-jar downloaded!"

        cd $DIR/bin

        # echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Downloading and unpacking java."

        # tput sc

        # curl -L -o openjdk.tar.gz 'https://github.com/AdoptOpenJDK/openjdk16-binaries/releases/download/jdk-16.0.1%2B9/OpenJDK16U-jre_x64_linux_hotspot_16.0.1_9.tar.gz' --progress-bar

        # tar -xzf openjdk.tar.gz

        # rm openjdk.tar.gz

        # textclear

        # echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] Java downloaded and unpacked!"

        echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Downloading and unpacking mcrcon."

        tput sc

        curl -L -o mcrcon.tar.gz "https://github.com/Tiiffi/mcrcon/releases/download/v0.7.1/mcrcon-0.7.1-linux-x86-64.tar.gz" --progress-bar

        tar -xvf mcrcon.tar.gz

        rm mcrcon.tar.gz

        mv $DIR/bin/mcrcon-0.7.1-linux-x86-64/mcrcon $DIR/bin

        rm -r mcrcon-0.7.1-linux-x86-64

        textclear

        echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] mcrcon downloaded and unpacked!"


        sleep 2


        echo "             [Validating installation]"
        echo "----------------------------------------------------"

        echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Validating settings file"
        FILE=$DIR/mcontrol.config
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

        echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Validating Java download"
        FILE=$DIR/bin/jdk-16.0.1+9-jre
        if test -d "$FILE"; then
                echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] Java validated"
        else
                echo "[  $(tput setaf 1)ERROR$(tput sgr 0)  ] Could not validate Java, try the setup again."
                exit
        fi

        echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Validating mcrcon download"
        FILE=$DIR/bin/mcrcon
        if test -f "$FILE"; then
                echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] mcrcon validated"
        else
                echo "[  $(tput setaf 1)ERROR$(tput sgr 0)  ] Could not validate mcrcon, try the setup again."
                exit
        fi

        echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Validating mcontrol"
        FILE=$DIR/mcontrol
        if test -f "$FILE"; then
                echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] mcontrol validated"
        else
                echo "[  $(tput setaf 1)ERROR$(tput sgr 0)  ] Could not validate mcontrol, try the setup again."
                exit
        fi


        echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Validating server integrity"
        
        cd $DIR

        tput sc

        ./mcontrol start

        sleep 15

        textclear
        
        STATUS=$(nc -z 127.0.0.1 25565 && echo "USE" || echo "FREE")
        tmux has-session -t minecraft 2>/dev/null

        if [[ $? = 0 && $STATUS == "USE" ]]; then
            echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] Server integrity validated"
            exit
        else
            echo "[  $(tput setaf 1)ERROR$(tput sgr 0)  ] Could not validate server integrity, server did not boot."
            exit

        fi
}

start(){
        #!/bin/bash

        source mcontrol.config

        echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Starting server!"

        tmux new -d -s minecraft $DIR/mcontrol boot_loop

        sleep 5

        STATUS=$(nc -z 127.0.0.1 25565 && echo "USE" || echo "FREE")
        tmux has-session -t minecraft 2>/dev/null
        if [[ $? != 0 && $STATUS == "FREE" ]]; then
                sleep 1
                echo "[  $(tput setaf 1)ERROR$(tput sgr 0)  ] Could not boot server."
                
                # sleep 2
                # echo "[  $(tput setaf 3)DEBUG$(tput sgr 0)  ] Booting using default script."
                # /bin/bash -c "$(curl -fsSL https://gist.githubusercontent.com/z3orc/6020377fe1b960724bec1e9281078ec3/raw/vcontrol_debug.sh)"
        else
                echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] Server booted successfully"
        fi
}

boot_loop(){
        #!/bin/bash

        source mcontrol.config

        cd $DIR/serverfiles || exit

        i="0"
        while [ $i -lt 4 ] 
        do
                rm $DIR/.offline
                java -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar server.jar nogui
                touch $DIR/.offline
                sleep 120;
                i=$[$i+1]
        done
}

nw_start(){
        #!/bin/bash

        source mcontrol.config

        cd $DIR/serverfiles

        echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Starting server!"

        tmux new -d -s minecraft $DIR/bin/jdk-16.0.1+9-jre/bin/java -Xms128M -Xmx$RAM -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:-UseParallelGC -XX:-UseParallelOldGC -XX:-UseG1GC -XX:+UseZGC -XX:-ZUncommit -jar server.jar nogui 2>/dev/null
}

stop(){
        #!/bin/bash

        source mcontrol.config

        cd $DIR || exit

        if [[ -z "$1" ]]; then

                STATUS=$(nc -z 127.0.0.1 25565 && echo "USE" || echo "FREE")
                tmux has-session -t minecraft 2>/dev/null
                if [[ $? != 0 && $STATUS == "FREE" ]]; then
                        echo "[  $(tput setaf 1)ERROR$(tput sgr 0)  ] Cannot halt server. Server not running!"
                else
                        
                        echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Halting server process."

                        $DIR/bin/mcrcon -s -p $RCONPASS -w 5 "say Server is shutting down in 10 seconds!" save-all stop

                        sleep 2

                        i="1"
                        while [ $i -lt 8 ] 
                        do      
                                STATUS=$(nc -z 127.0.0.1 25565 && echo "USE" || echo "FREE")
                                FILE=$DIR/.offline
                                if test -f "$FILE"; then
                                        if [[ $STATUS == "FREE" ]]; then
                                        echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] Minecraft server halted!"
                                        tmux kill-session -t minecraft 2>/dev/null
                                        break
                                        fi
                                elif [ $i = "7" ]; then
                                        echo "[  $(tput setaf 1)ERROR$(tput sgr 0)  ] Could not halt server gracefully. Please wait and see if the servers stops after some time, or use ./mcontrol force_stop which might cause loss of data and would not be recommended"
                                        break
                                else
                                        echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Server not halted. Waiting... ($i/6)"
                                        sleep 10
                                        i=$[$i+1]
                                fi
                        done

                fi
        elif [[ $1 == "-f" || $1 == "--force" ]]; then
                echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Waiting 60 seconds, then killing server PID, press 'Ctrl + C' to cancel."
                sleep 60
                PID=$(lsof -i:25565 -t)
                kill $PID
        else
                echo "[  $(tput setaf 1)ERROR$(tput sgr 0)  ] Arguments not valid!"
                exit
        fi

}

resume(){
        #!/bin/bash

        source mcontrol.config

        $DIR/bin/mcrcon -p $RCONPASS -t
}

upgrade() {
        #!/bin/bash

        source mcontrol.config

        cd $DIR


        clear

        echo "             [Upgrade server version]"
        echo "----------------------------------------------------"

        if [[ -z "$1" ]]; then

                IFS= read -r -p "Enter new server version: " NEW_VERSION
        else
                NEW_VERSION="$1"
        fi

        echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Backing up server"

        tput sc

        backup

        stop

        textclear


        echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] Server backed up"

        # echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Validating backup"
        
        # [ -d "$DIR/old_serverfiles" ] && echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] Server backedup validated!" || echo "[  $(tput setaf 1)ERROR$(tput sgr 0)  ] Could not validate server backup. Halting upgrade." exit

        
        echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Removing old server.jar"

        cd $DIR/serverfiles

        rm server.jar

        [ -f "$DIR/serverfiles/server.jar" ] && echo "[  $(tput setaf 1)ERROR$(tput sgr 0)  ] Could not remove server.jar." exit || echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] Server.jar removed"

        echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Downloading new '$NEW_VERSION' server.jar"

        tput sc

        curl -L -o server.jar 'https://mcdl.z3orc.com/get?version='$NEW_VERSION'&flavour='$FLAVOUR --progress-bar


        sleep 2

        textclear 


        [ -f "$DIR/serverfiles/server.jar" ] && echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] Server.jar downloaded" || echo "[  $(tput setaf 1)ERROR$(tput sgr 0)  ] Could not download server.jar."


        echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Validating server integrity"
        
                cd $DIR

                tput sc

                start

                sleep 15

                textclear
                
                tmux has-session -t minecraft 2>/dev/null

                sleep 10

                STATUS=$(nc -z 127.0.0.1 25565 && echo "USE" || echo "FREE")

                if [[ $? = 0 && $STATUS == "USE" ]]; then

                        echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] Server integrity validated"
                        echo "Server updated and running version '$NEW_VERSION'!"
                        sleep 3
                        exit
                        
                else
                        echo "[  $(tput setaf 1)ERROR$(tput sgr 0)  ] Could not validate server integrity, upgrade did not work."

                        echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Reverting changes."

                        tmux kill-session -t minecraft 2>/dev/null

                        cd $DIR

                        cp -r serverfiles corrupt-serverfiles
                        rm -r serverfiles

                        rdiff-backup -r now $DIR/backups $DIR/serverfiles

                        echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] Changes reverted!"

                        echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Validating server integrity."
                        
                        cd $DIR

                        tput sc

                        start
 
                        sleep 15

                        textclear
                        
                        tmux has-session -t minecraft 2>/dev/null
                        
                        sleep 10

                        STATUS=$(nc -z 127.0.0.1 25565 && echo "USE" || echo "FREE")

                        if [[ $? = 0 && $STATUS == "USE" ]]; then
                                echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] Server integrity validated!"
                                exit
                        else
                                echo "[  $(tput setaf 1)ERROR$(tput sgr 0)  ] Could not validate server integrity, server did not boot."
                                exit

                        fi

                fi
}

backup(){
        #!/bin/bash

        source mcontrol.config

        if [[ $1 = "list" ]]; then
                nice -n 10 rdiff-backup --list-increments $DIR/backups
                exit 0
        fi

        tmux has-session -t minecraft 2>/dev/null
        STATUS=$(nc -z 127.0.0.1 25565 && echo "USE" || echo "FREE")

        if [[ $? = 1 || $STATUS == "FREE" ]]; then
                echo "[  $(tput setaf 1)ERROR$(tput sgr 0)  ] Cannot backup while server is not running"
                exit 1
        else
                echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Starting backups process. This might cause server instability"
                echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Saving world."
                $DIR/bin/mcrcon -s -p $RCONPASS -w 3 save-off save-all
                echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] World save complete!"

                echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Running rdiff-backup."
                nice -n 10 rdiff-backup $DIR/serverfiles $DIR/backups
                echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] rdiff-backup complete."

                echo "[  $(tput setaf 3).....$(tput sgr 0)  ] Removing old backups."
                nice -n 10 rdiff-backup --force --remove-older-than 8W $DIR/backups
                echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] Old backups removed."

                $DIR/bin/mcrcon -s -p $RCONPASS -w 3 save-on save-all
                echo "[ $(tput setaf 2)SUCCESS$(tput sgr 0) ] Backup process complete."
        fi
}

case "$1" in
        setup)
                setup
                ;;
        start)
                start
                ;;
        stop)
                stop "${2}"
                ;;
        boot_loop)
                boot_loop
                ;;
        upgrade)
                upgrade "${2}"
                ;;
        backup)
                backup "${2}"
                ;;
        resume)
                resume
                ;;
        *)
                echo "Usage: $0 {start|resume|stop|upgrade|backup|setup}"
esac