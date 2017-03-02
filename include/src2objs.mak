###############################################################################
#									      #
#   File name	    src2objs.mak					      #
#									      #
#   Description	    Convert the SOURCES list to an OBJECTS list		      #
#									      #
#   Notes	    For use with SysToolsLib's dos.mak, win32.mak, etc...     #
#									      #
#   History								      #
#    2017-03-01 JFL Created this make file.       			      #
#		    							      #
#         � Copyright 2017 Hewlett Packard Enterprise Development LP          #
# Licensed under the Apache 2.0 license - www.apache.org/licenses/LICENSE-2.0 #
###############################################################################

# Create the output directory if needed
!IF !EXIST($(O))
!  IF [$(MSG) Creating directory $(O) && md $(O)] != 0
!    ERROR Failed to create the $(O) directory
!  ENDIF
!ENDIF

# Invoke src2objs.bat for doing the conversion
SRC2OBJ_CMD="$(STINCLUDE)\src2objs.bat" -o $(O) $(SOURCES) >$(O)\$(PROGRAM).mak
!MESSAGE $(SRC2OBJ_CMD)
!IF [$(SRC2OBJ_CMD)] == 0
!  MESSAGE Getting generated object list from $(O)\$(PROGRAM).mak.
!  INCLUDE $(O)\$(PROGRAM).mak
!ELSE
!  ERROR Failed to generate the OBJECTS file list
!ENDIF
