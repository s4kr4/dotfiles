# rbenv settings
if [[ -e ${HOME}/.rbenv/bin ]]; then
	PATH="$HOME/.rbenv/bin:$PATH"
	eval "$(rbenv init -)"
fi

# Deploy local settings
if [[ -e ${HOME}/bin_local ]]; then
	PATH="$HOME/bin_local:$PATH"
fi
if [[ -e ${HOME}/.zshenv_local ]]; then
	source ${HOME}/.zshenv_local
fi

