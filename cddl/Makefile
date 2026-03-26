SHELL := /bin/bash

CDDL := collected.cddl

CDDL_FRAGS := mhwc-claims.cddl
CDDL_FRAGS += meas-hw-comp.cddl
CDDL_FRAGS += mv-phys-prop.cddl
CDDL_FRAGS += mv-self-test.cddl

all: $(CDDL)

$(CDDL): $(CDDL_FRAGS)
# 	cddlc -2tcddl $^ > $@
	cat $^ > $@

clean:
	rm -f $(CDDL)

.PHONY: all clean