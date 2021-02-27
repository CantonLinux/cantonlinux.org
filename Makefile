.PHONY: all build setup install_debs install_gems

include Makefile.config

help:
	@echo "make build [DESTDIR=<path-to-site>]"
	@echo "make install_debs   -- install ruby on debian/ubuntu"
	@echo "make install        -- install jekyll and gems"
	@echo "make update         -- update gems"

build:
	bundle exec jekyll build -d $(DESTDIR)

# Install ruby and devel packages to build native extensions.
install_debs:
	sudo apt-get update
	sudo apt-get install build-essential autoconf zlib1g-dev ruby ruby-dev

# Install jekyll and ruby gems.
install: # install_debs
	gem install bundler
	bundle config set path 'vendor/bundle'
	bundle install

update:
	bundle update

Makefile.config:
	echo DESTDIR=_site >Makefile.config
