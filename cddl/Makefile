SHELL := /bin/bash

CDDL := collected.cddl

CDDL_FRAGS := cddl-example.cddl
CDDL_FRAGS += cddl-example2.cddl

all: $(CDDL)

$(CDDL): $(CDDL_FRAGS)
	cddlc -2tcddl $^ > $@

clean:
	rm -f $(CDDL)

.PHONY: all clean