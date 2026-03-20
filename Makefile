LIBDIR := lib
CDDL_DIR := cddl
-include $(LIBDIR)/main.mk

$(LIBDIR)/main.mk:
ifneq (,$(shell grep "path *= *$(LIBDIR)" .gitmodules 2>/dev/null))
	git submodule sync
	git submodule update --init
else
ifneq (,$(wildcard $(ID_TEMPLATE_HOME)))
	ln -s "$(ID_TEMPLATE_HOME)" $(LIBDIR)
else
	git clone -q --depth 10 -b main \
	    https://github.com/martinthomson/i-d-template $(LIBDIR)
endif
endif

cddl:
	$(MAKE) -C $(CDDL_DIR)

cddl-clean:
	$(MAKE) -C $(CDDL_DIR) clean

.PHONY: cddl cddl-clean
