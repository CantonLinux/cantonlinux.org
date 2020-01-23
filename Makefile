.PHONY: all build setup install_debs install_gems

include Makefile.config

all: build

help:
	@echo "make [build] [DESTDIR=<path-to-site>]"
	@echo "make install_debs   -- install ruby on debian/ubuntu"
	@echo "make install_gems   -- install jekyll and gems"

build:
	bundle exec jekyll build -d $(DESTDIR)

# Install ruby and devel packages to build native extensions.
install_debs:
	sudo apt-get update
	sudo apt-get install build-essential autoconf zlib1g-dev ruby ruby-dev

# Install jekyll and ruby gems.
install_gems:
	gem install bundler
	bundle config set path 'vendor/bundle'
	bundle install

Makefile.config:
	echo DESTDIR=_site >Makefile.config
