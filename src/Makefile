include ../include.mk
include ../vsn.mk


ifeq ($(TYPE),debug)
DEBUG_FLAGS = -Ddebug +debug_info
else
DEBUG_FLAGS =
endif

include ../vsn.mk
VSN=$(ERLAWS_VSN)

MODULES=erlaws.erl	\
erlaws_ec2.erl	\
erlaws_s3.erl	\
erlaws_sdb.erl	\
erlaws_sqs.erl	\
erlaws_util.erl

HRL_FILES= ../include/erlaws.hrl

EBIN_FILES=$(MODULES:%=../ebin/%.$(EMULATOR)) ../ebin/erlaws.app
ERLC_FLAGS+=-W $(DEBUG_FLAGS) 

#
# Targets
#

all: $(EBIN_FILES) 

$(EBIN_FILES) : $(HRL_FILES)

debug:
	$(MAKE) TYPE=debug

clean:
	rm -f $(EBIN_FILES)

install: all
	$(INSTALL) -m 755 -d $(DESTDIR)/$(APPDIR)/include
	$(INSTALL) -m 644 ../include/* $(DESTDIR)/$(APPDIR)/include
	$(INSTALL) -d $(DESTDIR)/$(APPDIR)/ebin;
	cd ..; cp -r ebin $(DESTDIR)$(APPDIR)/


DIALYZER_FLAGS+=-Wno_return

dialyzer: .dialyzer.ok

.dialyzer.ok:	$(MODULES:%=../ebin/%.$(EMULATOR))
	dialyzer  $(DIALYZER_FLAGS) -c ../ebin
	touch .dialyzer.ok
