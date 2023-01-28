# vim: set ft=make ts=4 tw=78 noexpandtab colorcolumn=78 spell :
# SPDX-License-Identifier: FSFAP

##############################################################################
#
# Copyright (c) 2022 Jeffrey H. Johnson <trnsz@pobox.com>
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered "AS-IS",
# without any warranty.
#
##############################################################################

AWK    ?= awk
CC     ?= cc
ECHO   := echo
ENV    := env
GREP   ?= grep
PRINTF ?= printf
RM     ?= rm -f
SHELL  ?= sh
SLEEP  ?= sleep
TEST   ?= test
TOUCH  ?= touch
TRUE   ?= true

##############################################################################

.PHONY: all
all: isnewer

##############################################################################

isnewer  : isnewer.o
isnewer.o: isnewer.c

##############################################################################

.PHONY: clean
clean:
	$(RM) isnewer isnewer.o

##############################################################################

.PHONY: test check
test check:
	@$(PRINTF) %s\\n "Running tests ..."
	@$(PRINTF) %s\\n "x" > "/dev/null" 2>&1 ||                               \
      { $(ECHO) "ERROR: $(PRINTF) failure; unable to test."; exit 3; }
	@$(PRINTF) %s\\n "x" | $(GREP) -q "^y$$" || exit 0 ;                     \
      { $(PRINTF) %s\\n "ERROR: $(GREP) failure; unable to test."; exit 3; }
	@$(PRINTF) %s\\n "x" | $(GREP) -q "^x$$" ||                              \
      { $(PRINTF) %s\\n "ERROR: $(GREP) failure; unable to test."; exit 3; }
	@$(PRINTF) %s\\n " fail" | $(AWK)                                        \
      '/ fail$$/{exit_code=1;}/^/{print} END{exit !exit_code}'               \
        > "/dev/null" 2>&1 ||                                                \
      { $(PRINTF) %s\\n "ERROR: $(AWK) failure; unable to test."; exit 3; }  \
        || $(TRUE)
	@$(MAKE) -s "test.job" 2>&1 | $(AWK)                                     \
      '/ fail$$/{exit_code=1;}/^/{print} END{exit !exit_code}' &&            \
        { $(PRINTF) %s\\n "ERROR: One or more tests failed!"; exit 4; }      \
          || $(TRUE)
	@$(PRINTF) %s\\n "All tests completed successfully."

##############################################################################

.PHONY: test.job check.job
test.job check.job: isnewer isnewer.c
	@$(SLEEP) 1
	@$(TOUCH) isnewer
	@$(PRINTF) '%s\t %s\t ' "Test 1:" "Newer          "
	@$(ENV) $(SHELL) -c './isnewer isnewer isnewer.c &&                      \
      { $(PRINTF) %s\\n "ok"; } || { $(PRINTF) %s\\n "fail"; exit 0; }'
	@$(PRINTF) '%s\t %s\t ' "Test 2:" "Older          "
	@$(ENV) $(SHELL) -c './isnewer isnewer.c isnewer &&                      \
      { $(PRINTF) %s\\n "fail"; exit 0; } || { $(PRINTF) %s\\n "ok"; }'
	@$(PRINTF) '%s\t %s\t ' "Test 3:" "None           "
	@$(ENV) $(SHELL) -c './isnewer &&                                        \
      { $(PRINTF) %s\\n "fail"; exit 0; } || { $(PRINTF) %s\\n "ok"; }'
	@$(PRINTF) '%s\t %s\t ' "Test 4:" "Extra          "
	@$(ENV) $(SHELL) -c './isnewer 1 2 3 &&                                  \
      { $(PRINTF) %s\\n "fail"; exit 0; } || { $(PRINTF) %s\\n "ok"; }'
	@$(PRINTF) '%s\t %s\t ' "Test 5:" "Short version  "
	@$(ENV) $(SHELL) -c '$(PRINTF) "x" | $(GREP) -q "^x$$" &&                \
      { ./isnewer -v 2>&1 | $(GREP) -q " version " &&                        \
        { $(PRINTF) %s\\n "ok"; exit 0; } ||                                 \
          { $(PRINTF) %s\\n "fail"; exit 0; }; }'
	@$(PRINTF) '%s\t %s\t ' "Test 6:" "Long version   "
	@$(ENV) $(SHELL) -c '$(PRINTF) "x" | $(GREP) -q "^x$$" &&                \
      { ./isnewer --version 2>&1 | $(GREP) -q " version " &&                 \
        { $(PRINTF) %s\\n "ok"; exit 0; } ||                                 \
          { $(PRINTF) %s\\n "fail"; exit 0; }; }'
	@$(PRINTF) '%s\t %s\t ' "Test 7:" "Short help     "
	@$(ENV) $(SHELL) -c '$(PRINTF) "x" | $(GREP) -q "^x$$" &&                \
      { ./isnewer -h 2>&1 | $(GREP) -q "^Usage: " &&                         \
        { $(PRINTF) %s\\n "ok"; exit 0; } ||                                 \
          { $(PRINTF) %s\\n "fail"; exit 0; }; }'
	@$(PRINTF) '%s\t %s\t ' "Test 8:" "Long help      "
	@$(ENV) $(SHELL) -c '$(PRINTF) "x" | $(GREP) -q "^x$$" &&                \
      { ./isnewer --help 2>&1 | $(GREP) -q "^Usage: " &&                     \
        { $(PRINTF) %s\\n "ok"; exit 0; } ||                                 \
          { $(PRINTF) %s\\n "fail"; exit 0; }; }'

##############################################################################

.PHONY: distclean
distclean: clean
	$(RM) core a.out *~ *.bak

##############################################################################
