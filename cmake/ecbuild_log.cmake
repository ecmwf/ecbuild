# (C) Copyright 1996-2015 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

###############################################################################
# Macros for logging based on the log level set
#
# CMake variables controlling the behaviour:
#
# ECBUILD_LOG_LEVEL (string) - controls the log level
#                              one of DEBUG, INFO, WARN, ERROR, CRITICAL
#                              OFF to disable logging altogether
#
# ECBUILD_NO_COLOUR (bool)   - if enabled, does not colour log output
#
# Macros:
#
# ecbuild_debug    - logs a STATUS message if log level <= DEBUG
# ecbuild_info     - logs a STATUS message if log level <= INFO
# ecbuild_warn     - logs a WARNING message if log level <= WARN
# ecbuild_error    - logs a SEND_ERROR message if log level <= ERROR
# ecbuild_critical - logs a FATAL_ERROR message if log level <= CRITICAL
#
###############################################################################

# Define colour escape sequences (https://stackoverflow.com/a/19578320/396967)
if(NOT (WIN32 OR ECBUILD_NO_COLOUR))
  string(ASCII 27 Esc)
  set(ColourReset "${Esc}[m")
  set(ColourBold  "${Esc}[1m")
  set(Red         "${Esc}[31m")
  set(Green       "${Esc}[32m")
  set(Yellow      "${Esc}[33m")
  set(Blue        "${Esc}[34m")
  set(Magenta     "${Esc}[35m")
  set(Cyan        "${Esc}[36m")
  set(White       "${Esc}[37m")
  set(BoldRed     "${Esc}[1;31m")
  set(BoldGreen   "${Esc}[1;32m")
  set(BoldYellow  "${Esc}[1;33m")
  set(BoldBlue    "${Esc}[1;34m")
  set(BoldMagenta "${Esc}[1;35m")
  set(BoldCyan    "${Esc}[1;36m")
  set(BoldWhite   "${Esc}[1;37m")
endif()

set(ECBUILD_DEBUG    10)
set(ECBUILD_INFO     20)
set(ECBUILD_WARN     30)
set(ECBUILD_ERROR    40)
set(ECBUILD_CRITICAL 50)

if( NOT DEFINED ECBUILD_LOG_LEVEL )
  set(ECBUILD_LOG_LEVEL ${ECBUILD_WARN})
elseif( NOT ECBUILD_LOG_LEVEL )
  set(ECBUILD_LOG_LEVEL 60)
elseif( ECBUILD_LOG_LEVEL STREQUAL "DEBUG" )
  set(ECBUILD_LOG_LEVEL ${ECBUILD_DEBUG})
elseif( ECBUILD_LOG_LEVEL STREQUAL "INFO" )
  set(ECBUILD_LOG_LEVEL ${ECBUILD_INFO})
elseif( ECBUILD_LOG_LEVEL STREQUAL "WARN" )
  set(ECBUILD_LOG_LEVEL ${ECBUILD_WARN})
elseif( ECBUILD_LOG_LEVEL STREQUAL "ERROR" )
  set(ECBUILD_LOG_LEVEL ${ECBUILD_ERROR})
elseif( ECBUILD_LOG_LEVEL STREQUAL "CRITICAL" )
  set(ECBUILD_LOG_LEVEL ${ECBUILD_CRITICAL})
else()
  message(WARNING "Unknown log level ${ECBUILD_LOG_LEVEL} (valid are DEBUG, INFO, WARN, ERROR, CRITICAL) - using WARN")
  set(ECBUILD_LOG_LEVEL ${ECBUILD_WARN})
endif()

macro( ecbuild_debug MSG )
  if( ECBUILD_LOG_LEVEL LESS 11)
    message(STATUS "${Blue}DEBUG - ${MSG}${ColourReset}")
  endif()
endmacro( ecbuild_debug )

macro( ecbuild_info MSG )
  if( ECBUILD_LOG_LEVEL LESS 21)
    message(STATUS "${Green}INFO - ${MSG}${ColourReset}")
  endif()
endmacro( ecbuild_info )

macro( ecbuild_warn MSG )
  if( ECBUILD_LOG_LEVEL LESS 31)
    message(WARNING "${Yellow}WARN - ${MSG}${ColourReset}")
  endif()
endmacro( ecbuild_warn )

macro( ecbuild_error MSG )
  if( ECBUILD_LOG_LEVEL LESS 41)
    message(SEND_ERROR "${BoldRed}ERROR - ${MSG}${ColourReset}")
  endif()
endmacro( ecbuild_error )

macro( ecbuild_critical MSG )
  if( ECBUILD_LOG_LEVEL LESS 51)
    message(FATAL_ERROR "${BoldMagenta}CRITICAL - ${MSG}${ColourReset}")
  endif()
endmacro( ecbuild_critical )
