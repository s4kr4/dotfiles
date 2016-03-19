DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES := $(wildcard .??*) bin
EXCLUSIONS := .git
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

all: install

deploy:
	@$(foreach val, $(DOTFILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)

init:
	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/etc/init/init.sh

update:
	git pull origin master

install: update deploy
	@exec $$SHELL

