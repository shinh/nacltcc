ifndef NACL_SDK_ROOT
$(error Please set NACL_SDK_ROOT)
endif

CXX=$(shell ls $(NACL_SDK_ROOT)/toolchain/*_newlib/bin/x86_64-nacl-g++)

CFLAGS:=-std=gnu++98 -Wno-long-long -Wall -Wswitch-enum -pthread -O0 -g -D_GNU_SOURCE=1 -D__STDC_FORMAT_MACROS=1 -D_BSD_SOURCE=1 -D_POSIX_C_SOURCE=199506 -D_XOPEN_SOURCE=600
LDFLAGS:=-lppapi -lppapi_cpp -lnacl-mounts -lnacl_dyncode -lppapi_cpp

all: tinycc_x86_32.nexe tinycc_x86_64.nexe

tinycc_x86_%.nexe: tinycc.cc libtcc%.a
	$(CXX) -m$* $(CFLAGS) $^ libtcc1_$*.a $(LDFLAGS) -o $@

libtcc%.a: $(wildcard ../*.c ../tcc.h)
	cd .. && NACL_PACKAGES_BITSIZE=$* ./nacl-configure && $(MAKE) clean && $(MAKE) all
	cp ../libtcc1.a libtcc1_$*.a
	cp ../libtcc.a $@

clean:
	rm -f *.a *.nexe *.o

.NOTPARALLEL: libtcc32.a libtcc64.a
