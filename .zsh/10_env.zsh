export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
export LANG="en_US.UTF-8"
export PATH=$PATH:$HOME/bin

if [[ is_osx ]]; then
	export PATH=$PATH:/usr/local/bin:/bin
fi

# rbenv settings
if [[ -e ${HOME}/.rbenv/bin ]]; then
	PATH="$HOME/.rbenv/bin:$PATH"
	eval "$(rbenv init -)"
fi

# Deploy local settings
if [[ -e ${HOME}/bin_local ]]; then
	PATH="$HOME/bin_local:$PATH"
fi
if [[ -e ${HOME}/.env_local.zsh ]]; then
	source ${HOME}/.env_local.zsh
fi

