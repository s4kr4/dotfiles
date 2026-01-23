DOTPATH := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
UNAME   := $(shell uname -s)
ARCH    := $(shell uname -m)

# ホスト名の決定
ifeq ($(UNAME),Linux)
	HOST := linux
else ifeq ($(UNAME),Darwin)
	ifeq ($(ARCH),arm64)
		HOST := darwin
	else
		HOST := darwin-x86
	endif
endif

.PHONY: install nix home-manager update clean help

install: nix home-manager
	@echo "Installation complete! Please restart your shell."

nix:
	@bash $(DOTPATH)/scripts/install-nix.sh

home-manager:
	@bash $(DOTPATH)/scripts/install-home-manager.sh $(HOST)

update:
	git pull origin master
	@bash $(DOTPATH)/scripts/install-home-manager.sh $(HOST)

clean:
	@echo "Removing Home Manager generation..."
	home-manager uninstall || true

help:
	@echo "Usage:"
	@echo "  make install      - Install Nix and apply Home Manager configuration"
	@echo "  make nix          - Install Nix only"
	@echo "  make home-manager - Apply Home Manager configuration"
	@echo "  make update       - Pull latest changes and re-apply"
	@echo "  make clean        - Uninstall Home Manager"
