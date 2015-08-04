include debian/detect_arch.mk

CPU_SOURCES = is_fpreg.c \
               regname.c \
               Gcreate_addr_space.c \
               Gget_proc_info.c \
               Gget_save_loc.c \
               Gglobal.c \
               Ginit.c \
               Ginit_local.c \
               Ginit_remote.c \
               Gregs.c \
               Gresume.c \
               Gstep.c \
               Lcreate_addr_space.c \
               Lget_proc_info.c \
               Lget_save_loc.c \
               Lglobal.c \
               Linit.c \
               Linit_local.c \
               Linit_remote.c \
               Lregs.c \
               Lresume.c \
               Lstep.c
ARM_SOURCES = $(foreach sources, $(CPU_SOURCES), src/arm/$(sources)) \
              src/arm/getcontext.S \
              src/arm/Gis_signal_frame.c \
              src/arm/Gex_tables.c \
              src/arm/Lis_signal_frame.c \
              src/arm/Lex_tables.c \
              src/elf32.c
ARM64_SOURCES = $(foreach sources, $(CPU_SOURCES), src/aarch64/$(sources)) \
                src/aarch64/Gis_signal_frame.c \
                src/aarch64/Lis_signal_frame.c \
                src/elf64.c
MIPS_SOURCES = $(foreach sources, $(CPU_SOURCES), src/mips/$(sources)) \
               src/mips/getcontext-android.S \
               src/mips/Gis_signal_frame.c \
               src/mips/Lis_signal_frame.c \
               src/elf32.c
MIPS64_SOURCE = $(MIPS_SOURCES) src/elf64.c
X86_SOURCES = $(foreach sources, $(CPU_SOURCES), src/x86/$(sources)) \
              src/x86/getcontext-linux.S \
              src/x86/Gos-linux.c \
              src/x86/Los-linux.c \
              src/elf32.c
X86_64_SOURCES = $(foreach sources, $(CPU_SOURCES), src/x86_64/$(sources)) \
                 src/x86_64/getcontext.S \
                 src/x86_64/Gstash_frame.c \
                 src/x86_64/Gtrace.c \
                 src/x86_64/Gos-linux.c \
                 src/x86_64/Lstash_frame.c \
                 src/x86_64/Ltrace.c \
                 src/x86_64/Los-linux.c \
                 src/x86_64/setcontext.S \
                 src/elf64.c
ARM_INCLUDES = -Iinclude/tdep-arm
ARM64_INCLUDES = -Iinclude/tdep-aarch64
MIPS_INCLUDES = -Iinclude/tdep-mips
MIPS64_INCLUDES = $(MIPS_INCLUDES)
X86_INCLUDES = -Iinclude/tdep-x86
X86_64_INCLUDES = -Iinclude/tdep-x86_64

NAME = libunwind
SOURCES = src/mi/init.c \
          src/mi/flush_cache.c \
          src/mi/mempool.c \
          src/mi/strerror.c \
          src/mi/backtrace.c \
          src/mi/dyn-cancel.c \
          src/mi/dyn-info-list.c \
          src/mi/dyn-register.c \
          src/mi/map.c \
          src/mi/Lmap.c \
          src/mi/Ldyn-extract.c \
          src/mi/Lfind_dynamic_proc_info.c \
          src/mi/Lget_proc_info_by_ip.c \
          src/mi/Lget_proc_name.c \
          src/mi/Lput_dynamic_unwind_info.c \
          src/mi/Ldestroy_addr_space.c \
          src/mi/Lget_reg.c \
          src/mi/Lset_reg.c \
          src/mi/Lget_fpreg.c \
          src/mi/Lset_fpreg.c \
          src/mi/Lset_caching_policy.c \
          src/mi/Gdyn-extract.c \
          src/mi/Gdyn-remote.c \
          src/mi/Gfind_dynamic_proc_info.c \
          src/mi/Gget_accessors.c \
          src/mi/Gget_proc_info_by_ip.c \
          src/mi/Gget_proc_name.c \
          src/mi/Gput_dynamic_unwind_info.c \
          src/mi/Gdestroy_addr_space.c \
          src/mi/Gget_reg.c \
          src/mi/Gset_reg.c \
          src/mi/Gget_fpreg.c \
          src/mi/Gset_fpreg.c \
          src/mi/Gset_caching_policy.c \
          src/dwarf/Lexpr.c \
          src/dwarf/Lfde.c \
          src/dwarf/Lparser.c \
          src/dwarf/Lpe.c \
          src/dwarf/Lstep_dwarf.c \
          src/dwarf/Lfind_proc_info-lsb.c \
          src/dwarf/Lfind_unwind_table.c \
          src/dwarf/Gexpr.c \
          src/dwarf/Gfde.c \
          src/dwarf/Gfind_proc_info-lsb.c \
          src/dwarf/Gfind_unwind_table.c \
          src/dwarf/Gparser.c \
          src/dwarf/Gpe.c \
          src/dwarf/Gstep_dwarf.c \
          src/dwarf/global.c \
          src/os-common.c \
          src/os-linux.c \
          src/Los-common.c
CFLAGS += -fPIC -DHAVE_CONFIG_H -DNDEBUG -D_GNU_SOURCE
CPPFLAGS += -Iinclude -Isrc
LDFLAGS += -fPIC -shared -Wl,-soname,$(NAME).so.8 -ldl -lpthread

ifeq ($(CPU), arm)
  SOURCES += $(ARM_SOURCES)
  CPPFLAGS += $(ARM_INCLUDES)
endif
ifeq ($(CPU), arm64)
  SOURCES += $(ARM64_SOURCES)
  CPPFLAGS += $(ARM64_INCLUDES)
endif
ifeq ($(CPU), mips)
  SOURCES += $(MIPS_SOURCES)
  CPPFLAGS += $(MIPS_INCLUDES)
endif
ifeq ($(CPU), mips64)
  SOURCES += $(MIPS64_SOURCES)
  CPPFLAGS += $(MIPS64_INCLUDES)
endif
ifeq ($(CPU), x86)
  SOURCES += $(X86_SOURCES)
  CPPFLAGS += $(X86_INCLUDES)
endif
ifeq ($(CPU), x86_64)
  SOURCES += $(X86_64_SOURCES)
  CPPFLAGS += $(X86_64_INCLUDES)
endif

build: $(SOURCES)
	cc $^ -o $(NAME).so.$(SOVERSION) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS)

clean:
	rm -f *.so.*