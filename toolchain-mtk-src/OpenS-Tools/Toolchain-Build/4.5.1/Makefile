CROSS_SRC_HOME ?= ${PWD}/../../../OpenS


TOOLCHAIN_GCC_VERSION := 4.5.1

ARCH9=arm9
ARCH11=arm11
ARCHA9=cortex-a9

ifndef FAMILY
FAMILY:=${ARCHA9}
endif

ifndef FPU
FPU:=vfp
endif

ifeq "${FAMILY}" "${ARCHA9}"
CLFS_TARGET = armv7a-mediatek-linux-gnueabi
GCC_EXTRA_CONFIG = --with-arch=armv7-a \
		--with-tune=cortex-a9 \
		--with-cpu=cortex-a9 \
		--with-interwork
GLIBC_CFLAGS = -march=armv7-a \
	       -mtune=cortex-a9 \
	       -mthumb-interwork
endif

ifeq "${FAMILY}" "${ARCH11}"
CLFS_TARGET = armv6z-mediatek-linux-gnueabi
GCC_EXTRA_CONFIG = --with-arch=armv6z \
		--with-tune=arm1176jz-s \
		--with-cpu=arm1176jz-s \
		--with-interwork
GLIBC_CFLAGS = -march=armv6z \
	       -mtune=arm1176jz-s \
               -mthumb-interwork
endif

ifeq "${FAMILY}" "${ARCH9}"
$(error "Not support now!")
CLFS_TARGET = armv5t-mediatek-linux-gnueabi
GCC_EXTRA_CONFIG = --with-arch=armv5t \
		--with-tune=arm10tdmi \
		--with-cpu=arm10tdmi \
		--with-interwork \
		--with-float=soft
endif

ifeq "${FPU}" "vfp"
ifeq "${FAMILY}" "${ARCH11}"
GCC_EXTRA_CONFIG += --with-fpu=vfp \
		--with-float=softfp
GCC_FP_OPTION = -mfpu=vfp -mfloat-abi=softfp
endif

ifeq "${FAMILY}" "${ARCHA9}"
GCC_EXTRA_CONFIG += --with-fpu=vfp \
		--with-float=softfp
GCC_FP_OPTION = -mfpu=vfp -mfloat-abi=softfp
endif
endif

ifeq "${FPU}" "soft"
GCC_EXTRA_CONFIG += --with-float=soft
GCC_FP_OPTION = -mfloat-abi=soft
endif

GCC_EABI_OPTION =
# -mabi=aapcs-linux

# This will generating hardware floating point instructions while still 
# conforming to the base (soft-float) AAPCS. GCC does not support the 
# hard-float abi variant for vfp.
#-fsignaling-nans -ffinite-math-only
#-ffast-math

include ${PWD}/../common.mak
all: help
toolchain: 	dirs linux_headers pre_gcc m4 gmp mpfr mpc ppl cloog_ppl libelf binutils autoconf gawk gcc_c_only glibc_cross gcc_with_cpp toolchain_release
.NOTPARALLEL: 	dirs linux_headers pre_gcc m4 gmp mpfr mpc ppl cloog_ppl libelf binutils autoconf gawk gcc_c_only glibc_cross gcc_with_cpp toolchain_release
host_gcc: 	gmp_host mpfr_host ppl_host cloog_ppl_host gcc_host
cross_gcc:	m4 gmp_cross mpfr_cross ppl_cross cloog_ppl_cross gcc_with_cpp
2nd_build: 	
#tcpwrapper e2fsprog db flex cracklib linux_pam libiconv

misc:
#misc: 		zlib libpng libjpeg freetype busybox
# sysvinit util-linux

crosstools: 	toolchain 2nd_build misc
mtk: 		crosstools fill_library image_tools
#busybox mini-rootfs
archive:	src toolchain_release

help:
	@echo "make <target> [FAMILY=<family>] [FPU=<fpu>]"
	@echo "family:"
	@echo "    arm9"
	@echo "    arm11"
	@echo "    cortex-a9            --default"
	@echo " "
	@echo "fpu:"
	@echo "    soft"
	@echo "    vfp			--default"
	@echo " "
	@echo "target:"
	@echo "  * crosstools           --build full cross toolchain"
	@echo "  * clean                --clean specified ARCH's toolchain and root file system"
	@echo "    clean_all            --clean all ARCH's toolchain and root file system"
	@echo " "
	@echo "NOTE"
	@echo "    1. 'FAMILY=' is optional, but it should be set after the target start with a start (*)"
	@echo "        (such as, 'crosstools' 'clean')"
	@echo "    2. If 'FAMILY=' is NOT set, the default value is 'cortex-a9'"
	@echo "    3. Samples:"
	@echo "        $ make crosstools FAMILY=arm9 FPU=vfp"
	@echo "        $ make clean (Equal to 'make clean FAMILY=cortex-a9')"
	@echo "        $ make clean_all"


### template #######################
VAR_PREFIX := FOO
${VAR_PREFIX}_NAME := foo
${VAR_PREFIX}_VERSION := bar
${VAR_PREFIX}_SOURCE := ${CLFS_SOURCE}/${${VAR_PREFIX}_NAME}/${${VAR_PREFIX}_VERSION}
${VAR_PREFIX}_BUILD  := ${CLFS_BUILD}/${${VAR_PREFIX}_NAME}-build
${VAR_PREFIX}_FOLDER := ${CLFS_BUILD}/${${VAR_PREFIX}_NAME}-${${VAR_PREFIX}_VERSION}

##### 1st priority package #########
VAR_PREFIX := BINUTILS
${VAR_PREFIX}_NAME := binutils
${VAR_PREFIX}_VERSION := 2.21
${VAR_PREFIX}_SOURCE := ${CLFS_SOURCE}/${${VAR_PREFIX}_NAME}/${${VAR_PREFIX}_VERSION}
${VAR_PREFIX}_BUILD  := ${CLFS_BUILD}/${${VAR_PREFIX}_NAME}-build
${VAR_PREFIX}_FOLDER := ${${VAR_PREFIX}_NAME}-${${VAR_PREFIX}_VERSION}

##### glibc #########
VAR_PREFIX := GLIBC
${VAR_PREFIX}_NAME := glibc
${VAR_PREFIX}_VERSION := 2.12.2
${VAR_PREFIX}_SOURCE := ${CLFS_SOURCE}/${${VAR_PREFIX}_NAME}/${${VAR_PREFIX}_VERSION}
${VAR_PREFIX}_BUILD  := ${CLFS_BUILD}/${${VAR_PREFIX}_NAME}-build
${VAR_PREFIX}_FOLDER := ${${VAR_PREFIX}_NAME}-${${VAR_PREFIX}_VERSION}

##### glibc-ports #########
VAR_PREFIX := GLIBC_PORTS
${VAR_PREFIX}_NAME := glibc-ports
${VAR_PREFIX}_VERSION := ${GLIBC_VERSION}
${VAR_PREFIX}_SOURCE := ${CLFS_SOURCE}/${${VAR_PREFIX}_NAME}/${${VAR_PREFIX}_VERSION}
${VAR_PREFIX}_FOLDER := ${GLIBC_NAME}-${GLIBC_VERSION}/ports

##### gcc #########
VAR_PREFIX := GCC
${VAR_PREFIX}_NAME := gcc
${VAR_PREFIX}_VERSION := ${TOOLCHAIN_GCC_VERSION}
${VAR_PREFIX}_SOURCE := ${CLFS_SOURCE}/${${VAR_PREFIX}_NAME}/${${VAR_PREFIX}_VERSION}
${VAR_PREFIX}_BUILD  := ${CLFS_BUILD}/${${VAR_PREFIX}_NAME}-build
${VAR_PREFIX}_FOLDER := ${${VAR_PREFIX}_NAME}-${${VAR_PREFIX}_VERSION}

#### host gcc ########
VAR_PREFIX := PRE_GCC
${VAR_PREFIX}_NAME := gcc
${VAR_PREFIX}_VERSION := 4.2.0
${VAR_PREFIX}_SOURCE := ${CLFS_SOURCE}/${${VAR_PREFIX}_NAME}/${${VAR_PREFIX}_VERSION}
${VAR_PREFIX}_BUILD  := ${INTERNAL_BUILD}/${${VAR_PREFIX}_NAME}-build
${VAR_PREFIX}_FOLDER := ${${VAR_PREFIX}_NAME}-${${VAR_PREFIX}_VERSION}

##### kernel headers ###############
VAR_PREFIX := LINUX
${VAR_PREFIX}_NAME := linux
${VAR_PREFIX}_VERSION := 2.6.27
${VAR_PREFIX}_SOURCE := ${CLFS_SOURCE}/${${VAR_PREFIX}_NAME}/${${VAR_PREFIX}_VERSION}
${VAR_PREFIX}_BUILD  := ${CLFS_BUILD}/${${VAR_PREFIX}_NAME}-build
${VAR_PREFIX}_FOLDER := ${${VAR_PREFIX}_NAME}-${${VAR_PREFIX}_VERSION}

##### gmp ###############
VAR_PREFIX := GMP
${VAR_PREFIX}_NAME := gmp
${VAR_PREFIX}_VERSION := 4.3.2
${VAR_PREFIX}_SOURCE := ${CLFS_SOURCE}/${${VAR_PREFIX}_NAME}/${${VAR_PREFIX}_VERSION}
${VAR_PREFIX}_BUILD  := ${INTERNAL_BUILD}/${${VAR_PREFIX}_NAME}-build
${VAR_PREFIX}_FOLDER := ${${VAR_PREFIX}_NAME}-${${VAR_PREFIX}_VERSION}

##### mpfr ###############
VAR_PREFIX := MPFR
${VAR_PREFIX}_NAME := mpfr
${VAR_PREFIX}_VERSION := 2.4.2
${VAR_PREFIX}_SOURCE := ${CLFS_SOURCE}/${${VAR_PREFIX}_NAME}/${${VAR_PREFIX}_VERSION}
${VAR_PREFIX}_BUILD  := ${INTERNAL_BUILD}/${${VAR_PREFIX}_NAME}-build
${VAR_PREFIX}_FOLDER := ${${VAR_PREFIX}_NAME}-${${VAR_PREFIX}_VERSION}

##### mpc ###############
VAR_PREFIX := MPC
${VAR_PREFIX}_NAME := mpc
${VAR_PREFIX}_VERSION := 0.8.2
${VAR_PREFIX}_SOURCE := ${CLFS_SOURCE}/${${VAR_PREFIX}_NAME}/${${VAR_PREFIX}_VERSION}
${VAR_PREFIX}_BUILD  := ${INTERNAL_BUILD}/${${VAR_PREFIX}_NAME}-build
${VAR_PREFIX}_FOLDER := ${${VAR_PREFIX}_NAME}-${${VAR_PREFIX}_VERSION}

##### ppl ###############
VAR_PREFIX := PPL
${VAR_PREFIX}_NAME := ppl
${VAR_PREFIX}_VERSION := 0.10.2
${VAR_PREFIX}_SOURCE := ${CLFS_SOURCE}/${${VAR_PREFIX}_NAME}/${${VAR_PREFIX}_VERSION}
${VAR_PREFIX}_BUILD  := ${INTERNAL_BUILD}/${${VAR_PREFIX}_NAME}-build
${VAR_PREFIX}_FOLDER := ${${VAR_PREFIX}_NAME}-${${VAR_PREFIX}_VERSION}

##### cloog-ppl ###############
VAR_PREFIX := CLOOG_PPL
${VAR_PREFIX}_NAME := cloog-ppl
${VAR_PREFIX}_VERSION := 0.15.9
${VAR_PREFIX}_SOURCE := ${CLFS_SOURCE}/${${VAR_PREFIX}_NAME}/${${VAR_PREFIX}_VERSION}
${VAR_PREFIX}_BUILD  := ${INTERNAL_BUILD}/${${VAR_PREFIX}_NAME}-build
${VAR_PREFIX}_FOLDER := ${${VAR_PREFIX}_NAME}-${${VAR_PREFIX}_VERSION}

##### libelf ###############
VAR_PREFIX := LIBELF
${VAR_PREFIX}_NAME := libelf
${VAR_PREFIX}_VERSION := 0.8.13
${VAR_PREFIX}_SOURCE := ${CLFS_SOURCE}/${${VAR_PREFIX}_NAME}/${${VAR_PREFIX}_VERSION}
${VAR_PREFIX}_BUILD  := ${INTERNAL_BUILD}/${${VAR_PREFIX}_NAME}-build
${VAR_PREFIX}_FOLDER := ${${VAR_PREFIX}_NAME}-${${VAR_PREFIX}_VERSION}

##### m4 ###############
VAR_PREFIX := M4
${VAR_PREFIX}_NAME := m4
${VAR_PREFIX}_VERSION := 1.4.11
${VAR_PREFIX}_SOURCE := ${CLFS_SOURCE}/${${VAR_PREFIX}_NAME}/${${VAR_PREFIX}_VERSION}
${VAR_PREFIX}_BUILD  := ${INTERNAL_BUILD}/${${VAR_PREFIX}_NAME}-build
${VAR_PREFIX}_FOLDER := ${${VAR_PREFIX}_NAME}-${${VAR_PREFIX}_VERSION}

##### autoconf ###############
VAR_PREFIX := AUTOCONF
${VAR_PREFIX}_NAME := autoconf
${VAR_PREFIX}_VERSION := 2.64
${VAR_PREFIX}_SOURCE := ${CLFS_SOURCE}/${${VAR_PREFIX}_NAME}/${${VAR_PREFIX}_VERSION}
${VAR_PREFIX}_BUILD  := ${INTERNAL_BUILD}/${${VAR_PREFIX}_NAME}-build
${VAR_PREFIX}_FOLDER := ${${VAR_PREFIX}_NAME}-${${VAR_PREFIX}_VERSION}

##### gawk ###############
VAR_PREFIX := GAWK
${VAR_PREFIX}_NAME := gawk
${VAR_PREFIX}_VERSION := 3.1.6
${VAR_PREFIX}_SOURCE := ${CLFS_SOURCE}/${${VAR_PREFIX}_NAME}/${${VAR_PREFIX}_VERSION}
${VAR_PREFIX}_BUILD  := ${INTERNAL_BUILD}/${${VAR_PREFIX}_NAME}-build
${VAR_PREFIX}_FOLDER := ${${VAR_PREFIX}_NAME}-${${VAR_PREFIX}_VERSION}

####################################

### zlib,png,jpeg,freetype #########
ZLIB_SOURCE = ${CLFS_SOURCE}/zlib
ZLIB_BUILD  = ${CLFS_BUILD}/zlib-build
ZLIB_FILE = zlib-1.2.3.tar.gz
ZLIB_FOLDER = zlib-1.2.3
ZLIB_DECOMPRESS_FLAG = zxf

PNG_SOURCE = ${CLFS_SOURCE}/libpng
PNG_BUILD  = ${CLFS_BUILD}/png-build
#PNG_FILE = libpng-1.0.37.tar.gz
#PNG_FOLDER = libpng-1.0.37
#PNG_DECOMPRESS_FLAG = zxf
PNG_FILE = libpng-1.2.30.tar.bz2
PNG_FOLDER = libpng-1.2.30
PNG_DECOMPRESS_FLAG = jxf

JPEG_SOURCE = ${CLFS_SOURCE}/libjpeg
JPEG_BUILD  = ${CLFS_BUILD}/jpeg-build
JPEG_FILE = jpegsrc.v6b.tar.gz
JPEG_FOLDER = jpeg-6b
JPEG_DECOMPRESS_FLAG = zxf

FT_SOURCE = ${CLFS_SOURCE}/freetype
FT_BUILD  = ${CLFS_BUILD}/ft-build
FT_FILE = freetype-2.3.7.tar.gz
FT_FOLDER = freetype-2.3.7
FT_DECOMPRESS_FLAG = zxf

clean: clean_${FAMILY}
clean_${FAMILY}:
	rm -rf ${CLFS_BUILD}
	rm -rf ${CLFS_ROOT}
	rm -rf ${CROSS_TOOLS}

clean_all:
	rm -rf ${CLFS_BUILD_BASE}
	rm -rf ${CLFS_ROOT_BASE}
	rm -rf ${CROSS_TOOLS_BASE}

.NOTPARALLEL:	dirs linux_headers glibc_headers tcpwrapper e2fsprog linux_pam libiconv flex

dirs:
	install -dv ${CLFS_ROOT}
	install -dv ${CLFS_BUILD}
	install -dv ${INTERNAL_BUILD}
	mkdir -pv ${CLFS_ROOT}/{bin,boot,dev,{etc/,}opt,home,lib,mnt}
	mkdir -pv ${CLFS_ROOT}/{proc,media/{floppy,cdrom},sbin,srv,sys}
	mkdir -pv ${CLFS_ROOT}/var/{lock,log,mail,run,spool}
	mkdir -pv ${CLFS_ROOT}/var/{opt,cache,lib/{misc,locate},local}
	install -dv -m 0750 ${CLFS_ROOT}/root
	install -dv -m 1777 ${CLFS_ROOT}{/var,}/tmp
	mkdir -pv ${CLFS_ROOT}/usr/{,local/}{bin,include,lib,sbin,src}
	mkdir -pv ${CLFS_ROOT}/usr/{,local/}share/{doc,info,locale,man}
	mkdir -pv ${CLFS_ROOT}/usr/{,local/}share/{misc,terminfo,zoneinfo}
	mkdir -pv ${CLFS_ROOT}/usr/{,local/}share/man/man{1,2,3,4,5,6,7,8}
	for dir in ${CLFS_ROOT}/usr{,/local}; do ln -sfnv share/{man,doc,info} $${dir}; done
	echo root::0:0:root:/root:/bin/bash > ${CLFS_ROOT}/etc/passwd
	echo root:x:0: > ${CLFS_ROOT}/etc/group
	echo root:x:0: >> ${CLFS_ROOT}/etc/group
	echo bin:x:1: >> ${CLFS_ROOT}/etc/group
	echo sys:x:2: >> ${CLFS_ROOT}/etc/group
	echo kmem:x:3: >> ${CLFS_ROOT}/etc/group
	echo tty:x:4: >> ${CLFS_ROOT}/etc/group
	echo tape:x:5: >> ${CLFS_ROOT}/etc/group
	echo daemon:x:6: >> ${CLFS_ROOT}/etc/group
	echo floppy:x:7: >> ${CLFS_ROOT}/etc/group
	echo disk:x:8: >> ${CLFS_ROOT}/etc/group
	echo lp:x:9: >> ${CLFS_ROOT}/etc/group
	echo dialout:x:10: >> ${CLFS_ROOT}/etc/group
	echo audio:x:11: >> ${CLFS_ROOT}/etc/group
	echo video:x:12: >> ${CLFS_ROOT}/etc/group
	echo utmp:x:13: >> ${CLFS_ROOT}/etc/group
	echo usb:x:14: >> ${CLFS_ROOT}/etc/group
	echo cdrom:x:15: >> ${CLFS_ROOT}/etc/group

linux_headers:
	rm -fr ${CLFS_BUILD}/${LINUX_FOLDER}
	mkdir -pv ${CLFS_BUILD}/${LINUX_FOLDER}
	cp -a ${LINUX_SOURCE}/. ${CLFS_BUILD}/${LINUX_FOLDER}
	cd ${CLFS_BUILD}/${LINUX_FOLDER} && \
	$(MAKE) headers_install ARCH=arm INSTALL_HDR_PATH=${CLFS_ROOT}/usr 

gmp:
	rm -fr ${INTERNAL_BUILD}/${GMP_FOLDER}
	rm -fr ${GMP_BUILD}
	mkdir -pv ${INTERNAL_BUILD}/${GMP_FOLDER}
	cp -a ${GMP_SOURCE}/. ${INTERNAL_BUILD}/${GMP_FOLDER}
	mkdir -v ${GMP_BUILD}
	cd ${GMP_BUILD} && \
	CC=${CCACHE_GCC} CPPFLAGS=-fexceptions ../${GMP_FOLDER}/configure \
		--prefix=${INTERNAL_BUILD}	\
		--disable-shared --enable-static \
		--enable-cxx ABI=32	
	$(MAKE) -C ${GMP_BUILD}
	$(MAKE) -C ${GMP_BUILD} install
		
mpfr:
	rm -fr ${INTERNAL_BUILD}/${MPFR_FOLDER}
	rm -fr ${MPFR_BUILD}
	mkdir -pv ${INTERNAL_BUILD}/${MPFR_FOLDER}
	cp -a ${MPFR_SOURCE}/. ${INTERNAL_BUILD}/${MPFR_FOLDER}
	mkdir -v ${MPFR_BUILD}
	cd ${MPFR_BUILD} && \
	CC=${CCACHE_GCC} LDFLAGS="-Wl,-rpath,${INTERNAL_BUILD}/lib" ../${MPFR_FOLDER}/configure \
		--prefix=${INTERNAL_BUILD} --with-gmp=${INTERNAL_BUILD} \
		--disable-shared		
	$(MAKE) -C ${MPFR_BUILD}
	$(MAKE) -C ${MPFR_BUILD} install

mpc:
	rm -fr ${INTERNAL_BUILD}/${MPC_FOLDER}
	rm -fr ${MPC_BUILD}
	mkdir -pv ${INTERNAL_BUILD}/${MPC_FOLDER}
	cp -a ${MPC_SOURCE}/. ${INTERNAL_BUILD}/${MPC_FOLDER}
	mkdir -v ${MPC_BUILD}
	cd ${MPC_BUILD} && \
	CC=${CCACHE_GCC} LDFLAGS="-Wl,-rpath,${INTERNAL_BUILD}/lib" ../${MPC_FOLDER}/configure \
		--prefix=${INTERNAL_BUILD} --with-gmp=${INTERNAL_BUILD} --with-mpfr=${INTERNAL_BUILD} \
		--disable-shared		
	$(MAKE) -C ${MPC_BUILD}
	$(MAKE) -C ${MPC_BUILD} install

m4:
	rm -fr ${INTERNAL_BUILD}/${M4_FOLDER}
	rm -fr ${M4_BUILD}
	mkdir -pv ${INTERNAL_BUILD}/${M4_FOLDER}
	cp -a ${M4_SOURCE}/. ${INTERNAL_BUILD}/${M4_FOLDER}
	mkdir -v ${M4_BUILD}
	cd ${M4_BUILD} && \
	CC=${CCACHE_GCC} ../${M4_FOLDER}/configure --prefix=${INTERNAL_BUILD}
	$(MAKE) -C ${M4_BUILD}
	$(MAKE) -C ${M4_BUILD} install

#
# make a temp GCC to build PPL 
# 1. PPL needs gcc>=4.0.3
# 2. "-fgnu89-inline" needs gcc >=4.1.3
# So, choose gcc-4.2.0 as a temp compiler
#
pre_gcc:
	rm -fr ${INTERNAL_BUILD}/${PRE_GCC_FOLDER}
	rm -fr ${PRE_GCC_BUILD}
	mkdir -pv ${INTERNAL_BUILD}/${PRE_GCC_FOLDER}
	cp -a ${PRE_GCC_SOURCE}/. ${INTERNAL_BUILD}/${PRE_GCC_FOLDER}
	mkdir -v ${PRE_GCC_BUILD}
	cd ${PRE_GCC_BUILD} && \
	CC=${CCACHE_GCC} ../${PRE_GCC_FOLDER}/configure --prefix=${INTERNAL_BUILD}/gcc-install --enable-shared --enable-threads=posix --enable-__cxa_atexit --enable-c99 --enable-long-long --enable-clocale=gnu --enable-languages=c,c++
	$(MAKE) -C ${PRE_GCC_BUILD} bootstrap
	$(MAKE) -C ${PRE_GCC_BUILD} install

autoconf:
	rm -fr ${INTERNAL_BUILD}/${AUTOCONF_FOLDER}
	rm -fr ${AUTOCONF_BUILD}
	mkdir -pv ${INTERNAL_BUILD}/${AUTOCONF_FOLDER}
	cp -a ${AUTOCONF_SOURCE}/. ${INTERNAL_BUILD}/${AUTOCONF_FOLDER}
	mkdir -v ${AUTOCONF_BUILD}
	cd ${AUTOCONF_BUILD} && \
	CC=${CCACHE_GCC} ../${AUTOCONF_FOLDER}/configure --prefix=${INTERNAL_BUILD}
	$(MAKE) -C ${AUTOCONF_BUILD}
	$(MAKE) -C ${AUTOCONF_BUILD} install	

gawk:
	rm -fr ${INTERNAL_BUILD}/${GAWK_FOLDER}
	rm -fr ${GAWK_BUILD}
	mkdir -pv ${INTERNAL_BUILD}/${GAWK_FOLDER}
	cp -a ${GAWK_SOURCE}/. ${INTERNAL_BUILD}/${GAWK_FOLDER}
	mkdir -v ${GAWK_BUILD}
	cd ${GAWK_BUILD} && \
	CC=${CCACHE_GCC} ../${GAWK_FOLDER}/configure --prefix=${INTERNAL_BUILD}
	$(MAKE) -C ${GAWK_BUILD}
	$(MAKE) -C ${GAWK_BUILD} install	

ppl:
	rm -fr ${INTERNAL_BUILD}/${PPL_FOLDER}
	rm -fr ${PPL_BUILD}
	mkdir -pv ${INTERNAL_BUILD}/${PPL_FOLDER}
	cp -a ${PPL_SOURCE}/. ${INTERNAL_BUILD}/${PPL_FOLDER}
	mkdir -v ${PPL_BUILD}
#	CC=${CCACHE_GCC} CXX="${CCACHE_GXX}" LDFLAGS="-Wl,-rpath,${INTERNAL_BUILD}/lib" ../${PPL_FOLDER}/configure "${CCACHE} ${INTERNAL_BUILD}/bin/g++"
	cd ${PPL_BUILD} && \
	CC=${CCACHE_GCC} CXX="${CCACHE} ${INTERNAL_BUILD}/gcc-install/bin/g++" LDFLAGS="-Wl,-rpath,${INTERNAL_BUILD}/lib" ../${PPL_FOLDER}/configure	\
		--prefix=${INTERNAL_BUILD} 				\
		--disable-shared						\
		--enable-interfaces="c,cxx"				\
		--disable-optimization					\
		--disable-nls						\
		--with-libgmp-prefix=${INTERNAL_BUILD}			\
		--with-libgmpxx-prefix=${INTERNAL_BUILD}					
	$(MAKE) -C ${PPL_BUILD}
	$(MAKE) -C ${PPL_BUILD} install

cloog_ppl:
	rm -fr ${CLOOG_PPL_FOLDER}
	rm -fr ${CLOOG_PPL_BUILD}
	mkdir -pv ${INTERNAL_BUILD}/${CLOOG_PPL_FOLDER}
	cp -a ${CLOOG_PPL_SOURCE}/. ${INTERNAL_BUILD}/${CLOOG_PPL_FOLDER}
	mkdir -v ${CLOOG_PPL_BUILD}
	cd ${CLOOG_PPL_BUILD} && \
	CC=${CCACHE_GCC} LDFLAGS="-Wl,-rpath,${INTERNAL_BUILD}/lib" ../${CLOOG_PPL_FOLDER}/configure \
		--prefix=${INTERNAL_BUILD} 	\
		--disable-shared 		\
		--with-bits=gmp 		\
		--with-gmp=${INTERNAL_BUILD}	\
		--with-ppl=${INTERNAL_BUILD}
	$(MAKE) -C ${CLOOG_PPL_BUILD}
	$(MAKE) -C ${CLOOG_PPL_BUILD} install

libelf:
	rm -fr ${INTERNAL_BUILD}/${LIBELF_FOLDER}
	rm -fr ${LIBELF_BUILD}
	mkdir -pv ${INTERNAL_BUILD}/${LIBELF_FOLDER}
	cp -a ${LIBELF_SOURCE}/. ${INTERNAL_BUILD}/${LIBELF_FOLDER}
	mkdir -v ${LIBELF_BUILD}
	cd ${LIBELF_BUILD} && \
	CC=${CCACHE_GCC} ../${LIBELF_FOLDER}/configure 	\
		--prefix=${INTERNAL_BUILD}		\
		--disable-shared

	$(MAKE) -C ${LIBELF_BUILD}
	$(MAKE) -C ${LIBELF_BUILD} install

binutils:
	rm -fr ${CLFS_BUILD}/${BINUTILS_FOLDER}
	rm -fr ${BINUTILS_BUILD}
	mkdir -pv ${CLFS_BUILD}/${BINUTILS_FOLDER}
	cp -a ${BINUTILS_SOURCE}/. ${CLFS_BUILD}/${BINUTILS_FOLDER}
	mkdir -v ${BINUTILS_BUILD}
	cd ${BINUTILS_BUILD} && \
	CXX=/usr/bin/g++ CC=/usr/bin/gcc AR=ar AS=as ../${BINUTILS_FOLDER}/configure 	\
			--prefix=${CROSS_TOOLS}/binutils 	\
			--host=${CLFS_HOST} 		\
			--target=${CLFS_TARGET} 	\
			--with-sysroot=${CLFS_ROOT} 	\
			--with-gnu-as		 	\
			--with-gnu-ld		 	\
			--enable-interwork	 	\
			--disable-nls 			\
			--enable-multilib 		\
			--disable-shared 		\
			--enable-static 		\
			--disable-werror 		\
			--program-prefix=${BIN_PREFIX}- \
			CC=${CCACHE_GCC} 		\
			--enable-lto 			\
			--with-ppl=${INTERNAL_BUILD} 	\
			--with-cloog=${INTERNAL_BUILD} 	\
			--with-mpc=${INTERNAL_BUILD} 	\
			--with-mpfr=${INTERNAL_BUILD} 	\
			--with-gmp=${INTERNAL_BUILD}	\
			--enable-gold 
	$(MAKE) -C ${BINUTILS_BUILD} configure-host
	$(MAKE) -C ${BINUTILS_BUILD} 
	$(MAKE) -C ${BINUTILS_BUILD} install
	cp -v ${CLFS_BUILD}/${BINUTILS_FOLDER}/include/libiberty.h ${CLFS_ROOT}/usr/include

gcc_c_only:
	rm -fr ${CLFS_BUILD}/${GCC_FOLDER}
	rm -fr ${GCC_BUILD}
	mkdir -pv ${CLFS_BUILD}/${GCC_FOLDER}
	cp -a ${GCC_SOURCE}/. ${CLFS_BUILD}/${GCC_FOLDER}
	cd ${CLFS_BUILD}/${GCC_FOLDER}/gcc && \
	autoconf configure.ac > configure	
	mkdir -v ${GCC_BUILD}
	export CFLAGS="-g -O2"
# debug: delete -L${CROSS_TOOLS}/lib of LDFLAGS
	cd ${GCC_BUILD} && \
	CC=${INTERNAL_BUILD}/gcc-install/bin/gcc LDFLAGS="-L${INTERNAL_BUILD}/lib" ../${GCC_FOLDER}/configure \
		--prefix=${CROSS_TOOLS}/gcc 	\
		--host=${CLFS_HOST} 		\
		--target=${CLFS_TARGET} 	\
		--with-sysroot=${CLFS_ROOT} 	\
		${GCC_EXTRA_CONFIG} 		\
		--with-gnu-as		 	\
		--with-gnu-ld		 	\
		--with-newlib 			\
		--disable-multilib 		\
		--disable-nls 			\
		--disable-shared 		\
		--disable-threads 		\
		--enable-languages=c 		\
		--with-mpfr=${INTERNAL_BUILD} 	\
		--with-gmp=${INTERNAL_BUILD} 	\
		--with-mpc=${INTERNAL_BUILD} 	\
		--with-ppl=${INTERNAL_BUILD} 	\
		--with-libelf=${INTERNAL_BUILD} \
		--with-cloog=${INTERNAL_BUILD} 	\
		--program-transform-name=s,^,${BIN_PREFIX}-,	\
		--enable-lto 			\
		--without-system-libunwind	\
		--disable-rpath 		\
		--with-host-libstdcxx='-static-libgcc -Wl,-Bstatic,-lstdc++,-Bdynamic,-lm'	\
		--with-build-time-tools=${CROSS_TOOLS}/binutils/$(CLFS_TARGET)/bin/		\
		--with-specs='%{!fno-unwind-tables:-funwind-tables}'
#		--with-specs='%{!fno-unwind-tables:-funwind-tables} %{!fno-exceptions:-fexceptions}'

	$(MAKE) -C ${GCC_BUILD} all-gcc all-target-libgcc
	$(MAKE) -C ${GCC_BUILD} install-gcc install-target-libgcc
	ln -svf `${CROSS_GCC}  -print-libgcc-file-name` `${CROSS_GCC} -print-libgcc-file-name | sed 's/libgcc/&_eh/'`

glibc_cross:
	rm -fr ${CLFS_BUILD}/${GLIBC_FOLDER}
	rm -fr ${GLIBC_BUILD}
	mkdir -pv ${CLFS_BUILD}/${GLIBC_FOLDER}
	cp -a ${GLIBC_SOURCE}/. ${CLFS_BUILD}/${GLIBC_FOLDER}
	mkdir -pv ${CLFS_BUILD}/${GLIBC_PORTS_FOLDER}
	cp -a ${GLIBC_PORTS_SOURCE}/. ${CLFS_BUILD}/${GLIBC_PORTS_FOLDER}
	
	mkdir -v ${GLIBC_BUILD}
	cd ${GLIBC_BUILD} && \
	echo "libc_cv_forced_unwind=yes" > config.cache && \
	echo "libc_cv_c_cleanup=yes" >> config.cache && \
	echo "libc_cv_arm_tls=yes" >> config.cache && \
	echo "libc_cv_gnu89_inline=yes" >> config.cache && \
	echo "libc_cv_slibdir=/lib" >> config.cache && \
	echo "install_root=${CLFS_ROOT}" > configparms && \
	echo "libdir=/usr/lib" >> configparms && \
	BUILD_CC=${CCACHE_GCC} 				\
	CC="${CROSS_GCC} ${GLIBC_CFLAGS} -g -fno-exceptions -B${CROSS_TOOLS}/binutils/${CLFS_TARGET}/bin" \
	AR="${BIN_PREFIX}-ar rus" 			\
	RANLIB="${BIN_PREFIX}-ranlib" 			\
	../${GLIBC_FOLDER}/configure 			\
		--prefix=/usr 				\
		--build=${CLFS_HOST} 			\
		--host=${CLFS_TARGET} 			\
		--target=${CLFS_TARGET} 		\
		--with-headers=${CLFS_ROOT}/usr/include \
		--with-binutils=${CROSS_TOOLS}/binutils/bin 	\
		--with-tls 				\
		--with-__thread 			\
		--enable-sim 				\
		--enable-nptl 				\
		--enable-add-ons 			\
		--enable-kernel=2.6.27 			\
		--disable-profile 			\
		--without-gd 				\
		--without-fp 				\
		--without-cvs 				\
		--cache-file=config.cache

	$(MAKE) -C ${GLIBC_BUILD}
	$(MAKE) -C ${GLIBC_BUILD} install	
	$(MAKE) -C ${GLIBC_BUILD} localedata/install-locales
	echo "# Begin /etc/nsswitch.conf" > ${CLFS_ROOT}/etc/nsswitch.conf
	echo "" >>  ${CLFS_ROOT}/etc/nsswitch.conf
	echo "passwd: files" >>  ${CLFS_ROOT}/etc/nsswitch.conf
	echo "group: files" >>  ${CLFS_ROOT}/etc/nsswitch.conf
	echo "shadow: files" >>  ${CLFS_ROOT}/etc/nsswitch.conf
	echo "" >>  ${CLFS_ROOT}/etc/nsswitch.conf
	echo "hosts: files dns" >>  ${CLFS_ROOT}/etc/nsswitch.conf
	echo "networks: files" >>  ${CLFS_ROOT}/etc/nsswitch.conf
	echo "" >>  ${CLFS_ROOT}/etc/nsswitch.conf
	echo "protocols: files" >>  ${CLFS_ROOT}/etc/nsswitch.conf
	echo "services: files" >>  ${CLFS_ROOT}/etc/nsswitch.conf
	echo "ethers: files" >>  ${CLFS_ROOT}/etc/nsswitch.conf
	echo "rpc: files" >>  ${CLFS_ROOT}/etc/nsswitch.conf
	echo "" >>  ${CLFS_ROOT}/etc/nsswitch.conf
	echo "# End /etc/nsswitch.conf" >>  ${CLFS_ROOT}/etc/nsswitch.conf
	echo "# Begin /etc/ld.so.conf" > ${CLFS_ROOT}/etc/ld.so.conf
	echo "" >> ${CLFS_ROOT}/etc/ld.so.conf
	echo "/usr/local/lib" >> ${CLFS_ROOT}/etc/ld.so.conf
	echo "/opt/lib" >> ${CLFS_ROOT}/etc/ld.so.conf
	echo "" >> ${CLFS_ROOT}/etc/ld.so.conf
	echo "# End /etc/ld.so.conf" >> ${CLFS_ROOT}/etc/ld.so.conf
gcc_with_cpp:
	rm -fr ${CLFS_BUILD}/${GCC_FOLDER}
	rm -fr ${GCC_BUILD}
	mkdir -pv ${CLFS_BUILD}/${GCC_FOLDER}
	cp -a ${GCC_SOURCE}/. ${CLFS_BUILD}/${GCC_FOLDER}
	cp ${GCC_SOURCE}/libgomp/libgomp_g.h ${GCC_SOURCE}/libgomp/testsuite/libgomp.c/libgomp_g.h
	cd ${CLFS_BUILD}/${GCC_FOLDER}/gcc && \
	autoconf configure.ac > configure
# && \
#	`sed 's/CROSSTOOLSBINDIR/$(shell echo -e ${CROSS_TOOLS} | sed -e 's,\/,\\\/,g')\/${CLFS_TARGET}\/bin/g' \
#		libstdc++-v3/testsuite/lib/libstdc++.exp > libstdc++-v3/testsuite/lib/libstdc++.exp.new` && \
#		mv libstdc++-v3/testsuite/lib/libstdc++.exp.new libstdc++-v3/testsuite/lib/libstdc++.exp && \
#	`sed 's/${FAKE_BINPREFIX}/${BIN_PREFIX}/g' \
#		gcc/testsuite/lib/scanasm.exp > gcc/testsuite/lib/scanasm.exp.new` && \
#		mv gcc/testsuite/lib/scanasm.exp.new gcc/testsuite/lib/scanasm.exp && \
#	`sed 's/${FAKE_BINPREFIX}/${BIN_PREFIX}/g' \
#		gcc/testsuite/lib/scandump.exp > gcc/testsuite/lib/scandump.exp.new` && \
#		mv gcc/testsuite/lib/scandump.exp.new gcc/testsuite/lib/scandump.exp && \
#	`sed 's/${FAKE_BINPREFIX}/${BIN_PREFIX}/g' \
#		gcc/testsuite/lib/file-format.exp > gcc/testsuite/lib/file-format.exp.new` && \
#		mv gcc/testsuite/lib/file-format.exp.new gcc/testsuite/lib/file-format.exp && \

#	export THIS_CC="$(shell echo ${CCACHE} ${CC})"
#	export CPP="$(shell echo ${THIS_CC})"
#	#THIS_CC="$$CCACHE $$CC"
#	#export CPP="$$THIS_CC"
#	export CC_FOR_TARGET="$(shell echo ${THIS_CC})"
#	export GCC_FOR_TARGET="$(shell echo ${THIS_CC})"
#	export AS_FOR_TARGET=$$AS
#	export LD_FOR_TARGET=$$LD
#	export NM_FOR_TARGET=$$NM
#	export RANLIB_FOR_TARGET=$$RANLIB
#	export AR_FOR_TARGET=$$AR
#	export CPP_FOR_TARGET=$$CPP
#	export LD_LIBRARY_PATH=${CLFS_ROOT}/lib
#	export CXX_FOR_TARGET="$(shell echo ${THIS_CC} -shared-libgcc)"
#	export CXX="$(shell echo ${THIS_CC} -shared-libgcc)"	

# debug: delete -L${CROSS_TOOLS}/lib of LDFLAGS
	mkdir -p ${CROSS_TOOLS}/gcc/${CLFS_TARGET}/bin
	mkdir -v ${GCC_BUILD}
	cd ${GCC_BUILD} && \
	CC=${INTERNAL_BUILD}/gcc-install/bin/gcc AR=ar LDFLAGS="-L${INTERNAL_BUILD}/lib" ../${GCC_FOLDER}/configure \
		--prefix=${CROSS_TOOLS}/gcc 	\
		--host=${CLFS_HOST} 		\
		--target=${CLFS_TARGET} 	\
		--with-sysroot=${CLFS_ROOT} 	\
		${GCC_EXTRA_CONFIG} 		\
		--with-gnu-as		 	\
		--with-gnu-ld		 	\
		--disable-nls 			\
		--enable-shared 		\
		--enable-__cxa_atexit 		\
		--disable-multilib 		\
		--enable-c99 			\
		--enable-long-long 		\
		--enable-threads=posix 		\
		--enable-languages=c,c++ 	\
		--with-gmp=${INTERNAL_BUILD} 	\
		--with-mpfr=${INTERNAL_BUILD} 	\
		--with-ppl=${INTERNAL_BUILD} 	\
		--with-cloog=${INTERNAL_BUILD} 	\
		--with-libelf=${INTERNAL_BUILD} 	\
		--program-transform-name=s,^,${BIN_PREFIX}-, \
		--with-mpc=${INTERNAL_BUILD} --enable-lto --without-system-libunwind \
		--disable-rpath --with-host-libstdcxx='-static-libgcc -Wl,-Bstatic,-lstdc++,-Bdynamic,-lm'	\
		--with-specs='%{!fno-unwind-tables:-funwind-tables}'	\
		--with-build-time-tools=${CROSS_TOOLS}/binutils/$(CLFS_TARGET)/bin/ \
		--enable-cxx-flags='-g -O2'
#		--with-specs='%{!fno-unwind-tables:-funwind-tables} %{!fno-exceptions:-fexceptions}'
	$(MAKE) -C ${GCC_BUILD}
	$(MAKE) -C ${GCC_BUILD} install	
	cp -pd ${CROSS_TOOLS}/gcc/${CLFS_TARGET}/lib/libgcc_s.* ${CLFS_ROOT}/lib
	cp -pd ${CROSS_TOOLS}/gcc/${CLFS_TARGET}/lib/libstdc++.* ${CLFS_ROOT}/lib

clean_zlib:
	rm -fr ${CLFS_BUILD}/${ZLIB_FOLDER}
zlib:
	tar ${ZLIB_DECOMPRESS_FLAG} ${ZLIB_SOURCE}/${ZLIB_FILE} -C  ${CLFS_BUILD}
	cd ${CLFS_BUILD}/${ZLIB_FOLDER} && \
	CC="${CROSS_GCC}" CFLAGS="-fPIC" ./configure --prefix=${CLFS_ROOT}/usr --shared && \
	$(MAKE) && \
	$(MAKE) install

clean_libpng:
	rm -fr ${CLFS_BUILD}/${PNG_FOLDER}
libpng:
	tar ${PNG_DECOMPRESS_FLAG} ${PNG_SOURCE}/${PNG_FILE} -C  ${CLFS_BUILD}
	cd ${CLFS_BUILD}/${PNG_FOLDER} && \
	CC="${CROSS_GCC}" ./configure --prefix=${CLFS_ROOT}/usr --host=${CLFS_HOST} --target=${CLFS_TARGET} && \
	$(MAKE) && \
	$(MAKE) install

clean_libjpeg:
	rm -fr ${CLFS_BUILD}/${JPEG_FOLDER}
libjpeg:
	tar ${JPEG_DECOMPRESS_FLAG} ${JPEG_SOURCE}/${JPEG_FILE} -C  ${CLFS_BUILD}
	cd ${CLFS_BUILD}/${JPEG_FOLDER} && \
	for loop in $(shell ls ${JPEG_SOURCE}/*patch); \
	do \
 		 patch -Np1 -i $$loop; \
	done 	
	cd ${CLFS_BUILD}/${JPEG_FOLDER} && \
	CC="${CROSS_GCC}" AR="${BIN_PREFIX}-ar" RANLIB="${BIN_PREFIX}-ranlib" AS="${BIN_PREFIX}-as" STRIP="${BIN_PREFIX}-strip"  \
		./configure --prefix=${CLFS_ROOT}/usr --host=${CLFS_HOST} --target=${CLFS_TARGET} \
		--enable-shared --enable-static --without-zlib && \
	$(MAKE) && \
	$(MAKE) install

clean_freetype:
	rm -fr ${CLFS_BUILD}/${FT_FOLDER}
freetype:
	tar ${FT_DECOMPRESS_FLAG} ${FT_SOURCE}/${FT_FILE} -C  ${CLFS_BUILD}
	cd ${CLFS_BUILD}/${FT_FOLDER} && \
	CC="${CROSS_GCC}" RANLIB="${BIN_PREFIX}-ranlib" \
		./configure --prefix=${CLFS_ROOT}/usr --host=${CLFS_HOST} --target=${CLFS_TARGET} \
		--enable-shared --enable-static && \
	$(MAKE) && \
	$(MAKE) install

image_tools:
	if [ -d ${IMAGE_TOOLS} ]; then rm -fr ${IMAGE_TOOLS}; fi
	mkdir -pv ${IMAGE_TOOLS}
	cp -f ${CLFS_SOURCE}/binary/{genext2fs,mkcramfs,mkimage,mksquashfs,packlinux,MtkTool.exe} ${IMAGE_TOOLS}
	
fill_library:
	cp -pd ${CROSS_TOOLS}/${CLFS_TARGET}/lib/libgcc_s.* ${CLFS_ROOT}/lib
	cp -pd ${CROSS_TOOLS}/${CLFS_TARGET}/lib/libstdc++.* ${CLFS_ROOT}/lib

clean_busybox:
	rm -fr ${CLFS_BUILD}/${BUSYBOX_FOLDER}

busybox:
	if [ ! -d ${CLFS_BUILD} ]; then mkdir -pv ${CLFS_BUILD}; fi
	if [ -d ${CLFS_BUILD}/${BUSYBOX_FOLDER} ]; then rm -fr ${CLFS_BUILD}/${BUSYBOX_FOLDER}; fi
	tar ${BUSYBOX_DECOMPRESS_FLAG} ${BUSYBOX_SOURCE}/${BUSYBOX_FILE} -C ${CLFS_BUILD}
	cd ${CLFS_BUILD}/${BUSYBOX_FOLDER} && \
	cp -f ${BUSYBOX_SOURCE}/busybox-config .config && \
	CC="${CROSS_GCC}" $(MAKE) all SUBARCH=arm CROSS_COMPILE=${BIN_PREFIX}- && \
	$(MAKE) install SUBARCH=arm CROSS_COMPILE=${BIN_PREFIX}- PREFIX=${CLFS_ROOT}

mini-rootfs: image_tools
	if [ -d ${ROOTFS_DEBUG} ]; then rm -fr ${ROOTFS_DEBUG}; fi
	mkdir -pv ${ROOTFS_DEBUG}
	if [ -d ${CLFS_SOURCE}/rootfs ]; then rm -fr ${CLFS_SOURCE}/rootfs; fi && \
	tar zxf ${CLFS_SOURCE}/rootfs.tar.gz -C ${ROOTFS_DEBUG}
	#cp -pda ${CLFS_SOURCE}/rootfs    	${ROOTFS_DEBUG}
	cp -pda ${CLFS_SOURCE}/binary/* 	${ROOTFS_DEBUG}
	if [ -f ${CLFS_BUILD}/${BUSYBOX_FOLDER}/_install/bin/busybox ]; then \
		cp -f ${CLFS_BUILD}/${BUSYBOX_FOLDER}/_install/bin/busybox ${CLFS_ROOT}/bin; \
		cp -f ${CLFS_BUILD}/${BUSYBOX_FOLDER}/_install/bin/busybox ${ROOTFS_DEBUG}/rootfs/bin; \
	fi
#	- rm -f ${ROOTFS_DEBUG}/rootfs/lib/lib*so*
#	- rm -f ${ROOTFS_DEBUG}/rootfs/lib/ld-*
	- rm -f ${ROOTFS_DEBUG}/rootfs/lib/security/pam_{time,stress,rootok,deny,env,filter,issue,lastlog,limits,listfile,localuser,mail,mkhomedir,motd,permit,securetty,succeed_if,debug}.so
	cp -pda ${CLFS_ROOT}/lib/lib*so*	${ROOTFS_DEBUG}/rootfs/lib
	cp -pda ${CLFS_ROOT}/lib/ld-*   	${ROOTFS_DEBUG}/rootfs/lib
	#find ${CLFS_ROOT}/{bin,usr/bin,usr/sbin} -type f -name "*icon*" -exec cp '{}' ${ROOTFS_DEBUG}/rootfs/bin ';'
	find ${CLFS_ROOT}/lib -type f -name "*icon*so*" -exec cp '{}' ${ROOTFS_DEBUG}/rootfs/lib ';'
	- ${CROSS_TOOLS}/bin/${BIN_PREFIX}-strip  ${ROOTFS_DEBUG}/rootfs/usr/lib/lib*so*
	- ${CROSS_TOOLS}/bin/${BIN_PREFIX}-strip  ${ROOTFS_DEBUG}/rootfs/lib/lib*so*
	- ${CROSS_TOOLS}/bin/${BIN_PREFIX}-strip  ${ROOTFS_DEBUG}/rootfs/lib/ld-*
	- rm -f ${ROOTFS_DEBUG}/rootfs/lib/preloadable_libiconv.so
	- rm -fr ${ROOTFS_DEBUG}/rootfs/usrbin
	- rm -fr ${ROOTFS_DEBUG}/rootfs/home
	- rm -fr ${ROOTFS_DEBUG}/rootfs/root/.ssh-*
	- rm -f ${ROOTFS_DEBUG}/rootfs/lib/preloadable_libiconv.so
	- rm -fr ${ROOTFS_DEBUG}/rootfs/usr/lib/gcov
	- rm -f ${ROOTFS_DEBUG}/rootfs/bin/{run-parts,ngettext,iconv,killall5,autopoint,envsubst,recode-sr-latin}
	- rm -f ${ROOTFS_DEBUG}/rootfs/sbin/{dhcpcd-bin,mount.smb,mount.smbfs,telinit,reboot}
	- rm -f ${ROOTFS_DEBUG}/rootfs/sbin/{dhcpcd,e2fsck,halt,ifdown,ifup,killall5,modprobe,pmap_dump,pmap_set,portmap,scsi_id,shutdown,start-stop-daemon}
	- rm -f ${ROOTFS_DEBUG}/rootfs/lib/e2initrd_helper
	- rm -f ${ROOTFS_DEBUG}/rootfs/lib/libgettext*
	- rm -fr ${ROOTFS_DEBUG}/rootfs/lib/gettext
	- rm -f ${ROOTFS_DEBUG}/rootfs/lib/libdb*
	- rm -f ${ROOTFS_DEBUG}/rootfs/lib/libiconv*
	- rm -f ${ROOTFS_DEBUG}/rootfs/lib/libext2*
	- rm -f ${ROOTFS_DEBUG}/rootfs/lib/libe2p*
	- rm -f ${ROOTFS_DEBUG}/rootfs/lib/libcrack*
	- rm -f ${ROOTFS_DEBUG}/rootfs/lib/libpamc*
	- rm -f ${ROOTFS_DEBUG}/rootfs/lib/libcom_err*
	- rm -f ${ROOTFS_DEBUG}/rootfs/lib/libBrokenLocale*
	- rm -f ${ROOTFS_DEBUG}/rootfs/lib/libSegFault*
	- rm -f ${ROOTFS_DEBUG}/rootfs/lib/libanl*
	- rm -f ${ROOTFS_DEBUG}/rootfs/lib/libasprintf*
	- rm -f ${ROOTFS_DEBUG}/rootfs/lib/libmemusage*
	- rm -f ${ROOTFS_DEBUG}/rootfs/lib/libcharset*
	- rm -f ${ROOTFS_DEBUG}/rootfs/lib/libpcprofile*
	- rm -f ${ROOTFS_DEBUG}/rootfs/lib/libbwrap*
	- rm -f ${ROOTFS_DEBUG}/rootfs/lib/security/pam_{time,stress,rootok,deny,env,filter,issue,lastlog,limits,listfile,localuser,mail,mkhomedir,motd,permit,securetty,succeed_if,debug,cracklib,ftp,nologin,rhosts_auth,shells,warn,wheel,xauth}.so
	- rm -fr ${ROOTFS_DEBUG}/rootfs/lib/security/pam_filter
	- rm -fr ${ROOTFS_DEBUG}/rootfs/usr/lib/gcov
	- rm -fr ${ROOTFS_DEBUG}/rootfs/usr/sort
	- rm -fr ${ROOTFS_DEBUG}/rootfs/usr/share
	- rm -f ${ROOTFS_DEBUG}/rootfs/usr/lib/pt_chown
	- rm -f ${ROOTFS_DEBUG}/rootfs/usr/lib/libgettext*
	- rm -f ${ROOTFS_DEBUG}/rootfs/usr/bin/{perl,runtest,diff,gawk,getent,ipcs,locale,nm,rexec,rsh,thread-ex,fdformat,tclsh,tclsh8.4,udevinfo,udevtest,pftp}
	- rm -f ${ROOTFS_DEBUG}/rootfs/usr/bin/msg*
	- rm -f ${ROOTFS_DEBUG}/rootfs/usr/sbin/iconvconfig
	- rm -f ${ROOTFS_DEBUG}/rootfs/usr/sbin/in.*d
	- rm -f ${ROOTFS_DEBUG}/rootfs/usr/sbin/{groupadd,groupdel,groupmems,groupmod,useradd,userdel,usermod,inetd}
	- rm -fr ${ROOTFS_DEBUG}/rootfs/bin/{bash,mount,mountpoint,ipcs,umount,fdformat}
	- rm -f ${ROOTFS_DEBUG}/rootfs/bin/{sh,ping}
	#cp ${CLFS_SOURCE}/binary/mount{,point} ${ROOTFS_DEBUG}/rootfs/bin
	- cp -f ${CLFS_BUILD}/${SYSVINIT_FOLDER}/src/mountpoint ${ROOTFS_DEBUG}/rootfs/bin
	#cp -f ${CLFS_BUILD}/${SYSVINIT_FOLDER}/src/init ${ROOTFS_DEBUG}/rootfs/sbin
	- cp -f ${CLFS_BUILD}/${UTIL_LINUX_FOLDER}/mount/{mount,umount} ${ROOTFS_DEBUG}/rootfs/bin
	- cp -f ${CLFS_BUILD}/${UTIL_LINUX_FOLDER}/sys-utils/ipcs       ${ROOTFS_DEBUG}/rootfs/bin
	- cp -f ${CLFS_BUILD}/${UTIL_LINUX_FOLDER}/disk-utils/fdformat  ${ROOTFS_DEBUG}/rootfs/bin
	- find ${ROOTFS_DEBUG}/rootfs -name pidof | xargs rm -f
	- find ${ROOTFS_DEBUG}/rootfs -name nice | xargs rm -f
	- find ${ROOTFS_DEBUG}/rootfs -name klogd | xargs rm -f
	- find ${ROOTFS_DEBUG}/rootfs -name syslogd | xargs rm -f
	- find ${ROOTFS_DEBUG}/rootfs -name killall5 | xargs rm -f
	- cp -f ${CLFS_BUILD}/${SYSVINIT_FOLDER}/src/killall5 ${ROOTFS_DEBUG}/rootfs/bin
	cd ${ROOTFS_DEBUG}/rootfs/bin && \
	ln -sf busybox ping && \
	ln -sf busybox nice && \
	ln -sf busybox syslogd && \
	ln -sf busybox klogd && \
	ln -sf busybox sh
	for i in libc libpthread; do \
		if file ${ROOTFS_DEBUG}/rootfs/lib/$$i.so | grep ASCII; then \
			pushd ${ROOTFS_DEBUG}/rootfs/lib; \
			rm -f $$i.so; ln -s $$i-*.*.so $$i.so; \
			popd; \
		fi; \
	done


toolchain_release:
	rm -rf ${CROSS_TOOLS}/gcc/lib/libiberty.a
	rm -rf ${CROSS_TOOLS}/binutils/lib/libiberty.a
# Put binutils/gcc/glibc in different tarball.
	mkdir -p ${CROSS_TOOLS}/release/toolchain/
	cd ${CROSS_TOOLS}/binutils/ && \
	tar czf ${CROSS_TOOLS}/release/${BINUTILS_NAME}_${BINUTILS_VERSION}_${LINUX_VERSION}_${FAMILY}.tar.gz ./
	
	cd ${CROSS_TOOLS}/gcc/	&& \
	tar czf ${CROSS_TOOLS}/release/${GLIBC_NAME}_${GLIBC_VERSION}_${LINUX_VERSION}_${FAMILY}-${FPU}.tar.gz ./sysroot
	
	mv ${CROSS_TOOLS}/gcc/sysroot ${CROSS_TOOLS}
	cd ${CROSS_TOOLS}/gcc/ && \
	tar czf ${CROSS_TOOLS}/release/${GCC_NAME}_${GCC_VERSION}_${LINUX_VERSION}_${FAMILY}-${FPU}.tar.gz ./
# Merge binutils/gcc/glibc in one.
	mv ${CROSS_TOOLS}/sysroot ${CROSS_TOOLS}/gcc
	cp -a ${CROSS_TOOLS}/gcc/. ${CROSS_TOOLS}/release/toolchain
	cp -a ${CROSS_TOOLS}/binutils/. ${CROSS_TOOLS}/release/toolchain
	cd ${CROSS_TOOLS}/release/toolchain && \
	tar czf ${CROSS_TOOLS}/release/gnu-toolchain_${GCC_VERSION}_${LINUX_VERSION}_${FAMILY}-${FPU}.tar.gz ./
	
	@echo " "
	@echo "===============Toolchain build successfullly==============="
	@echo " The toolchain is located in ${CROSS_TOOLS}/release/."
	@echo " - ${BINUTILS_NAME}_${BINUTILS_VERSION}_${LINUX_VERSION}_${FAMILY}.tar.gz \\" 
	@echo "   ${GLIBC_NAME}_${GLIBC_VERSION}_${LINUX_VERSION}_${FAMILY}-${FPU}.tar.gz \\"
	@echo "   and ${GCC_NAME}_${GCC_VERSION}_${LINUX_VERSION}_${FAMILY}-${FPU}.tar.gz are 3 part3 of the toolchain."
	@echo " - gnu-toolchain_${GCC_VERSION}_${LINUX_VERSION}_${FAMILY}-${FPU}.tar.gz is the whole toolchain."
	@echo " - toolchain/* are uncompressed files of gnu-toolchain_${GCC_VERSION}_${LINUX_VERSION}_${FAMILY}-${FPU}.tar.gz."	
src:
	cd ${CROSS_SRC_HOME} && \
	if [ -d ${MTC} ]; then  \
		rm -fr ${MTC}; \
	fi && \
	mkdir -pv ${SRC_PRE_PATH} && \
	mv ${CLFS_SOURCE} Makefile common.mak xbuild.sh ${SRC_PRE_PATH} && \
	tar zcf ${STAMP}-${MTC}-all-src.tgz ${MTC} && \
	mv ${SRC_PRE_PATH}/* . && \
	rm -fr ./${MTC} && \
	cp Makefile ${STAMP}-${MTC}-all-src.mak

src_all:
	cd ${CROSS_SRC_HOME} && \
	if [ -d ${MTC} ]; then  \
		rm -fr ${MTC}; \
	fi && \
	mkdir -pv ${SRC_PRE_PATH} && \
	if [ -d test/build ]; then mv test/build build-of-test; fi && \
	mv test ${CLFS_SOURCE} Makefile xbuild.sh ${SRC_PRE_PATH} && \
	tar zcf ${STAMP}-${MTC}-all-src-with-test.tgz ${MTC} && \
	mv ${SRC_PRE_PATH}/* . && \
	if [ -d build-of-test -a -d test ]; then mv build-of-test test/build; fi && \
	rm -fr ./${MTC} && \
	cp Makefile ${STAMP}-${MTC}-all-src.mak
