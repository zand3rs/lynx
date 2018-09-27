#
# Makefile
#
# by: zander - zand3rs@gmail.com
#
# usage:
#
# make deploy
# make deploy TAG='<version-tag>'
#

CWD = $(shell pwd)
GOPATH = $(CWD)/.go
GOBIN = $(GOPATH)/bin
GOSRC = $(GOPATH)/src
GOPKG = $(GOPATH)/pkg

DEP = $(GOBIN)/dep
REVEL = $(GOBIN)/revel

TAG = $(shell git describe --tags 2>/dev/null || echo 'alpha')
PACKAGE_NAME = $(shell git remote -v 2>/dev/null | grep fetch | sed -E 's/^.*\/([^/]+)\.git.*$$/\1/')

REVEL_PKG = github.com/revel/cmd/revel
PROJECT_PKG = voyager.ph/$(PACKAGE_NAME)
PROJECT_SRC = $(GOSRC)/$(PROJECT_PKG)

BUILD_FILE = /tmp/.$(PACKAGE_NAME)-last-build
DEPLOY_FILE = /tmp/.$(PACKAGE_NAME)-last-deploy

TMP_DIR = $(CWD)/.tmp
DIST_DIR = $(CWD)/dist
DIST_PKG = $(PACKAGE_NAME)-$(TAG)

all:
	@echo 'make [db|dist|deploy|test|clean]'

db:
	@echo 'Initializing db...'
	@db/initdb.sh

init:
	@echo 'Initializing project...'
	@export GOPATH=$(GOPATH)
	@\
	go version && \
	if [ ! -x "$(DEP)" ]; then \
	  curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh; \
	fi; \
	cd $(PROJECT_SRC) && $(DEP) ensure -v && \
	if [ ! -x "$(REVEL)" ]; then \
	  go install $(REVEL_PKG); \
	fi

build: init
	@echo 'Build version: $(TAG)'
	@\
	LAST_BUILD=`[ -r $(BUILD_FILE) ] && cat $(BUILD_FILE)`; \
	if [ -n "$(TAG)" ] && [ "$(TAG)" != "$$LAST_BUILD" ]; then \
	  $(REVEL) version && \
	  $(REVEL) build $(PROJECT_PKG) $(TMP_DIR)/$(DIST_PKG) prod && \
	  echo; \
	fi

dist: build

deploy: dist

test:

clean:
	@echo 'Deleting dist packages..'
	@\rm -Rf $(DIST_DIR)/*

cleanall: clean
	@echo 'Deleting build temp files...'
	@\rm -Rf $(BUILD_FILE)
	@\rm -Rf $(DEPLOY_FILE)

silent:
	@:

%: silent
	@:

.PHONY: silent all clean cleanall db init build dist deploy test
