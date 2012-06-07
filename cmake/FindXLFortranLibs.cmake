# © Copyright 1996-2012 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

###############################################################################

list( APPEND xl_libs xlf90 xlopt xlf xlsmp pthreads m essl )
foreach( lib ${xl_libs} )
    if( DEFINED XLF_PATH )
      find_library( ${lib}_lib  ${lib} PATH ${XLF_PATH}/lib NO_DEFAULT_PATH )
    endif()
    find_library( ${lib}_lib  ${lib} )
    if( ${lib}_lib )
        list( APPEND XLFORTRAN_LIBRARIES ${${lib}_lib} )
    endif()
endforeach()

