DOCKER_RUN = docker run -v $(CURDIR):/var/app -w /var/app -it -p 4000:4000 -p 35729:35729 cantonlinux_worker
COMPOSE_RUN = docker-compose run --rm cantonlinux_worker
DESTDIR := "_site"

include Makefile.config

help:
	@echo "Thank you for contributing to the Canton Linux Meetup!"
	@echo "Running \"make all\" will build the static site in the \"$(DESTDIR)\" directory and get you started."
	@echo "Once built for the first time, \"make run\" will suffice for local development."
	@echo "For any assistance, reach out on our Github, or Slack. Check the site for details: https://www.cantonlinux.org/"
	@echo ""
	@echo "Available commands:"
	@grep -F -h "##" $(MAKEFILE_LIST) | grep -F -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

all: build run	## Creates build container and serves files

run: ## Serve the static site
	$(DOCKER_RUN) make _build_install _run

_run:	## Most commonly used while working on the site to live reload changes as you make them
	LANG="en_US.UTF-8" bundle exec jekyll serve --livereload --host 0.0.0.0

watch: ## Serve the static site
	$(DOCKER_RUN) make _build_install _watch

_watch:	## Used in the container to watch for any changes and automatically rebuild
	LANG="en_US.UTF-8" bundle exec jekyll build -d $(DESTDIR) --watch

build: ## Build container used for processing the site
	docker build -t cantonlinux_worker .

update:	## Update gems within the container
	$(COMPOSE_RUN) bundle update

_build_install:
	bundle install

clean: ## Remove folders related to build
	rm -rf ./{.gems,_site}

Makefile.config:
	echo DESTDIR=$(DESTDIR) >Makefile.config

.PHONY: help all build run _run watch _watch build update _build_install
