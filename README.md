# Minecraft Server Control
Is a collection of scripts/functions which aim at making the daily operations and setup of a Minecraft Server as simple need be. This script uses mcrcon from Tiiffi https://github.com/Tiiffi/mcrcon and rdiff-backup https://github.com/rdiff-backup/rdiff-backup.

## Before installing

Make sure you have all the necessary packages installed before downloading/installing or using mcontrol. These packages will/might differ depending on your distro and which version of Minecraft. Below are some handy-dandy examples of which packages you will need for Ubuntu and Arch.

### Compatibility
Mcontrol has not been tested on every OS/distro there is, I just don't really have the time :), so here is a list of tested distros where the script did or did not work at the time of testing.

|                        	| v1 (2019-2020) 	| v2 (pre 1.17) 	| v3 (Current) 	|
|------------------------	|:----------------:	|:-----------:	|:--------------:	|
| Ubuntu 20.04 LTS       	|        ❔       	|     ✔️     	|       ✔️      	|
| Ubuntu 19.04           	|        ✔️       	|     ✔️     	|       ❔      	|
| Ubuntu 18.04 LTS       	|        ✔️       	|     ❔     	|       ❔      	|
| Debian 10              	|        ❔       	|     ✔️     	|       ❌      	|
| Debian 9               	|        ✔️       	|     ✔️     	|       ❌      	|

*A distro might be seen as not compatible if a necessary package is not avalible from that distros package manager*

### Ubuntu

`openjdk-16-jre-headless`
`tmux`
`unzip`
`curl`
`wget`
`tar`
`nano`
`netcat`
`lsb-release`
`sudo`
`rdiff-backup`

### Arch

`jre-openjdk-headless`
`tmux`
`unzip`
`curl`
`wget`
`tar`
`nano`
`gnu-netcat`
`lsb-release`
`sudo`
`rdiff-backup`

### Java

*IMPORTANT!* If you are planning to use Minecraft 1.17, you will need to use Java 16. For other versions you could take a look at the table below.

|      | Java 8 | Java 11 | Java 16/17 |
|:------:|:--------:|:---------:|:------------:|
| 1.8  |    ✔️   |    ❌    |      ❌     |
| 1.10 |    ✔️   |    ❌    |      ❌     |
| 1.11 |    ✔️   |    ❌    |      ❌     |
| 1.12 |    ❌   |    ✔️    |      ❌     |
| 1.13 |    ❌   |    ✔️    |      ❌     |
| 1.14 |    ❌   |    ✔️    |      ❌     |
| 1.15 |    ❌   |    ✔️    |      ❌     |
| 1.16 |    ❌   |    ✔️    |      ✔️     |
| 1.17 |    ❌   |    ❌    |      ✔️     |

*Note that these are not definitive nor always a necessity, only recommended. https://papermc.io/forums/t/if-so-which-version-of-java-should-i-use-in-my-previous-version-of-minecraft/7582/2*

## Installation

The installation is quite simple and quick. Firstly make sure you have all the packages, again. 

Secondly, you can choose which folder you would prefer to be the new home of your server, or you can create a new one. Then navigate to your desired directory and paste this small snippet of code:

`DIR=$(pwd); rm mcontrol; wget -O mcontrol https://raw.githubusercontent.com/z3orc/mcontrol/main/mcontrol%20v3.sh?token=ADDHCR2QTHLGDOPID5FYGOLBNM3XS; chmod +x mcontrol; cd $DIR`

This will download the script, called mcontrol, to that folder. You might need to run `sudo chmod +x mcontrol` if the previous snippet of code does not do the trick. Anything after this point does not require sudo or root access.

Thirdly, you can type or copy `./mcontrol setup` into the console, then follow the steps on the screen. This will help you to configure your new Minecraft Server. For this step, you can refer to the "Configuration" tab in the Readme-file

Fourthly, well there is no fourth step, you are finished and the server *should* be ready to go.

## Configuration

If there are any configuration options which you do not understand, they are described here.

`Server version` This is the version of Minecraft that you would like your server to use, for instance 1.17.1.

`Server flavour` Is what kind of jar-file you would like. Vanilla is the one directly from mojang, Paper is a custom fork of a custom server-jar and offer better performance, and Purpur is also a custom fork and can result in better performance for servers with a high amount of players. For more info you can visit https://paper.readthedocs.io/en/latest/about/faq.html.

`Amount of ram` This is the amount of ram you would like to allocate to your server. The more the better, but you can not use more then server/vps actually has.

## Basic usage

### Start

If you would like to boot/start your server, just write:

`./mcontrol start`

This will start your server, and inform you if the server does not boot correctly.

---

### Stop

If your server is already running, you can stop the server gracefully by using:

`./mcontrol stop`

If your server is stubborn or has not responded for a long, long time, then you can use:

`./mcontrol stop -f` or `./mcontrol stop --force`

This will force your server offline and will most likely result in a loss of data or a corrupted world, and is therefore not recommended. This is the polar opposite of >gracefully :)

---

### Backup

If you would like to keep your server somewhat safe, you can use:

`./mcontrol backup`

This will make a mirror of all your server files and move them to the backups-directory.

You can also make the process automatic, by using:

`crontab -e`

and pasting:

`@hourly /directory/of/your/server/mcontrol backup`

This will backup your server every hour, which might use a lot of disk space.

***However, this solution will not make your server data 100-percent secure, this makes your files just a little bit more secure.***

---

### Change versions

If your server is running an old version and you would like to run the latest and greatest then you can use:

`./mcontrol upgrade <version>` *Change <version> with the version-number you prefer.
 
This script will backup your server and change the server jar so that the server runs the version you prefer. It can even roll back to a previous state, should the upgrade/update not work. ***However, it is your responsibility that the version you are upgrading from is compatible with the new version, and this script cannot completely protect the server from loss of data or corruption, just make it somewhat easier and safer.*** This script combined with common sense and caution would be a great combo!


---