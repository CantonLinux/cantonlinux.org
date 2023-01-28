.PHONY: all build build_container update _build _install_prereq _install _install_debs
DOCKER_RUN = docker run -v $(CURDIR):/var/app -w /var/app -it --user 1000:1000 -p 4000:4000 -p 35729:35729 cantonlinux_worker
DESTDIR := "_site"

include Makefile.config

help:
	@echo "Thank you for contributing to the Canton Linux Meetup!"
	@echo "Running \"make all\" will build the static site in the \"$(DESTDIR)\" directory and get you started."
	@echo "Once built for the first time, \make build\" will suffice for followup site generation."
	@echo "For any assistance, reach out on our Github, or Slack. Check the site for details: https://www.cantonlinux.org/"
	@echo ""
	@echo "Available commands:"
	@grep -F -h "##" $(MAKEFILE_LIST) | grep -F -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

all: build_container build	## Creates build container and static site (First step)

build:	## Command used to build the site ready for review / deployment
	$(DOCKER_RUN) make _build

build_container:	## Create a local docker container responsible for building the project
	docker build -t cantonlinux_worker .

update:	## Update gems within the container
	$(DOCKER_RUN) bundle update

watch:	## Watch for changes and automatically rebuild
	$(DOCKER_RUN) make _watch

serve:	## Serve the static site
	$(DOCKER_RUN) make _serve

_build:	## Used in the container to build the project
	LANG="en_US.UTF-8" bundle exec jekyll build -d $(DESTDIR)

_watch:	## Used in the container to watch for any changes and automatically rebuild
	LANG="en_US.UTF-8" bundle exec jekyll build -d $(DESTDIR) --watch

_install_prereq: _install_debs _install	## Used in the container build process
	echo "en_US UTF-8" > /etc/locale.gen
	locale-gen en_US.UTF-8

_install:	## Install jekyll and ruby gems
	gem install bundler
	bundle config set path 'vendor/bundle'
	bundle install

_install_debs:	## install ruby on debian/ubuntu and if used locally should use "sudo make _install_debs"
	apt-get update
	apt-get install -y build-essential autoconf zlib1g-dev ruby ruby-dev locales

_serve:	## Most commonly used while working on the site to live reload changes as you make them
	LANG="en_US.UTF-8" bundle exec jekyll serve --livereload --host 0.0.0.0

Makefile.config:
	echo DESTDIR=$(DESTDIR) >Makefile.config
