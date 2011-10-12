APP_NAME:=bitcask
DO_NOT_GENERATE_APP_FILE:=true

UPSTREAM_GIT:=git://github.com/basho/bitcask.git
UPSTREAM_REVISION:=08c765d56e0da5ba9f274f7be6c088630ee61c0b
RETAIN_ORIGINAL_VERSION:=true

ORIGINAL_APP_FILE=$(CLONE_DIR)/ebin/$(APP_NAME).app

LIBRARY:=$(CLONE_DIR)/priv/bitcask.so

CONSTRUCT_APP_PREREQS:=$(LIBRARY)
define construct_app_commands
	mkdir -p $(APP_DIR)/priv
	cp $(LIBRARY) $(APP_DIR)/priv
endef

define package_rules

$(LIBRARY):
	cd $(CLONE_DIR); \
	make

$(PACKAGE_DIR)+clean::
	rm -rf $(LIBRARY)

# This is disgusting. Why can't I just depend on _and_ unpack
# $(EZ_FILE) ? Instead we have .done. targets to confuse matters...
# The reason for unpacking is that we can't dynamically load libraries
# that are within .ez files.
$(PACKAGE_DIR)+pre-run:: $(PACKAGE_DIR)/dist/.done.$(PACKAGE_VERSION)
	rm -rf $(PACKAGE_DIR)/dist/$(APP_NAME)-$(PACKAGE_VERSION)
	unzip $(PACKAGE_DIR)/dist/$(APP_NAME)-$(PACKAGE_VERSION).ez -d $(PACKAGE_DIR)/dist

$(PACKAGE_DIR)+pre-test:: $(PACKAGE_DIR)+pre-run

endef