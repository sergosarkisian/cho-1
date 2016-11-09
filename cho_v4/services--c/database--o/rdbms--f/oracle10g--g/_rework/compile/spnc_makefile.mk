I_SYM=-I

PLSQLHOME=$(ORACLE_HOME)/plsql/

# PLSQL include
PLSQLINCLUDE=$(PLSQLHOME)include/
PLSQLINCLUDEH=$(I_SYM)$(PLSQLINCLUDE)

# PLSQL public
PLSQLPUBLIC=$(PLSQLHOME)public/
PLSQLPUBLICH=$(I_SYM)$(PLSQLPUBLIC)

#
# File extensions
#
SO_EXT=so
OBJ_EXT=o
SRC_EXT=c

#
# C compiler flags
#
CC=/db/_oralck/agcc
OPTIMIZE=-O3
PIC=-fPIC

NCOMPINCLUDE=$(PLSQLINCLUDEH) $(PLSQLPUBLICH)
PFLAGS=$(NCOMPINCLUDE)
ifeq ($(BUILD_CC),TRUE)
  CFLAGS=$(OPTIMIZE) $(PFLAGS) $(PIC) -fp
else
  CFLAGS=$(OPTIMIZE) $(PFLAGS) $(PIC)
endif

RM=/bin/rm -f

#
# Compile Rule
#
COMPO=$(CC) $*.$(SRC_EXT) -c -o $*.$(OBJ_EXT) $(CFLAGS)
COMPILE.c=COMPO

#
# Specify Linker and Linker flags
#
LD=/usr/bin/ld
LDFLAGS=-shared -o $@
SO_COMMAND=$(LD) $(LDFLAGS) $(SHARED_CFLAG) $*.$(OBJ_EXT)

.SILENT:

#
# To create shared libraries
#
%.$(SO_EXT): FORCE
	-mv $@ $@.$$$$
	$($(COMPILE.c))
	$(SO_COMMAND)
	$(RM) -f $*.$(SRC_EXT) $*.$(OBJ_EXT)

FORCE:
