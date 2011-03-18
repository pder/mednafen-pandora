# Picklelauncher makefile

PROGRAM = picklelauncher
LIB_ZIP = libunzip.a

# Build type
#BUILDTYPE = debug
BUILDTYPE = release
BUILDTARGET = PANDORA
# Compiler flags
CXXFLAGS     = -g -Wall -Wextra -O3
ZIP_CFLAGS   = $(CXXFLAGS)
# Linker flags
BASE_LDFLAGS = -L$(LIBRARY) -lSDL_ttf -lSDL_image -lSDL
ZIP_LDFLAGS  = -L$(LIBRARY) -lz

# Target compiler options
ifeq ($(BUILDTARGET),PANDORA)
PREFIX   = $(HOME)/pandora-dev/arm-2010.09
TOOLS    = bin
TARGET   = arm-none-linux-gnueabi-
INCLUDE  = $(PREFIX)/usr/include
LIBRARY  = $(PREFIX)/usr/lib
CXXFLAGS += -DPANDORA
LDFLAGS  = $(BASE_LDFLAGS) -lfreetype -ltiff -lpng12 -lz -ljpeg -lts
else
ifeq ($(BUILDTARGET),CAANOO)
PREFIX   = /mythtv/media/devel/toolchains/caanoo/GPH_SDK
TOOLS    = tools/gcc-4.2.4-glibc-2.7-eabi/bin
TARGET   = arm-gph-linux-gnueabi-
INCLUDE  = $(PREFIX)/DGE/include
LIBRARY  = $(PREFIX)/DGE/lib/target
CXXFLAGS += -DCAANOO
LDFLAGS  = $(BASE_LDFLAGS)
else
ifeq ($(BUILDTARGET),WIZ)
PREFIX   = /mythtv/media/devel/toolchains/openwiz/arm-openwiz-linux-gnu
TOOLS    = bin
TARGET   = arm-openwiz-linux-gnu-
INCLUDE  = $(PREFIX)/include
LIBRARY  = $(PREFIX)/lib
CXXFLAGS += -DWIZ
LDFLAGS  = $(BASE_LDFLAGS) -lfreetype -lz
else
ifeq ($(BUILDTARGET),GP2X)
PREFIX   = /mythtv/media/devel/toolchains/open2x/gcc-4.1.1-glibc-2.3.6
TOOLS    = bin
TARGET   = arm-open2x-linux-
INCLUDE  = $(PREFIX)/include
LIBRARY  = $(PREFIX)/lib
CXXFLAGS += -DGP2X
LDFLAGS  = -static $(BASE_LDFLAGS) -lfreetype -lz -lpng12 -lpthread -ldl
else # default linux
PREFIX   = /usr
TOOLS    = bin
TARGET   =
INCLUDE  = $(PREFIX)/include
LIBRARY  = $(PREFIX)/lib
LDFLAGS  = $(BASE_LDFLAGS)
endif
endif
endif
endif

# Assign includes
CXXFLAGS += -I$(INCLUDE) -I$(INCLUDE)/SDL

ifeq ($(BUILDTYPE),debug)
CXXFLAGS += -DDEBUG
endif

# Source files
SRCS       = main.cpp cselector.cpp cprofile.cpp cconfig.cpp csystem.cpp czip.cpp cbase.cpp
SRCS_ZIP   = ioapi.c unzip.c

# Assign paths to binaries/sources/objects
BUILD      = build
SRCDIR     = src
SRCDIR_ZIP = $(SRCDIR)/unzip
OBJDIR     = $(BUILD)/objs/$(BUILDTYPE)

SRCS       := $(addprefix $(SRCDIR)/,$(SRCS)) 
OBJS       := $(addprefix $(OBJDIR)/,$(SRCS:.cpp=.o)) 
SRCS_ZIP   := $(addprefix $(SRCDIR_ZIP)/,$(SRCS_ZIP)) 
OBJS_ZIP   := $(addprefix $(OBJDIR)/,$(SRCS_ZIP:.c=.o)) 

LIB_ZIP    := $(addprefix $(OBJDIR)/,$(LIB_ZIP)) 
PROGRAM    := $(addprefix $(BUILD)/,$(PROGRAM)) 

# Assign Tools
CC  = $(PREFIX)/$(TOOLS)/$(TARGET)gcc
CXX = $(PREFIX)/$(TOOLS)/$(TARGET)g++
AR  = $(PREFIX)/$(TOOLS)/$(TARGET)ar

# Build rules
all : setup $(LIB_ZIP) $(PROGRAM)

setup:
	mkdir -p $(OBJDIR)/$(SRCDIR_ZIP)

$(LIB_ZIP): $(OBJS_ZIP)
	$(AR) rcs $(LIB_ZIP) $(OBJS_ZIP)

$(PROGRAM): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $(PROGRAM) $(OBJS) $(LIB_ZIP) $(LDFLAGS) 

$(OBJDIR)/$(SRCDIR_ZIP)/%.o: $(SRCDIR_ZIP)/%.c
	$(CC) $(ZIP_CFLAGS) -c $< -o $@

$(OBJDIR)/$(SRCDIR)/%.o: $(SRCDIR)/%.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -f $(PROGRAM) $(OBJS) $(LIB_ZIP) $(OBJS_ZIP)
