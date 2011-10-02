ifndef NACL_SDK_ROOT
$(error Please set NACL_SDK_ROOT)
endif

CXX=$(shell ls $(NACL_SDK_ROOT)/toolchain/*/bin/nacl-g++)

CFLAGS:=-std=gnu++98 -Wno-long-long -Wall -Wswitch-enum -pthread -O0 -g -D_GNU_SOURCE=1 -D__STDC_FORMAT_MACROS=1 -D_BSD_SOURCE=1 -D_POSIX_C_SOURCE=199506 -D_XOPEN_SOURCE=600
LDFLAGS:=-Xlinker --wrap -Xlinker open -Xlinker --wrap -Xlinker close -Xlinker --wrap -Xlinker read -Xlinker --wrap -Xlinker write -Xlinker --wrap -Xlinker lseek -Xlinker --wrap -Xlinker tell -Xlinker --wrap -Xlinker mkdir -Xlinker --wrap -Xlinker rmdir -Xlinker --wrap -Xlinker remove -Xlinker --wrap -Xlinker getcwd -Xlinker --wrap -Xlinker getwd -Xlinker --wrap -Xlinker chdir -Xlinker --wrap -Xlinker isatty -Xlinker --wrap -Xlinker stat -Xlinker --wrap -Xlinker fstat -Xlinker --wrap -Xlinker access -Xlinker --wrap -Xlinker getuid -Xlinker --wrap -Xlinker setuid -Xlinker --wrap -Xlinker getgid -Xlinker --wrap -Xlinker setgid -Xlinker --wrap -Xlinker getlogin -Xlinker --wrap -Xlinker getpwnam -Xlinker --wrap -Xlinker getpwuid -Xlinker --wrap -Xlinker umask -Xlinker --wrap -Xlinker chmod -Xlinker --wrap -Xlinker ioctl -Xlinker --wrap -Xlinker link -Xlinker --wrap -Xlinker unlink -Xlinker --wrap -Xlinker kill -Xlinker --wrap -Xlinker __srget_r -Xlinker --wrap -Xlinker tgetch -Xlinker --wrap -Xlinker mount -Xlinker --wrap -Xlinker umount -Xlinker --wrap -Xlinker signal -lppapi -lppapi_cpp -lnacl-mounts -lnacl_dyncode -lppapi_cpp

all: tinycc_x86_32.nexe tinycc_x86_64.nexe

tinycc_x86_%.nexe: tinycc.cc libtcc%.a
	$(CXX) -m$* $(CFLAGS) $^ $(LDFLAGS) -o $@

libtcc%.a:
	cd .. && NACL_PACKAGES_BITSIZE=$* ./nacl-configure && $(MAKE) clean && $(MAKE) all
	cp ../libtcc.a $@

clean:
	rm -f *.a *.nexe *.o

.NOTPARALLEL: libtcc32.a libtcc64.a
