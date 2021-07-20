# mcontrol


### Necessary packages
`openjdk-8-jre-headless` or `java-1.8.0-openjdk`
`tmux`
`unzip`
`curl`
`wget`
`tar`
`nano`

### Installing
Choose which directory you would like the server to populate. Then run the code-snipped below. 

`DIR=$(pwd); sudo rm mcontrol; sudo wget -O mcontrol https://gist.githubusercontent.com/z3orc/927accc63953fa1f9c69937c277208b2/raw/mcontrol.sh; chmod +x mcontrol; cd $DIR`

`DIR=$(pwd); cd /usr/sbin; sudo rm mcontrol; sudo wget -O mcontrol https://gist.githubusercontent.com/z3orc/927accc63953fa1f9c69937c277208b2/raw/mcontrol.sh; chmod +x mcontrol; cd $DIR`