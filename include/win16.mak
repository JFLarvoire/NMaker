###############################################################################
#									      #
#   File name:	    win16.mak						      #
#									      #
#   Description:    A NMake makefile to build WIN16 programs		      #
#									      #
#   Notes:	    Use with make.bat, which defines the necessary variables. #
#		    Usage: make -f lodos.mak [definitions] [targets]	      #
#									      #
#		    WIN16 programs are the original type of Windows programs, #
#		    that run in 16-bits mode.                                 #
#		    They're built using the same set of tools as DOS programs.#
#		    							      #
#		    Targets:						      #
#		    clean	    Erase all files in the WIN16 subdirectory.#
#		    {prog}.obj	    Build WIN16[\Debug]\OBJ\{prog}.obj.	      #
#		    WIN16\{prog}.com       Build the WIN16 release version.   #
#		    WIN16\Debug\{prog}.com Build the WIN16 debug version.     #
#		    WIN16\OBJ\{prog}.obj   Compile the WIN16 release version. #
#		    WIN16\Debug\OBJ\{prog}.obj Compile the WIN16 debug version.
#									      #
#		    Command-line definitions:				      #
#		    DEBUG=0	 Build the release ver. (<=> program in WIN16)#
#		    DEBUG=1	 Build the debug ver. (<=> pgm in WIN16\DEBUG)#
#		    MEM=S	 Build the small ver. (<=> objects in OBJ\S)  #
#		    MEM=L	 Build the large ver. (<=> objects in OBJ\L)  #
#		    OUTDIR=path  Output to path\WIN16\. Default: To bin\WIN16\#
#		    PROGRAM=name Set the output file base name		      #
#									      #
#		    The MEM variable is left to minimize differences with     #
#		    the DOS.MAK make file. But the default value S should     #
#		    work in all cases here.				      #
#		    							      #
#		    Likewise, rules for building .exe targets are left in.    #
#		    They should never be needed either.			      #
#		    							      #
#		    If a specific target [path\]{prog}.com is specified,      #
#		    includes the corresponding {prog}.mak if it exists.       #
#		    This make file, defines the files to use beyond the       #
#		    default {prog}.c/{prog}.obj; Compiler options; etc.       #
#		    SOURCES	Source files to compile.		      #
#		    OBJECTS	Object files to link. Optional.		      #
#		    PROGRAM	The node name of the program to build. Opt.   #
#		    EXENAME	The file name of the program to build. Opt.   #
#		    SKIP_THIS	Message explaining why NOT to build. Opt.     #
#									      #
#		    In the absence of a {prog}.mak file, or if one of the     #
#		    generic targets is used, then the default Files.mak is    #
#		    used instead. Same definitions.			      #
#									      #
#		    Note that these sub-make files are designed to be	      #
#		    OS-independant. The goal is to reuse them to build	      #
#		    the same program under Unix/Linux too. So for example,    #
#		    all paths must contain forward slashes.		      #
#									      #
#		    Another design goal is to use that same WIN16.mak	      #
#		    in complex 1-project environments (One Files.mak defines  #
#		    all project components); And in simple multiple-project   #
#		    environments (No Files.mak; Most programs have a single   #
#		    source file, and use default compiler options).	      #
#									      #
#		    The following macros / environment variables must be      #
#		    predefined. This allows to use the same makefile on       #
#		    machines with various locations for the build tools.      #
#									      #
#		    AS	    	16-bits Assembler			      #
#		    CC16    	16-bits C compiler			      #
#		    INCPATH16  	16-bits include files paths		      #
#		    LINK16  	16-bits Linker				      #
#		    LIBPATH16   16-bits libraries paths			      #
#		    LIB16   	16-bits librarian     			      #
#		    MAPSYM	16-bits Linker .map file to .sym converter    #
#		    TMP	    	Temporary directory	 		      #
#									      #
#  History:								      #
#    2023-12-09 JFL Adapted from LODOS.mak.                                   #
#		    							      #
#                   © Copyright 2023 Jean-François Larvoire                   #
# Licensed under the Apache 2.0 license - www.apache.org/licenses/LICENSE-2.0 #
###############################################################################

!IF !DEFINED(T)
T=WIN16				# Target OS
!ENDIF

!IF !DEFINED(T_VARS)
T_VARS=1	# Make sure OS-type-specific variables are defined only once

T_DEFS=/D_WIN16			# Tell sources what environment they're built for

# Memory model for 16-bit C compilation (T|S|C|D|L|H)
!IF !DEFINED(MEM)
MEM=S				# Memory model for C compilation
MEM_ORIG=default
!ELSEIF !DEFINED(MEM_ORIG)
MEM_ORIG=user-defined
!ENDIF

EXE=exe				# Default program extension

STARTCOM=
STARTEXE=

CODEPAGE=$(DOS_CS)		# Use the user-defined code page

# Tools and options
CGFLAGS=/Gsw /Oas /Zpe		# C code generation flags

# LFLAGSX=/nod			# Extra linker flags

INCPATH=$(DOS_INCPATH)
LIBPATH=$(DOS_LIBPATH)
LIBS=libw.lib + slibcew.lib
!IF DEFINED(SYSLIB)
INCPATH=$(INCPATH);$(SYSLIB)
!IF 0 # Use the syslibXXX.lib copy of syslib.lib in $(OUTDIR)\LIB
LIBPATH=$(LIBPATH);$(SYSLIB)\$(OUTDIR)\LIB
LIBS=$(LIBS) + syslib$(LSX).lib
!ELSE # Use the initial $(T)-specific syslib.lib in $(OUTDIR)\$(T)$(DS)\BIN\T
LIBPATH=$(LIBPATH);$(SYSLIB)\$(OUTDIR)\$(T)$(DS)\T
LIBS=$(LIBS) + syslib.lib
!ENDIF
!ENDIF

# Library SuffiX. For storing multiple versions of the same library in a single directory.
LSX=d

!ENDIF # !DEFINED(T_VARS)

###############################################################################
#									      #
#		      End of OS-type-specific definitions		      #
#									      #
###############################################################################

!IF !DEFINED(DOS_INFERENCE_RULES)
!INCLUDE "DOS.mak"
!ENDIF
