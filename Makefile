DOTPATH := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
UNAME   := $(shell uname -s)

.PHONY: install brew deploy update clean help claude

install: brew deploy
	@echo ""
	@echo "Installation complete!"

brew:
	@bash $(DOTPATH)/scripts/install-brew.sh

deploy:
	@bash $(DOTPATH)/scripts/deploy.sh

update:
	git pull origin master
	brew bundle --file=$(DOTPATH)/Brewfile
	@bash $(DOTPATH)/scripts/deploy.sh

clean:
	@echo "Nothing to clean."

claude:
	@bash $(DOTPATH)/scripts/deploy-claude.sh

help:
	@echo "Usage:"
	@echo "  ./install.sh  - Install and start zsh automatically"
	@echo "  make install  - Install Homebrew and deploy dotfiles"
	@echo "  make brew     - Install Homebrew and packages"
	@echo "  make deploy   - Deploy dotfiles (create symlinks)"
	@echo "  make claude   - Deploy Claude Code config (CLAUDE.md, agents, skills, rules)"
	@echo "  make update   - Pull latest and update"
