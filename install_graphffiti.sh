#!/bin/bash

## Put shebang if needed

echo "<=> Installing graphffiti workspace..."
echo "<=>"

if ! command -v zsh &> /dev/null 2>&1 
then
	echo "zsh is not yet installed!"
	echo "Installing zsh"
	sudo apt install zsh
	if $? != 0; then
		echo "Failed to install zsh :("
	fi
else
	echo "<=> curl is already installed"
fi

if ! command -v curl &> /dev/null 2>&1 
then
	echo "curl is not yet installed!"
	echo "Installing curl"
	sudo apt install curl
	if $? != 0; then
		echo "Failed to install curl :("
	fi
else
	echo "<=> curl is already installed"
fi



if  ! command -v rustc &> /dev/null 2>&1  || 
	! command -v rustup &> /dev/null 2>&1 || 
	! command -v cargo &> /dev/null 2>&1  
then
	echo "Rust programs are not yet installed!"
	echo "Installing Rust"
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	if $? != 0; then
		echo "Failed to install Rust :("
	fi
else
	echo "<=> Rust programs are already installed"
fi


if ! command -v starship &> /dev/null 2>&1 
then
	echo "starship is not yet installed!"
	echo "Installing starship"
	cargo install starship
	if $? != 0; then
		echo "Failed to install starship :("
	fi
else
	echo "<=> starship is already installed"
fi

if ! command -v lsd &> /dev/null 2>&1 
then
	echo "lsd is not yet installed!"
	echo "Installing lsd"
	cargo install lsd

	if $? != 0; then
		echo "Failed to install lsd :("
	fi
else
	echo "<=> lsd is already installed"
fi
