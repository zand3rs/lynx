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

ENV = dev

CWD = $(shell pwd)
GOPATH = $(CWD)/.go
GOBIN = $(GOPATH)/bin
GOSRC = $(GOPATH)/src
GOPKG = $(GOPATH)/pkg

DEP = $(GOBIN)/dep
REVEL = $(GOBIN)/revel

TAG = $(shell git describe --tags 2>/dev/null || echo 'alpha')
PACKAGE_NAME = $(shell git remote -v 2>/dev/null | grep fetch | sed -E 's/^.*\/([^/]+)\.git.*$$/\1/')

REVEL_PKG = github.com/revel
REVEL_CMD = github.com/revel/cmd/revel

PROJECT_DOMAIN = voyager.ph
PROJECT_GOROOT = $(GOSRC)/$(PROJECT_DOMAIN)

PROJECT_PKG = $(PROJECT_DOMAIN)/$(PACKAGE_NAME)
PROJECT_SRC = $(GOSRC)/$(PROJECT_PKG)

GO_LOCAL_DIR = $(GOPATH)
VENDOR_DIR = $(CWD)/vendor
VENDOR_NEW_DIR = $(CWD)/.vendor-new
BUILD_DIR = $(CWD)/.build

DIST_NAME = $(PACKAGE_NAME)-$(TAG)
DIST_TGZ  = $(DIST_NAME).tgz

APP_BIN = $(PACKAGE_NAME)
APP_ENV = $(ENV)


all:
	@echo 'make [db|dist|deploy|test|clean]'

db:
	@echo 'Initializing db...'
	@db/initdb.sh

init:
	@echo 'Initializing project...'
	@\
	mkdir -p $(GOBIN) $(GOSRC) $(GOPKG) && \
	mkdir -p $(BUILD_DIR) $(PROJECT_GOROOT) && \
	if [ ! -h "$(PROJECT_GOROOT)/$(PACKAGE_NAME)" ]; then \
	  \ln -fsr $(CWD) $(PROJECT_GOROOT)/$(PACKAGE_NAME); \
	fi; \
	export GOPATH=$(GOPATH) && \
	go version && \
	if [ ! -x "$(DEP)" ]; then \
	  curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh; \
	fi; \
	cd $(PROJECT_SRC) && $(DEP) ensure -v && \
	if [ ! -x "$(REVEL)" ]; then \
	  go install ./vendor/$(REVEL_CMD); \
	fi

run: init
	@echo 'Starting app...'
	cd $(GOPATH) && $(REVEL) run $(PROJECT_PKG) $(APP_ENV) || true

build: init
	@echo 'Compiling project...'
	@echo 'Build version: $(TAG)'
	@\
	if [ ! -d "$(BUILD_DIR)/$(DIST_NAME)" ]; then \
	  cd $(GOPATH) && \
	  $(REVEL) version && \
	  $(REVEL) build $(PROJECT_PKG) $(BUILD_DIR)/$(DIST_NAME) prod && \
	  echo "$(BUILD_DIR)/$(DIST_NAME)"; \
	fi

dist: build
	@echo 'Creating distribution package...'
	@echo 'Release: $(DIST_NAME)'
	@\
	if [ ! -f "$(BUILD_DIR)/$(DIST_TGZ)" ]; then \
	  cd $(BUILD_DIR) && \
	  tar -cvf - \
	    $(DIST_NAME)/$(APP_BIN) \
	    $(DIST_NAME)/run.sh \
	    $(DIST_NAME)/src/$(REVEL_PKG) \
	    $(DIST_NAME)/src/$(PROJECT_PKG)/conf \
	    $(DIST_NAME)/src/$(PROJECT_PKG)/public \
	    $(DIST_NAME)/src/$(PROJECT_PKG)/app/views \
	    | gzip -c9 > $(BUILD_DIR)/$(DIST_TGZ) && \
	  echo "$(BUILD_DIR)/$(DIST_TGZ)"; \
	fi

deploy: dist

test:

clean:
	@echo 'Deleting vendor files...'
	@\rm -Rf $(VENDOR_DIR) $(VENDOR_NEW_DIR)

cleanall: clean
	@echo 'Deleting build files..'
	@\rm -Rf $(GO_LOCAL_DIR) $(BUILD_DIR)

silent:
	@:

%: silent
	@:

.PHONY: silent all clean cleanall db init run build dist deploy test
