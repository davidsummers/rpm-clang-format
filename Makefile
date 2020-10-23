##########################################################################
# Build an RPM from the current spec file and directory tree.            #
#                                                                        #
# Note: The RPM and Makefile are set up to GENERATE RPMS as a non-root   #
# user in the user's home directory.  Of course to INSTALL the resulting #
# binary RPM the user has to log in as root.                             #
##########################################################################

SPEC_FILE := ./clang-format.spec
VERSION_FILE := ./clang-format.spec

RPMDIR := rpmbuild

TOP_DIR := $(shell pwd)/../..

NAME    := $(shell grep '^Name:'    < $(SPEC_FILE) | sed -e 's/^Name: //')
VERSION := $(shell grep '^Version:' < $(SPEC_FILE) | sed -e 's/^Version: //')
RELEASE := $(shell grep '^Release:' < $(SPEC_FILE) | sed -e 's/^.*\-//')

SOURCE_RPM_DIR := $(HOME)/$(RPMDIR)/SOURCES/

all : rpm

subversion rpm : check_release build_srpm_files build_rpm_files

check_release :
	@if [ "$(RELEASE)"x = "x" ]; \
	   then \
		echo "Please specifiy RELEASE"; \
		exit 1 \
	    else \
		exit 0; \
	fi
	@echo "Making $(NAME)-$(VERSION)-$(RELEASE).$(BUILD) (S)RPM..."

build_rpm_files : build_srpm_files
	cd $(SOURCE_RPM_DIR); rpmbuild -ba `basename $(SPEC_FILE)`

build_srpm_files : $(HOME)/.rpmmacros $(HOME)/$(RPMDIR) $(SPEC_FILE)
	@echo "*** Building SRPM files."
	rm -rf $(SOURCE_RPM_DIR)
	mkdir -p $(SOURCE_RPM_DIR)
	cp $(SPEC_FILE) $(SOURCE_RPM_DIR)
	tar cfz $(NAME)-$(VERSION).tar.gz --exclude .svn --exclude .deps --exclude .libs --exclude .git llvm-project
	mv $(NAME)-$(VERSION).tar.gz $(SOURCE_RPM_DIR)

$(HOME)/.rpmmacros :
	@if [ ! -f $(HOME)/.rpmmacros ]; \
	   then \
	   echo "Creating $(HOME)/.rpmmacros"; \
	     rpmdev-setuptree; \
	   fi

$(HOME)/$(RPMDIR) :
	@echo "*** Testing for rpmbuild directory...."
