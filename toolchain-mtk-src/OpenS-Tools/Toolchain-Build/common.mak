CLFS_HOST = i686-pc-linux-gnu
CLFS_TARGET ?= arm-unknown-linux

ifndef TOOLCHAIN_GCC_VERSION
$(error "Please set TOOLCHAIN_GCC_VERSION!")
endif

# like 441_001
TOOLCHAIN_MINI_SUFFIX=$(subst .,,$(TOOLCHAIN_GCC_VERSION))_001_${FPU}

# The toolchain source directory.
ifndef CROSS_SRC_HOME
$(error "Please set CROSS_SRC_HOME!")
endif
CLFS_SOURCE = ${CROSS_SRC_HOME}
# The toolchain install directory.
# INSTALL_DIR_PREFIX ?= /opt/usr/toolchain-${TOOLCHAIN_GCC_VERSION}
INSTALL_DIR_PREFIX ?= /tmp/${USER}/usr/toolchain-${TOOLCHAIN_GCC_VERSION}-${FPU}
CROSS_TOOLS_BASE = ${INSTALL_DIR_PREFIX}
CROSS_TOOLS = ${CROSS_TOOLS_BASE}/${FAMILY}

CLFS_ROOT_BASE = ${CROSS_TOOLS}/gcc/sysroot
CLFS_ROOT = ${CLFS_ROOT_BASE}

ROOTFS_DEBUG_BASE = ${CROSS_TARGET_HOME}/debug
ROOTFS_DEBUG = ${ROOTFS_DEBUG_BASE}/${FAMILY}

# The toolchain build directory.
BUILD_DIR_PREFIX ?= /tmp/${USER}/build
CLFS_BUILD_BASE = ${BUILD_DIR_PREFIX}
CLFS_BUILD = ${CLFS_BUILD_BASE}/${FAMILY}
# INTERNAL_BUILD = ${CLFS_BUILD_BASE}/$(shell arch)
INTERNAL_BUILD = ${CLFS_BUILD_BASE}/i686

#BIN_PREFIX=${FAMILY}_mtk_le
# armv6z-mediatek-linux-gnueabi => armv6z-mediatek441_001-linux-gnueabi
BIN_PREFIX=$(subst $(strip $(word 2, $(subst -, ,$(strip $(CLFS_TARGET))))),$(strip $(word 2, $(subst -, ,$(strip $(CLFS_TARGET))))$(TOOLCHAIN_MINI_SUFFIX)),$(strip $(CLFS_TARGET)))
FAKE_BINPREFIX=BINPREFIX
MAKEFLAG = -j4


PATH = ${CROSS_TOOLS}/binutils/bin:${CROSS_TOOLS}/gcc/bin:${INTERNAL_BUILD}/gcc-install/bin:${INTERNAL_BUILD}/bin:/bin:/usr/local/bin:/usr/bin
###PATH = ${CROSS_TOOLS}/bin:${GCC_BUILD}/gcc:/bin:/usr/local/bin:/usr/bin
LD_LIBRARY_PATH=${CLFS_ROOT}/usr/lib:${CLFS_ROOT}/lib:${CROSS_TOOLS}/${CLFS_HOST}/${CLFS_TARGET}/lib:$$LD_LIBRARY_PATH
#${CROSS_TOOLS}/lib

#$(shell LD_LIBRARY_PATH=`echo ${CROSS_TOOLS}/${CLFS_HOST}/${CLFS_TARGET}/lib:echo $$LD_LIBRARY_PATH`)
CFLAGS =
CXXFLAGS =
STAMP = $(shell echo "`date +%Y%m%d_%0k%M`")



ifeq "${ccache}" ""
CCACHE = $(shell if [ -n "`which ccache 2> /dev/null`" ]; then \
			echo "ccache"; \
	 	 fi)
else
CCACHE =
endif
XGCC_REAL_COMMAND = ${BIN_PREFIX}-gcc ${GCC_FP_OPTION} ${GCC_EABI_OPTION}
CCACHE_GCC = "${CCACHE} gcc"
CCACHE_GXX = "${CCACHE} g++"
#CROSS_GCC = ${CCACHE} ${XGCC_REAL_COMMAND}
CROSS_GCC = ${XGCC_REAL_COMMAND}
#CCACHE_CROSS_GCC = ${CCACHE} ${XGCC_REAL_COMMAND}
CCACHE_CROSS_GCC = ${XGCC_REAL_COMMAND}

export 
