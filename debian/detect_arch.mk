# More info see: /usr/share/dpkg/cputable

ifeq ($(DEB_HOST_ARCH_CPU), amd64)
  CPU = x86_64
endif
ifeq ($(DEB_HOST_ARCH_CPU), i386)
  CPU = x86
endif
ifeq ($(DEB_HOST_ARCH_CPU), arm)
  CPU = arm
endif
ifeq ($(DEB_HOST_ARCH_CPU), armhf)
  CPU = arm
endif
ifeq ($(DEB_HOST_ARCH_CPU), mips)
  CPU = mips
endif
ifeq ($(DEB_HOST_ARCH_CPU), mipsel)
  CPU = mips
endif