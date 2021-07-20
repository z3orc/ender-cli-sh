# mcontrol v2


### Necessary packages

#### 1.16 or lower
`openjdk-8-jre-headless` or `java-1.8.0-openjdk`
`tmux`
`unzip`
`curl`
`wget`
`tar`
`nano`

#### 1.17 or above (Ubuntu)
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

#### Arch
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

### Installing

Choose which directory you would like the server to populate. Then run the code-snipped below. 

`DIR=$(pwd); sudo rm mcontrol; sudo wget -O mcontrol https://gist.githubusercontent.com/z3orc/9084256e3374255bdee0cef748ffa3fc/raw/mcontrol.sh; chmod +x mcontrol; cd $DIR`


### Automated backups

`@daily /directory-of/your-server/mcontrol backup`
