# With help from (ok, honestly, I have no idea what I'm doing, so, thanks Pathikrit) https://github.com/pathikrit/mac-setup-script/

#!/usr/bin/env bash

brews=(
	composer
	bash-completion
	fish
	git
	git-extras
	git-flow
	git-lfs
	mackup
	node
	php
	thefuck
)

casks=(
	1password
	abstract
	adobe-creative-cloud
	authy
	docker
	dropbox
	figma
	firefox-developer-edition
	gitkraken
	google-backup-and-sync
	google-chrome-dev
	hyper-canary
	jetbrains-toolbox
	kap-beta
	mac2imgur
	microsoft-remote-desktop-beta
	now
	onedrive
	postman
	sketch
	slack-beta
	spotify
	teamviewer
	visual-studio-code-insiders
	whatsapp
)

fonts=(
	font-firacode-nerd-font
)

######################################## End of app list ########################################

set +e
set -x

function prompt {
  read -p "Hit Enter to $1 ..."
}

if test ! $(which brew); then
  prompt "Install Xcode"
  xcode-select --install

  prompt "Install Homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  prompt "Update Homebrew"
  brew update
  brew upgrade
fi
brew doctor
brew tap homebrew/dupes

function install {
  cmd=$1
  shift
  for pkg in $@;
  do
    exec="$cmd $pkg"
    prompt "Execute: $exec"
    if ${exec} ; then
      echo "Installed $pkg"
    else
      echo "Failed to execute: $exec"
    fi
  done
}

prompt "Update ruby"
ruby -v
brew install gpg
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable
ruby_version='2.6.0'
rvm install ${ruby_version}
rvm use ${ruby_version} --default
ruby -v
sudo gem update --system

prompt "Install packages"
brew info ${brews[@]}
install 'brew install' ${brews[@]}

prompt "Install software"
brew tap caskroom/versions
brew cask info ${casks[@]}
install 'brew cask install' ${casks[@]}

brew tap caskroom/fonts
install 'brew cask install' ${fonts[@]}

prompt "Cleanup"
brew cleanup
brew cask cleanup


echo "Configuring Git"

git config --global user.name "Jeremiah Ashley"

echo "Done!"