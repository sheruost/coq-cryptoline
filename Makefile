LIBS=lib/coq-bitblasting
COQMAKEFILE=Makefile.coq
MAKE=make

.PHONY: default libs

default:
	$(MAKE) -f $(COQMAKEFILE)

libs:
	for lib in $(LIBS); do \
		$(MAKE) -C $$lib all; \
	done

all: libs default

clean:
	make -f $(COQMAKEFILE) clean

distclean:
	for lib in $(LIBS); do \
		make -C $$lib clean; \
	done
	make -f $(COQMAKEFILE) clean