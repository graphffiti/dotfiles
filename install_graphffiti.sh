#!/bin/bash

## Put shebang if needed

log () {
	echo "<=> $1"
}

log "Installing graphffiti workspace..."
log ""

## Setting git credentials
git config --global user.email "graphffiti@gmail.com"
git config --global user.name "graphffiti"

if ! command -v zsh &> /dev/null 2>&1 
then
	log "zsh is not yet installed!"
	log "Installing zsh"
	sudo apt install zsh
	if $? != 0; then
		log "Failed to install zsh :("
	else
		log "Success installing zsh :)"
	fi
else
	log "zsh is already installed"
fi

if ! command -v curl &> /dev/null 2>&1 
then
	log "curl is not yet installed!"
	log "Installing curl"
	sudo apt install curl
	if [ $? != 0 ]; then
		log "Failed to install curl :("
	else
		log "Success installing curl :)"
	fi
else
	log "curl is already installed"
fi



if  ! command -v rustc &> /dev/null 2>&1  || 
	! command -v rustup &> /dev/null 2>&1 || 
	! command -v cargo &> /dev/null 2>&1  
then
	log "Rust programs are not yet installed!"
	log "Installing Rust"
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	if [ $? != 0 ]; then
		log "Failed to install Rust programs :("
	else
		log "Success installing Rust programs :)"
		. "$HOME/.cargo/env"
	fi

else
	log "Rust programs are already installed"
fi


if ! command -v starship &> /dev/null 2>&1 
then
	log "starship is not yet installed!"
	log "Installing starship"
	cargo install starship
	if [ $? != 0 ]; then
		log "Failed to install starship :("
	else
		log "Success installing starship :)"
	fi
else
	log "starship is already installed"
fi

if ! command -v lsd &> /dev/null 2>&1 
then
	log "lsd is not yet installed!"
	log "Installing lsd"
	cargo install lsd

	if [ $? != 0 ]; then
		log "Failed to install lsd :("
	else
		log "Success installing lsd :)"
	fi
else
	log "lsd is already installed"
fi
