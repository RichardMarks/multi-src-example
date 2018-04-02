# set the CC variable to use gcc if it hasn't been set already
# note: CC is set to clang on OSX by default
CC ?= gcc

# set compile (cc) flags if they are not already set
# the following part uses a shell call to execute pkg-config and get the flags for the libraries
# $(shell pkg-config glew glfw3 --cflags)
# the following part turns off optimizations
# -O0
CFLAGS ?= $(shell pkg-config glew glfw3 --cflags) -O0

# set linker (ld) flags if they have not been set already
# the following part uses a shell call to execute pkg-config and get the flags for the libraries
# $(shell pkg-config glew glfw3 --libs)
# the following part is needed to allow otool to have space to update the dylib paths for .app bundling
# -Wl,-headerpad_max_install_names
# the following says to link against the OpenGL OSX system Framework
# -framework OpenGL
LDFLAGS ?= $(shell pkg-config glew glfw3 --libs) -Wl,-headerpad_max_install_names -framework OpenGL

# set the name of the target executable if it has not been set
TARGET_EXEC ?= game

# set the path to the build directory if it has not been set
# (where target executable and all intermediate files will be)
BUILD_DIR ?= ./bin

# sets the path to the source code directory if it has not been set
SRC_DIRS ?= ./src

# use shell call to find all .c files in the source directories
SRCS := $(shell find $(SRC_DIRS) -name *.c)

# use pattern substition to map .c source file names to .o file names in the build directory
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)

# map each .o file name to a .d dependency file name
DEPS := $(OBJS:.o=.d)

# use shell call to get a list of include paths recursively from the source directories
INC_DIRS := $(shell find $(SRC_DIRS) -type d)

# prefix every include path with -I compiler flag to tell the compiler about the include path
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

# define make rule that the target executable in the build directory depends on all .o files
$(BUILD_DIR)/$(TARGET_EXEC): $(OBJS)
# link the .o files to create the target executable
# $@ is the target executable
	$(CC) $(OBJS) -o $@ $(LDFLAGS)

# define make rule that the .o files depend on .c files
$(BUILD_DIR)/%.c.o: %.c
# create the directory if it does not exist
	$(MKDIR_P) $(dir $@)
# compile the .c file to the target .o file
# $(INC_FLAGS) passes all include paths we set above to the compiler
# -MMD used to generate a dependency output file as a side-effect of the compilation process. - mention only user header files, not system header files.
# -MP This option instructs CPP to add a phony target for each dependency other than the main file, causing each to depend on nothing. These dummy rules work around errors make gives if you remove header files without updating the Makefile to match.
# -g is debugging info
# $(CFLAGS) passes all the compiler flags we set above to the compiler
# -c means we only want to compile and not link
# $< is the .c file being compiled
# -o means the next param is the output filename of the compilation
# $@ is the .o file output from the compilation
	$(CC) $(INC_FLAGS) -MMD -MP -g $(CFLAGS) -c $< -o $@

# specify "clean" as being a phony target: https://www.gnu.org/software/make/manual/html_node/Phony-Targets.html
.PHONY: clean

clean:
# recursively remove build directory contents
	$(RM) -r $(BUILD_DIR)

# tell make to ignore the .d dependencies
# https://www.gnu.org/software/make/manual/html_node/Include.html
-include $(DEPS)

# define an alias that creates a full path if it does not exist
MKDIR_P ?= mkdir -p
