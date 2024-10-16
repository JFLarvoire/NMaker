NMaker - A Multi OS make system based on nmake
==============================================

A command-line make system, allowing to build multiple versions of a program, for DOS, Windows, and Unix,
from a single set of C/C++ sources, using Microsoft tools for the DOS and Windows parts.
It is very useful on a PC with multiple VMs with Windows and Unix, each having access to common sources on the host.

The [include](include/) subdirectory contains include files extending the Microsoft nmake.exe system, and giving it a Unix make feel.  
It was initially developped for building the [System Tools Library](https://github.com/JFLarvoire/SysToolsLib) C tools.  
Then, as it proved useful for building other projects, it was split off of the System Tools Library, into its own repository.
NMaker can now be used as a git sub-module for the System Tools Library, or any other multi-OS project.

Home page: [NMaker](https://github.com/JFLarvoire/NMaker)

File names      | Descrition
--------------- | -----------------------------------------------------
*.bat           | Windows scripts for building components using the Visual C++ compiler tools.
*.h             | C language macros, for defining OS and build versions, for DOS, Windows, and Unix.
*.mak           | Windows nmake files for building DOS and Windows components using the Visual C++ compiler tools.

The project name _NMaker_ is a nostalgic allusion to the old nmaker.exe program, the last version of nmake for DOS.

### Features

* Easily build multiple versions of the same program, for various operating system and processor combinations.
* Build in parallel from common sources. No need to copy sources all around.
* Build universal executables that work in *all* Microsoft operating systems, from DOS 5 to Windows 95 to Windows 10.
* Define recursive projects with a few simple make files describing _what_ to build, not how.
* Configure and make scripts for Visual C++ nmake.exe, with a look and feel similar to Unix standards.
* Supports Visual C++ 8 (For building in Windows 10 for DOS and Windows 95) to Visual C++ 16 (For Windows 7 and later).
* Builds by default the release version for the current OS.


### License

[The Apache 2 license](https://www.apache.org/licenses/LICENSE-2.0)  
(Compatible with most other project licenses; Does not "contaminate" them!)


Requirements and options
------------------------

All NMaker system scripts are batch scripts designed to run in the cmd.exe shell of modern Windows systems.
They used to work in Windows XP, and may still do, but this has not been tested for a long time.
They're likely to work in Windows 7, but again this is rarely tested.
It's recommended to do builds in Windows 10 or 11.

1. Required: A recent version of Microsoft Visual C++. 
   This allows building things in your version of Windows, for your version of Windows.
   But even when building for DOS or Windows 95 with the optional tools below, some tools from a recent VC++ are required.
   If needed, it's part of the free Visual Studio Community Edition, available from this URL:  
   https://www.visualstudio.com/downloads/  
   Important: While installing Visual Studio Community Edition, make sure to select the following optional components:

    - The workload "Desktop Development with C++"
    - Options "C++/CLI support" and "Standard Library modules" (In the list at the right of the installation wizard)

2. Optional. If you're interested in building programs for Windows 95/98, install Microsoft Visual Studio 2005.  
   It is still available for MSDN subscribers in 2017.  
   A free version with some limitations is also available in archive.org: [MS Visual Studio 2005 Express](https://archive.org/details/mvs-2005-ee)
   It can be installed in parallel with more recent versions of Visual Studio.

3. Optional. If you're interested in building programs for the PC BIOS, MS-DOS, and Windows 3.x, install Microsoft Visual C++ 1.52c.  
   It is still available for MSDN subscribers in 2017, as part of the Visual Studio 2005 DVD image, but not installed by default.
   It's also available in archive.org: [MS VC++ 1.52x](https://archive.org/details/Microsoft_Visual_C_-_Version_1.52c_Microsoft_1995)
   Gotcha: The VC++ 1.52 compiler is a WIN32 program that runs in all 32 and 64-bits versions of Windows. But
   unfortunately the VC++ 1.52 setup.exe program is a WIN16 program, which only runs on old 32-bits versions of Windows.
   This requires doing extra steps for successfully installing the compiler in modern 64-bits versions of Windows:

   - Install a 32-bits VM running Windows XP, that can run WIN16 programs out-of-the-box. (This has to be an x86 VM, not an amd64 VM with XP/64)  
     Note: Newer 32-bits x86 versions of Windows can still run WIN16 programs, but this may require some tinkering.
     If needed, look for instructions on the Internet.
   - Give that VM access to the host's file system, and to the VC++ 1.52 master DVD image as a virtual CD.
   - Run the VC++ 1.52 setup in the VM, and install it in the VM's C:\MSVC. (Necessary so that the setup builds vcvars.bat correctly.)
   - Once this is done, copy the VM's C:\MSVC to the host's C:\MSVC.  
     The copy of C:\MSVC\BIN\MSVCVARS.BAT on the host will thus refer to the host's C drive, as if the setup had been done on the host.

After installing or upgrading any of the tools above, run configure.bat in your project base directory.  
This will update the config.HOSTNAME.bat file in each library directory.  
Subsequent builds with make.bat will automatically use the new tools and SDKs, and build the programs that depend on them.


The Microsoft Visual C++ nmake system
-------------------------------------

The Microsoft Visual C++ compiler comes with a make tool called nmake.exe.  
This nmake.exe tool is very similar to Unix make, for dependency and inference rules definitions.  
But it is completely incompatible with Unix make for advanced features, such as preprocessor directives, inline scripts, etc.

The NMaker system in the [include](include/) subdirectory was designed with the following goals:

- Have a build look and feel similar on Windows and Unix.
- Be compatible with a wide range of Visual C++ versions. (As far back as Visual C++ 7.1 / Visual Studio 2003)
- Allow building multiple versions of a target in a simple single command, and store them in distinct subdirectories.
- Support multiple target operating systems and processors.
- Support a "release" and a "debug" version for each target OS.
- Support building the same sources remotely from multiple systems and VMs having different tools, storing results
   in different places.

File name       | Description
--------------- | -----------------------------------------------------
configure.bat   | Locates available development tools, and creates a configuration script
make.bat        | Front end to nmake.exe
BatProxy.bat    | Locates and invokes eponymous scripts in the NMaker/include directory. Ex: Rename a copy as make.bat.
--------------- | -----------------------------------------------------
All.mak         | Rules for building several versions of a program at once
arm.mak         | Rules for building the Windows 32-bits ARM version of a program
arm64.mak       | Rules for building the Windows 64-bits ARM version of a program
bios.mak        | Rules for building the PC BIOS 16-bits version of a program
dos.mak         | Rules for building the MS-DOS 16-bits version of a program
lodos.mak       | Rules for building MS-DOS device drivers and TSRs
win16.mak       | Rules for building the Windows 16-bits version of a program for Windows 3.x and 95/98/ME
win32.mak       | Rules for building the Windows 32-bits x86 version of a program
win64.mak       | Rules for building the Windows 64-bits amd64 version of a program
win95.mak       | Rules for building a win32 version of a program compatible with Windows 95

- All scripts have a -? option to display a help screen.
- Most make files have a "help" pseudo-target to display a help screen. Ex:

        make.bat -f win32.mak help

The `configure.bat` script must to be run once in every C/C++ source directory.  
This is done automatically by `make.bat` the first time it runs.  
Then you only need to run `configure.bat` again if you install new development tools. (For example a Visual C++ update.)

On a properly configured source tree, it is sufficient to run `configure.bat` in the project root directory.
configure.bat will automatically recurse in all subdirectories with C/C++ sources that 


## Output directories

By default, all output goes in target-OS-specific subdirectories:

OS                | Base output directory
----------------- | --------------------------------
PC BIOS           | bin\BIOS\
MS-DOS drivers    | bin\LODOS\
MS-DOS            | bin\DOS\
Windows 3.x to ME | bin\WIN16\
Windows 95 WIN32S | bin\WIN95\
Windows XP+ x86   | bin\WIN32\
Windows x86_64    | bin\WIN64\
Windows arm       | bin\ARM\
Windows arm64     | bin\ARM64\
Linux i686        | bin\Linux.i686\
Linux x86_64      | bin\Linux.x86_64\
Mac OS            | bin\Darwin.x86_64\
FreeBSD           | bin\FreeBSD.amd64\

Within each target directory, the output files are located in the base and various subdirectories:

Directory           | Contents
------------------- | -----------------------------------------------------------------
\\*                 | The "release" executables for the target OS
\obj\\*             | The object files produced by the compilers and assemblers
\list\\*            | The listings and map files produced by the compilers and linkers
\Scripts\\*         | OS-specific scripts defined inline in the OS-specific make file
\debug\\*           | The "debug" executables for the target OS
\debug\obj\\*       | The object files produced by the compilers and assemblers
\debug\list\\*      | The listings and map files produced by the compilers and linkers
\debug\Scripts\\*   | OS-specific scripts defined inline in the OS-specific make file

For virtual machines that build sources in their host's file system, or for network system that build them remotely,
it's possible to override the default `bin` output base.  
This is useful for testing builds with older compilers for example, and the goal is to avoid overwriting the "official"
builds on the main host system.  
For that, in each VM or remote system, create a `%windir%\configure.NMaker.bat` file,
that defines variables `OUTDIR` and/or `MY_SDKS`. Ex:

    set "OUTDIR=XPVM"        &:# Optional: Base output path, overriding the default OUTDIR=bin directory.
    set "MY_SDKS=H:\JFL\SDK" &:# Optional: Path to the shared SDKs, as seen from this system.

### Localized sources

Sources must be encoded in UTF-8 with BOM by default.  
This make system automatically converts them to other encodings as needed.  
Example:

OS              | Output directory          | Notes
--------------- | ------------------------- | -------------------------------------------
DOS             | bin\SRC\cp437\            | The code page for MS-DOS in the USA
Windows         | bin\SRC\utf8\             | UTF-8 without BOM

Note: We now have a problem with the encoding of include files.
Please avoid using non-ASCII characters in C/C++ include files for now.

## Using this make system for a new project

Everything is designed to minimize the amount of things to do, while having the ability to build things easily for
multiple operating systems in a single make command.

For that, developers should create in their source directory one or more of these three special files:

| File name       | Description
| --------------- | -----------------------------------------------------
| Files.mak       | OS-independent declarations of variables (all optional), with lists of files and directories:  
|                 | DIRS = list of subdirectories, with their own subproject to build first.  
|                 | PROGRAMS = list of programs to build. (Without the .exe extension for Windows)  
|                 | SOURCES = Sources to compile and link together, when building a single program.  
|                 | OBJECTS = List of object files link together. Rarely needed, as it's usually computed automatically from SOURCES.  
|                 | LIBRARIES = Libraries to link with the program. Rarely needed, as this list is usually built automatically.  
|                 | Files.mak is required in most projects, and is sufficient in most simple cases.
| makefile        | GNU make file, with gmake-specific rules for building the project in Unix.
| NMakefile       | MS nmake file, with nmake-specific rules for building the project in Windows, for DOS & Windows targets.

Note that `configure.bat` will also use the DIRS definitions in `Files.mak`, to automatically run recursively in the
subproject directories. So if all `Files.mak` files are setup properly, `configure.bat` needs only to be run once
in the project top directory.

### Importing NMaker files

Import NMaker files in your project this way:

 - Run `git submodule add "https://github.com/JFLarvoire/NMaker"`  
   This creates a .gitmodules file in your root, and adds the following block into it:
   
       [submodule "NMaker"]
       path = NMaker
       url = https://github.com/JFLarvoire/NMaker
   
   And this downloads the NMaker project files into the NMaker subdirectory.
   
 - Commit the .gitmodules file and the NMaker directory into the git repository.

Later on, if desired, it's possible to get the NMaker updates by running `git submodule update --remote`.

### make.bat usage

Run `make help` for details. Sample output:

    Usage: make.bat [options] [nmake_options] [macro_definitions] [targets] ...
    
    Macro definitions:     (They must be quoted, else the = sign will be lost)
      "DEBUG=0"            Generate the release version. (Default)
      "DEBUG=1"            Generate the debug version. <==> Target in a Debug\ dir.
      "DEBUG=all"          Generate both the debug and release versions.
      "DEBUG=0 1"          Generate both the debug and release versions.
      "MEM=L"              Build the DOS version w. large memory model. Dflt: T or S
      "OS=this"            Build for the current OS. (Default)
      "OS=all"             Build all buildable OS versions
      "OS=tests"           Build OS versions for testing, both debug and release
      "OS=BIOS DOS WIN95 WIN32 WIN64"   List of target OSs to build for
      "WINVER=4.0"         Target OS version. 4.0=Win95/NT4, 5.1=WinXP, 6.1=Win7
    
    Targets:
      all                    Build all available programs and libraries
      clean                  Erase all output files built by this make system
      allclean               Erase all output files for all OSs, including Unix'
      distclean              Erase all output files and all configuration files
      {prog}.com             Build BIOS and DOS versions of {prog}.com
      {prog}.exe             Build DOS and all Windows versions of {prog}.exe
      Debug\{prog}.exe       Build BIOS and DOS versions of the same
      {prog}.exe             Build DOS, WIN32, and WIN64 versions of {prog}.exe
      Debug\{prog}.exe       Build DOS, WIN32, and WIN64 debug versions of the same
      BIOS\{prog}.com        Build the BIOS release version of {prog}.com
      BIOS\Debug\{prog}.com  Build the BIOS debug version of {prog}.com
      LODOS\{prog}.com       Build the low DOS release version of {prog}.com
      LODOS\Debug\{prog}.com Build the low DOS debug version of {prog}.com
      LODOS\{prog}.exe       Build the low DOS release version of {prog}.exe
      LODOS\Debug\{prog}.exe Build the low DOS debug version of {prog}.exe
      LODOS\{prog}.sys       Build the low DOS release version of {prog}.sys
      LODOS\Debug\{prog}.sys Build the low DOS debug version of {prog}.sys
      DOS\{prog}.com         Build the DOS release version of {prog}.com
      DOS\Debug\{prog}.com   Build the DOS debug version of {prog}.com
      DOS\{prog}.exe         Build the DOS release version of {prog}.exe
      DOS\Debug\{prog}.exe   Build the DOS debug version of {prog}.exe
      WIN95\{prog}.exe       Build the WIN95 release version of {prog}.exe
      WIN95\Debug\{prog}.exe Build the WIN95 debug version of {prog}.exe
      WIN32\{prog}.exe       Build the WIN32 release version of {prog}.exe
      WIN32\Debug\{prog}.exe Build the WIN32 debug version of {prog}.exe
      WIN64\{prog}.exe       Build the WIN64 release version of {prog}.exe
      WIN64\Debug\{prog}.exe Build the WIN64 debug version of {prog}.exe


### Examples

1) Trivial case with one C source and one corresponding executable for Windows

   - Copy the NMaker\include directory inside your project directory:

         NMaker\include\
         myprogram.c

     No need to create any specific make file.

   - Run `NMaker\include\configure.bat`  (Note that this creates a local make.bat script, invoking NMaker\include\make.bat)  
     Run `make.bat myprogram.exe`

2) Several sources, that need to be compiled and linked together into a single executable

   - Same as case 1, plus create a Files.mak file containing:

         PROGRAMS = myprogram
         SOURCES = source1.c source2.c source3.c

   - The project directory contains:

         NMaker\include\
         Files.mak
         source1.c
         source2.c
         source3.c

   - Run `NMaker\include\configure.bat`  
     Run `make.bat` to rebuild myprogram.exe.

3) Several sources, each generating a corresponding executable, with one requiring special make instructions

   - Same as case 1, plus create a `Files.mak` file containing:

         PROGRAMS = program1 program2 program3

   - The project directory contains:

         NMaker\include\
         Files.mak
         program1.c
         program2.c
         program3.c
         program3.mak

   - Run `NMaker\include\configure.bat`  
     Run `make.bat` to rebuild all three programs.  
     The make files will automatically search for *.c, *.cpp, *.asm, etc, and build program1.exe, program2.exe, program3.exe.  
     If one (for example program3) requires special make instructions, create a program3.mak file, and put them in there.  
     Run `make.bat program2.exe` to rebuild just the second one from program2.c.  
     Run `make.bat program3.exe` to rebuild just the third one from program3.c and instructions from program3.mak.  

4) Build for Windows and Linux

   - In addition to all the above, write a `makefile` for Linux, that includes Files.mak, and uses $(PROGRAMS) as the default target:

         include Files.mak
        
         all: $(PROGRAMS)

   - If additional pseudo targets and goals are desired for Windows, add an `NMakefile` file, that first includes All.mak:

         !INCLUDE <All.mak>
        
         my_goal:
             echo Doing it now

     Note: Do not specify the path of the All.mak file: nmake will find it automatically in the include directory.

5) A project with several sub-projects in subdirectories

   - Put the include directory in the top directory.
   - Add in that top directory a Files.mak file defining the DIRS variable:

         DIRS = subproject1 subproject2 subproject3

   - Put a `Files.mak`, and others *mak* as needed in each subproject's subdirectory.  
     (No need to duplicate the include directory in each subdirectory!)
   - Run `NMaker\include\configure.bat` once in the top directory. 
     Run `make.bat` in the top directory to rebuild all subprojects recursively.  

6) A project with several programs, each having several sources, and all these sources in the same directory.

   - In `Files.mak`, define the PROGRAMS variable as above.

         PROGRAMS = program1 program2 program3

   - In `Files.mak`, for each of the above programs, define the $(PROGRAM)_SOURCES as in this example:

         program1_SOURCES = program1a.c program1b.c program1c.c
         program2_SOURCES = program2a.c program2b.c
         program3_SOURCES = program3a.c program3b.c program3c.c

   - In `makefile` for Linux, define the rules for each program:
     (Note: The automatic handling of $(PROGRAM)_SOURCES is not yet implemented.)

         SP := .
         BP := bin/$(shell uname -s).$(shell uname -p)
        
         [...]
        
         $(BP)/program1: $(SP)/program1a.c $(SP)/program1b.c $(SP)/program1c.c

         $(BP)/program2: $(SP)/program2a.c $(SP)/program2b.c

         $(BP)/program3: $(SP)/program3a.c $(SP)/program3b.c $(SP)/program3c.c


## Managing program properties

In Windows Explorer, right-clicking on a program and selecting "Properties" displays a dialog box with multiple tabs.
The "Details" tab displays a list of properties of the program.exe: File description, Type, File version, Product name,
Product Version, Copyright, Legal trademarks, Original filename, etc.

The NMaker configuration and make system helps generating this information without having to create a dedicated
program.rc resource file. For that, your C source must contain the following definitions:

C constants definitions                                    | Description
---------------------------------------------------------- | ----------------------------------------------------------
`#define PROGRAM_DESCRIPTION "Demo of program properties"` | A short one-line string describing the program
`#define PROGRAM_NAME        "demoprop"`                   | The base name of the program
`#define PROGRAM_VERSION     "1.0.0"`                      | Program version MAJOR.MINOR.PATH[.BUILD] (Optional)
`#define PROGRAM_DATE        "2019-06-16"`                 | Program date in ISO format. (Used to generate PROGRAM_VERSION if it's missing)

make.bat and win32.mak will extract this information from demoprop.c, and generate a demoprop.rc with it.  
If you *do* have your own demoprop.rc, then #include "versions.rc" to do the same.

Note that, for consistency, it's strongly recommended to reuse these same strings in the program's built-in help:
When the user invokes it with options -? for help, or -V for the program version, then display these very strings.

Configure.bat queries Windows for your full name and email address, to generate the copyright strings.  
As these values may not always be the right ones, you can override them by adding in the sources directory
a configure.YOURNAME.bat script defining the values you want:

Batch variables definitions                | Description
------------------------------------------ | -----------------------------
`set "MY_FULLNAME=Jean-François Larvoire"` | The build author's full name
`set "MY_EMAIL=jf.larvoire@free.fr"`       | The build author's email

Important: If, as in this example, the MY_FULLNAME string contains non-ASCII characters, then configure.YOURNAME.bat
must temporarily change the console code page to match its own encoding. Else the string would not be loaded correctly
by configure.bat.    
Configure.bat defines variable CON.CP with the current code page. Configure.USER.bat can use it to set, then restore the
initial code page as needed. For example, assuming configure.USER.bat is encoded using code page 1252, it should contain:

    if not %CON.CP%==1252 chcp 1252 >nul     &:# Make sure the next lines are executed using code page 1252
    set "MY_FULLNAME=Jean-François Larvoire" &:# The build author's full name
    set "MY_EMAIL=jf.larvoire@free.fr"       &:# The build author's email
    if not %CON.CP%==1252 chcp %CON.CP% >nul &:# Restore the initial code page


C include files
---------------

File name       | Descrition
--------------- | -----------------------------------------------------
debugm.h        | Debug macros, for adding debugging features to the debug version of a C program.
versions.h      | Define target program, OS, and libraries version strings

### Debug macros

`debugm.h` contains a set of OS-independent macros for managing distinct debug and release versions of a C or C++ program.
The debug version is generated if the _DEBUG constant is defined. Else the release version is generated.
These macros produce no extra code in the release version and thus have no overhead in that release version.
Even in the debug version, the debug output is disabled by default. It must be enabled by using DEBUG_ON().

Usage:

- One source file must instanciate global variables used by the debug system, by using the DEBUG_GLOBALS macro.
- The source file parsing the arguments must look for one argument (Ex: --debug) and enable the debug mode. Ex:

      DEBUG_CODE(
        if (!strcmp(arg, "--debug")) DEBUG_ON();
      )

- Insert DEBUG_ENTER() calls at the beginning of all routines that should be traced, and replace all their
  return instructions with RETURN_XXX() macros.
- Pepper the sources with DEBUG_PRINTF() calls displaying critical intermediate values.

The debug output will show the function call stack by indenting traced subroutines proportionally to their call depth.
To make the debug output more readable, it is recommended to format it so that it looks like valid C code.

The macros actually support multiple debug levels.  
Level 1 is the normal debug mode.  
Level 2 is the eXtra debug mode. Use it for displaying more detailed debug information, that is not needed in normal
debugging sessions.  
More levels could be used if desired.

Most common macros:

Macro                           | Description
------------------------------- | ----------------------------------------------------
DEBUG_CODE(...)                 | Code to be present only in the debug version.
DEBUG_CODE_IF_ON(...)           | Code to be present only in the debug version, and that will run only if debug is enabled.
DEBUG_PRINTF((format, ...))     | Print something if debug is enabled. (Notice the double parenthesis!)

For a complete list of available macros, see the [debugm.h](include/debugm.h) header.
