if [ -e $HOME/bin_local ]; then
	PATH="$HOME/bin_local:$PATH"
fi

# rbenv settings
if has rbenv; then
	PATH="$HOME/.rbenv/bin:$PATH"
	eval "$(rbenv init -)"
fi

