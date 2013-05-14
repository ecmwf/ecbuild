# (C) Copyright 1996-2012 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

############################################################################################
# os capability checks

if( NOT EC_SKIP_OS_FUNCTIONS_TEST )
    
    ### symbol checks ##################

    check_symbol_exists( fseek        "stdio.h"                         EC_HAVE_FSEEK  )
    check_symbol_exists( fseeko       "stdio.h"                         EC_HAVE_FSEEKO )
    check_symbol_exists( ftello       "stdio.h"                         EC_HAVE_FTELLO )
    check_symbol_exists( lseek        "sys/types.h;unistd.h"            EC_HAVE_LSEEK  )
    check_symbol_exists( ftruncate    "sys/types.h;unistd.h"            EC_HAVE_FTRUNCATE  )
    check_symbol_exists( open         "sys/types.h;sys/stat.h;fcntl.h"  EC_HAVE_OPEN   )
    check_symbol_exists( fopen        "stdio.h"                         EC_HAVE_FOPEN  )
    check_symbol_exists( flock        "sys/file.h"                      EC_HAVE_FLOCK  )
    check_symbol_exists( mmap         "sys/mman.h"                      EC_HAVE_MMAP   )
    
    check_symbol_exists( posix_memalign "stdlib.h"                      EC_HAVE_POSIX_MEMALIGN )
    
    check_symbol_exists( F_GETLK      "fcntl.h"                         EC_HAVE_F_GETLK  )
    check_symbol_exists( F_SETLK      "fcntl.h"                         EC_HAVE_F_SETLK  )
    check_symbol_exists( F_SETLKW     "fcntl.h"                         EC_HAVE_F_SETLKW  )
     
    check_symbol_exists( F_GETLK64     "fcntl.h"                        EC_HAVE_F_GETLK64  )
    check_symbol_exists( F_SETLK64     "fcntl.h"                        EC_HAVE_F_SETLK64  )
    check_symbol_exists( F_SETLKW64    "fcntl.h"                        EC_HAVE_F_SETLKW64  )
    
    check_symbol_exists( MAP_ANONYMOUS "sys/mman.h"                     EC_HAVE_MAP_ANONYMOUS )
    check_symbol_exists( MAP_ANON      "sys/mman.h"                     EC_HAVE_MAP_ANON )

    ### include files checks ##################

    check_include_files( assert.h       EC_HAVE_ASSERT_H      )
    check_include_files( stdlib.h       EC_HAVE_STDLIB_H      )
    check_include_files( unistd.h       EC_HAVE_UNISTD_H      )
    check_include_files( string.h       EC_HAVE_STRING_H      )
    check_include_files( strings.h      EC_HAVE_STRINGS_H     )
    check_include_files( sys/stat.h     EC_HAVE_SYS_STAT_H    )
    check_include_files( sys/time.h     EC_HAVE_SYS_TIME_H    )
    check_include_files( sys/types.h    EC_HAVE_SYS_TYPES_H   )
    check_include_files( malloc.h       EC_HAVE_MALLOC_H      )
    check_include_files( sys/malloc.h   EC_HAVE_SYS_MALLOC_H  )
    
    check_include_files("sys/param.h;sys/mount.h" EC_HAVE_SYS_MOUNT_H )
    check_include_files("sys/vfs.h"               EC_HAVE_SYS_VFS_H )

    # test for stat vs stat64

    ecbuild_check_c_source_return(
        "#include <sys/types.h>\n#include <sys/stat.h>\n#include <unistd.h>\n#include <stdio.h>\nint main(){struct stat s;printf(\"%ld\",sizeof(s.st_size));return 0;}" 
        VAR     EC_STAT_OFF_T
        OUTPUT  EC_STAT_SIZEOF_OFF_T )

    ### capability checks ##################

    # test off_t
    check_c_source_compiles( "#include <sys/types.h>\nint main(){ off_t l=0; return 0;}\n" EC_HAVE_OFFT )
    # test off64_t
    check_c_source_compiles( "#define _LARGEFILE64_SOURCE\n#include <stdio.h>\n#include <sys/types.h>\nint main(){ off64_t l=0; return 0;}\n" EC_HAVE_OFF64T  )
    # test struct stat
    check_c_source_compiles( "#include <sys/stat.h>\nint main(){ struct stat s; return 0; }"   EC_HAVE_STRUCT_STAT )
    # test struct stat64
    check_c_source_compiles( "#define _LARGEFILE64_SOURCE\n#include <sys/stat.h>\nint main(){ struct stat64 s; return 0; }" EC_HAVE_STRUCT_STAT64 )
    # test stat
    check_c_source_compiles( "#include <sys/stat.h>\nint main(){ struct stat s;	stat(\"\",&s); return 0; }"    EC_HAVE_STAT )
    # test stat64
    check_c_source_compiles( "#define _LARGEFILE64_SOURCE\n#include <sys/stat.h>\nint main(){ struct stat64 s; stat64(\"\",&s); return 0; }"  EC_HAVE_STAT64 )
    # test fstat
    check_c_source_compiles( "#include <sys/stat.h>\nint main(){ struct stat s; fstat(1,&s); return 0; }" EC_HAVE_FSTAT )
    # test fstat64
    check_c_source_compiles( "#define _LARGEFILE64_SOURCE\n#include <sys/stat.h>\nint main(){ struct stat64 s; fstat64(1,&s); return 0; }" EC_HAVE_FSTAT64 )
    # test fseeko64
    check_c_source_compiles( "#define _LARGEFILE64_SOURCE\n#include <stdio.h>\n#include <sys/types.h>\nint main(){FILE* file;off64_t l=0;fseeko64(file,l,SEEK_CUR);return 0;}\n" EC_HAVE_FSEEKO64 )
   
    # test for ftello64
    check_c_source_compiles( "#define _LARGEFILE64_SOURCE\n#include <stdio.h>\n#include <sys/types.h>\nint main(){FILE* file;off64_t l = ftello64(file);return 0;}\n"  EC_HAVE_FTELLO64 )
    
    # test for lseek64
    check_c_source_compiles( "#define _LARGEFILE64_SOURCE\n#include <sys/types.h>\n#include <unistd.h>\nint main(){off64_t h = lseek64(0,0,SEEK_SET);return 0;}\n"  EC_HAVE_LSEEK64 )
    # test for open64
    check_c_source_compiles( "#define _LARGEFILE64_SOURCE\n#include <fcntl.h>\nint main(){int fd = open64(\"name\",O_RDWR|O_CREAT,0777);return 0;}\n" EC_HAVE_OPEN64 )
    # test for fopen64
    check_c_source_compiles( "#define _LARGEFILE64_SOURCE\n#include <stdio.h>\nint main(){FILE* file = fopen64(\"name\",\"w\");return 0;}\n"  EC_HAVE_FOPEN64 )
    # test for ftruncate64
    check_c_source_compiles( "#define _LARGEFILE64_SOURCE\n#include <unistd.h>\n#include <sys/types.h>\nint main(){ftruncate64(0,(off64_t)0);return 0;}\n" EC_HAVE_FTRUNCATE64 )
    # test for flock64
    check_c_source_compiles( "#define _LARGEFILE64_SOURCE\n#include <fcntl.h>\nint main(){struct flock64 l;return 0;}\n" EC_HAVE_FLOCK64 )
    # test for mmap64
    check_c_source_compiles( "#define _LARGEFILE64_SOURCE\n#include <sys/mman.h>\nint main(){void* addr = mmap64(0,10,PROT_READ|PROT_WRITE,MAP_PRIVATE,10,0); return 0;}\n" EC_HAVE_MMAP64 )
    # test for struct statvfs
    check_c_source_compiles( "#include <sys/statvfs.h>\nint main(){ struct statvfs v; }" EC_HAVE_STRUCT_STATVFS )
    # test for struct statvfs64
    check_c_source_compiles( "#define _LARGEFILE64_SOURCE\n#include <sys/statvfs.h>\nint main(){ struct statvfs64 v; }" EC_HAVE_STRUCT_STATVFS64 )
        
    # test for fsync
    check_c_source_compiles( "#include <unistd.h>\nint main(){int fd = 1; int fs = fsync(fd); }\n" EC_HAVE_FSYNC )
    # test for fdatasync
    check_c_source_compiles( "#include <unistd.h>\nint main(){int fd = 1; int fs = fdatasync(fd); }\n" EC_HAVE_FDATASYNC )
    # test for dirfd
    check_c_source_compiles( "#include <sys/types.h>\n#include <dirent.h>\nint main(){ DIR *dirp; int i = dirfd(dirp); }\n" EC_HAVE_DIRFD )
    # test for sys/proc.h
    check_c_source_compiles( "#include <sys/proc.h>\nint main(){ return 0; }\n" EC_HAVE_SYSPROC )
    # test for procfs
    check_c_source_compiles( "#include <sys/procfs.h>\nint main(){ return 0; }\n" EC_HAVE_SYSPROCFS )
    # test for backtrace
    check_c_source_compiles( "#include <unistd.h>\n#include <execinfo.h>\n int main(){ void ** buffer; int i = backtrace(buffer, 256); }\n" EC_HAVE_EXECINFO_BACKTRACE )
    
    ### asynchronous IO support ##################
    
    cmake_push_check_state()
    
       if( CMAKE_SYSTEM_NAME MATCHES "Linux" )
         set(CMAKE_REQUIRED_LIBRARIES ${RT_LIB})
       endif()
    
       check_c_source_compiles( "#include <aio.h>\nint main(){ struct aiocb* aiocbp; int n = aio_write(aiocbp); n = aio_read(aiocbp);  n = aio_fsync(O_SYNC,aiocbp); }\n"  EC_HAVE_AIO )
       check_c_source_compiles( "#include <aio.h>\nint main(){ struct aiocb64* aiocbp; int n = aio_write64(aiocbp); n = aio_read64(aiocbp); n = aio_fsync64(O_SYNC,aiocbp); }\n" EC_HAVE_AIO64 )
    
    cmake_pop_check_state()
        
    #### reentrant funtions support  #############

    # test for gmtime_r
    check_c_source_compiles( "#include <time.h>\nint main(){ time_t now; time(&now); struct tm t; gmtime_r(&now,&t); }\n" EC_HAVE_GMTIME_R )
    # test for getpwuid_r
    check_c_source_compiles( "#include <unistd.h>\n#include <sys/types.h>\n#include <pwd.h>\nint main(){ char buf[4096]; struct passwd pwbuf; struct passwd *pwbufp = 0; getpwuid_r(getuid(), &pwbuf, buf, sizeof(buf), &pwbufp); }\n" EC_HAVE_GETPWUID_R )
    # test for getpwnam_r
    check_c_source_compiles( "#include <sys/types.h>\n#include <pwd.h>\nint main(){ struct passwd p; char line[1024]; int n = getpwnam_r(\"user\",&p,line,sizeof(line),0); }\n" EC_HAVE_GETPWNAM_R )    
    # test for readdir_r
    check_c_source_compiles( "#include <dirent.h>\nint main(){ DIR *dirp; struct dirent *entry; struct dirent **result; int i = readdir_r(dirp, entry, result); }\n" EC_HAVE_READDIR_R )
    # test for gethostbyname_r
    check_c_source_compiles( "#include <netdb.h>\nint main(){ const char *name; struct hostent *ret; char *buf; struct hostent **result; size_t buflen; int *h_errnop; int i = gethostbyname_r(name,ret,buf,buflen,result,h_errnop); }\n" EC_HAVE_GETHOSTBYNAME_R )

endif()

############################################################################################
# c compiler tests

check_c_source_compiles( 
      " typedef int foo_t;
        static inline foo_t static_foo(){return 0;}
        foo_t foo(){return 0;}
        int main(int argc, char *argv[]){return 0;}
      " EC_HAVE_C_INLINE )

############################################################################################
# c++ compiler tests

if( CMAKE_CXX_COMPILER_LOADED )

    # check for __FUNCTION__
    check_cxx_source_compiles( "#include <iostream>\nint main(int argc, char* argv[]) { std::cout << __FUNCTION__ << std::endl; }" EC_HAVE_FUNCTION_DEF )
    
    # check for c++ abi, usually present in GNU compilers
    check_cxx_source_compiles( "#include <cxxabi.h>\n int main() { char * type; int status; char * r = abi::__cxa_demangle(type, 0, 0, &status); }" EC_HAVE_CXXABI_H )
    
    # check for bool
    check_cxx_source_compiles( "int main() { bool aflag = true; }" EC_HAVE_CXX_BOOL )
    # fail if we dont have bool
    if( NOT EC_HAVE_CXX_BOOL )
        message( FATAL_ERROR "c++ compiler does not support bool" )
    endif()
    
    # check for sstream
    check_cxx_source_compiles( "#include <sstream>\nint main() { std::stringstream s; }" EC_HAVE_CXX_SSTREAM )
    # fail if we dont have sstream
    if( NOT EC_HAVE_CXX_SSTREAM )
        message( FATAL_ERROR "c++ compiler does not support stringstream" )
    endif()
    
endif()

###############################################################################
# checks

if( NOT EC_HAVE_GETPWUID_R )
    message( FATAL_ERROR "OS does not support getpwuid_r" )
endif()   


