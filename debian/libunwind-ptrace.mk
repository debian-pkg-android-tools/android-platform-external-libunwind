include debian/detect_arch.mk

ARM_INCLUDES = -Iinclude/tdep-arm
ARM64_INCLUDES = -Iinclude/tdep-aarch64
MIPS_INCLUDES = -Iinclude/tdep-mips
MIPS64_INCLUDES = $(MIPS_INCLUDES)
X86_INCLUDES = -Iinclude/tdep-x86
X86_64_INCLUDES = -Iinclude/tdep-x86_64

NAME = libunwind-ptrace
SOURCES = src/ptrace/_UPT_elf.c \
          src/ptrace/_UPT_accessors.c \
          src/ptrace/_UPT_access_fpreg.c \
          src/ptrace/_UPT_access_mem.c \
          src/ptrace/_UPT_access_reg.c \
          src/ptrace/_UPT_create.c \
          src/ptrace/_UPT_destroy.c \
          src/ptrace/_UPT_find_proc_info.c \
          src/ptrace/_UPT_get_dyn_info_list_addr.c \
          src/ptrace/_UPT_put_unwind_info.c \
          src/ptrace/_UPT_get_proc_name.c \
          src/ptrace/_UPT_reg_offset.c \
          src/ptrace/_UPT_resume.c
OBJECTS = $(SOURCES:.c=.o)
CFLAGS += -fPIC -c -DHAVE_CONFIG_H -DNDEBUG -D_GNU_SOURCE
CPPFLAGS += -Iinclude -Isrc
LDFLAGS += -fPIC -shared -Wl,-soname,$(NAME).so.8 -lpthread

ifeq ($(CPU), arm)
  CPPFLAGS += $(ARM_INCLUDES)
endif
ifeq ($(CPU), arm64)
  CPPFLAGS += $(ARM64_INCLUDES)
endif
ifeq ($(CPU), mips)
  CPPFLAGS += $(MIPS_INCLUDES)
endif
ifeq ($(CPU), mips64)
  CPPFLAGS += $(MIPS64_INCLUDES)
endif
ifeq ($(CPU), x86)
  CPPFLAGS += $(X86_INCLUDES)
endif
ifeq ($(CPU), x86_64)
  CPPFLAGS += $(X86_64_INCLUDES)
endif

build: $(OBJECTS)
	cc $^ -o $(NAME).so.$(SOVERSION) $(LDFLAGS)
	ar rs $(NAME).a $^

clean:
	rm -f *.so.* *.a $(OBJECTS)

$(OBJECTS): %.o: %.c
	cc $< -o $@ $(CFLAGS) $(CPPFLAGS)