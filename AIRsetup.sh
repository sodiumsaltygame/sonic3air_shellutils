#!/bin/bash

# Checking if user is root
user=$(logname)
mkdir "/home/$user/.local/share/applications" >/dev/null 2>&1
executor=$(whoami)
if [ "$executor" = "root" ]; then
	echo "You can't execute this as root user, please try agian and run as regular user."
	exit 1
fi
# End of root checking

# Functions start here
help() {
	cat << 'EOF'
Sonic 3 A.I.R Setup (Version 1.7)
THIS PROGRAM OR SCRIPT COMES WITH NO KIND OF WARRANTY.

usage	: bash AIRsetup.sh [arg]
args: 
	-rm			: Remove current instalation (only works if has been installed)
	-re			: Re-Install the desktop file (only works if has been installed)
	-h			: Shows this menu
	-i 			: Starts the instalation (only works if has not been installed)
	-fi			: Full-Game install (this moves all of the AIR Data to its own dedicated folder)
	-mag-install: CLI-ModManager Install 
Sonic 3 & Knuckles is a trademark of SEGA Enterprises.
Oxygen Engine is a project made by Eukaryot.

EOF
}
maginstall() {
	echo "ModManager is indev!"
}
remove() {
	if [ -f "/home/$user/.local/share/applications/sonic3air.desktop" ]; then
		echo "Deleting..."
		rm "/home/$user/.local/share/applications/sonic3air.desktop"
		sleep 2
		echo "Done!"
		exit 0
	else
		echo "The desktop file wasnt found"
		exit 0
	fi
}
reinstall() {
	local installed=$(cat /home/$user/.airinstall)
	echo "Checking if the game has been installed"
	sleep 0.5
	if [ "$installed" = "01" ]; then
		sleep 1
		rm "/home/$user/.local/share/applications/sonic3air.desktop"
		echo "Ok"
		echo 00 >"/home/$user/.airinstall"
		install
		exit 0
	else
		echo "File not found, install the game first!"
		exit 0
	fi
}
install() {
	local installed=$(cat /home/$user/.airinstall)
	echo "Checking if game has been installed before"
	sleep 1
	if [ "$installed" = "01" ]; then
		echo "Game was already installed."
		exit 0
	else
		echo "Ok"
		echo "Installing game..."
		sleep 1
		touch "/home/$user/.local/share/applications/sonic3air.desktop"
		cat << EOF > "/home/$user/.local/share/applications/sonic3air.desktop"
[Desktop Entry]
Name=Sonic 3 A.I.R.
Type=Application
Encoding=UTF-8
Exec=$PWD/sonic3air_linux
Icon=$PWD/data/icon.png
StartupWMClass=sonic3air_linux
Terminal=false
Categories=Game;
EOF
		touch "/home/$user/.airinstall"
		echo 01 >"/home/$user/.airinstall"
	fi
}
install-fi() {
	local installed=$(cat /home/$user/.airinstall)
	echo "Checking if game has been installed before"
	sleep 1
	if [ "$installed" = "01" ]; then
		echo "Game was already installed."
		exit 0
	else
		echo "Ok"
		echo "Installing game..."
		sleep 1
		touch "/home/$user/.local/share/applications/sonic3air.desktop"
		cat << EOF > "/home/$user/.local/share/applications/sonic3air.desktop"
[Desktop Entry]
Name=Sonic 3 A.I.R.
Type=Application
Encoding=UTF-8
Exec=/home/$user/.local/share/Sonic3AIR_AppData/sonic3air_linux
Icon=/home/$user/.local/share/Sonic3AIR_AppData/data/icon.png
StartupWMClass=sonic3air_linux
Terminal=false
Categories=Game;
EOF
		touch "/home/$user/.airinstall"
		echo 01 >"/home/$user/.airinstall"
	fi
}
invalid() {
	echo "Invalid option!"
	echo "For more info, do bash AIRsetup.sh -h"
	exit 0
}
reinstall-fi() {
	local installed=$(cat /home/$user/.airinstall)
	echo "Checking if the game has been installed"
	sleep 0.5
	if [ "$installed" = "01" ]; then
		sleep 1
		rm "/home/$user/.local/share/applications/sonic3air.desktop"
		echo "Ok"
		echo 00 >"/home/$user/.airinstall"
		install-fi
		exit 0
	else
		echo "File not found, install the game first!"
		exit 0
	fi
}
full-game-install() {
	echo "Performing full game install..."
	sleep 0.5
	if [ -f "sonic3air_linux" ]; then
		echo "Base Path is $PWD"
		mkdir "/home/$user/.local/share/Sonic3AIR_AppData"
		mv * "/home/$user/.local/share/Sonic3AIR_AppData"
		reinstall-fi
		sudo cp "/home/$user/.local/share/Sonic3AIR_AppData/AIRsetup.sh" /usr/bin/airsetup
		exit 0
	else
		echo "This is not the base game path, please execute inside of base game path"
	fi
}
# Functions end here

# Argument handler start
if [ "$1" = "-i" ]; then
	install
elif [ "$1" = "-h" ]; then
	help
elif [ "$1" = "-rm" ]; then
	remove
elif [ "$1" = "-re" ]; then
	reinstall
elif [ "$1" = "-fi" ]; then
	full-game-install
else
	invalid
fi
# Argument handler end
