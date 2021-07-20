# Minecraft Server Operating Scripts

## Before installing

Make sure you have all the necessary packages installed before downloading/installing or using MSOS. These packages will/might differ depending on your distro and which version of Minecraft. Below are some handy-dandy examples of which packages you will need for Ubuntu and Arch.

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


*IMPORTANT!* If you are planning to use Minecraft 1.17, you will need to use Java 16. For other versions you could take a look at the table below.

|      | Java 8 | Java 11    | Java 16/17 |
|------|--------|------------|------------|
| 1.8  |    ✓   |      ✗     |      ✗     |
| 1.10 |    ✓   |      ✗     |      ✗     |
| 1.11 |    ✓   |      ✗     |      ✗     |
| 1.12 |    ✗   |      ✓     |      ✗     |
| 1.13 |    ✗   |      ✓     |      ✗     |
| 1.14 |    ✗   |      ✓     |      ✗     |
| 1.15 |    ✗   |      ✓     |      ✗     |
| 1.16 |    ✗   | ✓ (1.16.4) | ✓ (1.16.5) |
| 1.17 |    ✗   |      ✗     |      ✓     |

*Note that these are not definitve, only recommended. https://papermc.io/forums/t/if-so-which-version-of-java-should-i-use-in-my-previous-version-of-minecraft/7582/2


## Installation

`DIR=$(pwd); sudo rm mcontrol; sudo wget -O mcontrol https://git.io/Jle34; chmod +x mcontrol; cd $DIR`

## Configuration

## Basic usage
