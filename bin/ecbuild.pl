#!/usr/bin/env perl

# (C) Copyright 1996-2013 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

use warnings;
use strict;

#==============================================================================
# Modules
#==============================================================================

use strict;
use Cwd;
use File::Path;
use File::Basename;
use Getopt::Long;

#==============================================================================
# main variables
#==============================================================================

# my $user = "mab";

my $ecmwf = (`id emos >/dev/null 2>/dev/null` eq "") ? 0 : 1;  # find if we inside ECMWF

my $projdir  = getcwd();
my $project = basename($projdir);

my $default_buildplan = "BuildPlan.txt" ;
my $default_buildtype = "debug";
my $default_builddir  = getcwd()."/build";

my %options = ( buildplan => $default_buildplan,
                buildtype => $default_buildtype,
                builddir  => $default_builddir,
                cmakeopts => "",
                );

my %repos = ();
my %cmakevars = ();

#==============================================================================
# main functions
#==============================================================================

sub parse_commandline() # Parse command line
{
    GetOptions ( \%options,
    'populate',
    'refresh',
    'generate',
    'configure',
    'build',
    'help',
    'verbose',
    'debug',
    'dry-run',
    'prefix=s',
    'builddir=s',
    'buildplan=s',
    'buildtype=s',
    'cmakeopts=s',
    );

    # show help if required
    if( exists $options{help} )
    {
        print <<ZZZ;
ecbuild.pl : easy get and build software from ECMWF

usage: ecbuild.pl <action> [options]

actions:
        --populate          uses the git-proj command to populate the sources
        --refresh           uses the git-proj command to refresh the sources (internal git pull)
        --generate          generates the top CMakeLists.txt containing the subprojects
        --configure         configures the build, implies generate
        --build             actually builds and links, implies configure (default)

options:
        --help              shows this help
        --verbose           print every comand before executing
        --debug             sets the debug level
        --dry-run           don't actually do it, just list the repos that would be cooked
        --prefix            install dir prefix
        --builddir          where to build the software [$default_builddir]
        --buildplan         which file to use as build plan [$default_buildplan]
        --buildtype         defines the build type (debug, release, production) [$default_buildtype]
        --cmakeopts         extra cmake options for configure [$default_buildtype]

EXAMPLE:
  ecbuild.pl --build --builddir=/tmp/build --buildtype=release
ZZZ
        exit(0);
    }
}

#==============================================================================
# functions

sub chdir_to {
    my $dir  = shift;
    print "> change dir $dir\n" if($options{debug});
    chdir($dir) or die "cannot chdir to '$dir' ($!)";
}

#------------------------------------------------------------------------------

sub execute {
    my $command = shift;
    my $dir = getcwd();
    print "> executing [$command] in [$dir]\n" if($options{debug});
    my $result = `$command 2>&1`;
    if( $? != 0 ) { die "command [$command] failed: $!\n"; }
    return $result;
}

#------------------------------------------------------------------------------

sub command_exists {
    my $comm = shift;
    my $status = execute("which $comm");
    return 0 if ($status eq "");
    return 1;
}
    
#------------------------------------------------------------------------------

sub parse_plan  {

    chdir_to( $projdir );
    my $plan = $options{buildplan};
    open PLAN, "$plan" or die $!;

    while( <PLAN> )
    {
        chomp;
        s/#.*//;
        if(/^\s*([A-Z]+\/(\w+))\s+([^=]*)$/) {
            my $pack   = $1;
            my $repo   = $2;
            my $branch = $3;
            $repos{$repo} = { 'br' => $branch, 'pack' => $pack, };
            next;
        }
        
        if(/^\s*(\w+)\s*=\s*(.*)$/) {
            $cmakevars{$1} = $2;
            next;
        }

        if(/^\s*$/) {
            next;
        }

        print "WARNING: invalid entry: $_\n";
    }
}

#------------------------------------------------------------------------------

sub checkout_branch($) {

    my $p = shift;
    my $repo = $repos{$p};
    my $branch = $repo->{br};

    die "repo $p does not exist in $projdir" unless ( -d "$projdir/$p/.git" );

    print "> checking out repo $p $branch\n" if($options{debug});
    
    chdir_to( "$projdir/$p" ); 
    execute( "git checkout $branch" );
}

#------------------------------------------------------------------------------

sub populate_repo($) {

    my $p = shift;
    print "> populating repo $p\n" if($options{debug});

    chdir_to( $projdir ); 
    
    die "repo $p already exists" if( -d $p );

    my $repo = $repos{$p};
    my $pack = $repo->{pack};

    execute( "git clone ssh://git\@software.ecmwf.int:7999/$pack.git" );
    
    checkout_branch($p);
}

#------------------------------------------------------------------------------

sub refresh_repo($) {

    my $p = shift;
    my $repo = $repos{$p};
    my $branch = $repo->{br};

    die "repo $p does not exist in $projdir" unless ( -d "$projdir/$p/.git" );

    checkout_branch($p);

    print "> refreshing repo $p\n" if($options{debug});
    
    chdir_to( "$projdir/$p" ); 
    execute( "git pull -u origin $branch" );
}

#------------------------------------------------------------------------------

sub refresh() {

    print "> refresh\n" if($options{debug});
    
    foreach my $r ( sort keys %repos )
    {
        refresh_repo($r) if ( -d "$projdir/$r/.git" );
    }
}

#------------------------------------------------------------------------------

sub populate() {

    print "> populate\n" if($options{debug});

    foreach my $r ( sort keys %repos )
    {
        populate_repo($r) unless ( -d "$projdir/$r/.git" );
    }
}

#------------------------------------------------------------------------------

sub generate() {

    print "> generate\n" if($options{debug});

    if ( -e "$projdir/CMakeLists.txt" )
    {
        unlink "$projdir/CMakeLists.txt" or die "cannot remove file $projdir/CMakeLists.txt: $!";
    }

    open(OUT,">$projdir/CMakeLists.txt") or die "error writing to $projdir/CMakeLists.txt: $!";

    print OUT "cmake_minimum_required( VERSION 2.8.4 FATAL_ERROR )\n";
    print OUT "project( ${project}_suite C CXX )\n";
    print OUT "\n";

    print OUT "set( CMAKE_MODULE_PATH \"\${CMAKE_CURRENT_SOURCE_DIR}/cmake\" \${CMAKE_MODULE_PATH} )\n";
    
    if( -d "$projdir/ecbuild" )
        print OUT "set( CMAKE_MODULE_PATH \"\${CMAKE_CURRENT_SOURCE_DIR}/ecbuild/cmake\" \${CMAKE_MODULE_PATH} )\n";
    
    print OUT "include( ecbuild_system )\n"
       
    foreach my $kv ( sort keys %cmakevars ) 
    {
        print OUT "SET( $kv \"$cmakevars{$kv}\" )\n";
    }
    

    foreach my $r ( sort keys %repos )
    {        
        populate_repo($r) unless ( -d "$projdir/$r/.git" );

        print OUT "add_subdirectory( $r )\n";
    }
}

#------------------------------------------------------------------------------

sub configure() {

    generate() unless ( -e "$projdir/CMakeLists.txt" );

    chdir_to( $projdir );

    my $bdir  = $options{builddir};
    my $btype = $options{buildtype};

    mkpath $bdir unless ( -e $bdir );

    die "build dir $bdir/$btype already exists" if ( -e "$bdir/$btype" );

    mkpath "$bdir/$btype";    
    chdir_to( "$bdir/$btype" );

    print "> configure in $bdir with $btype\n" if($options{debug});
    
    my $opts = "-DCMAKE_BUILD_TYPE=$btype"; 
    
    my $cmakeopts = $options{cmakeopts};

    execute( "cmake $projdir $opts $cmakeopts" );
}

#------------------------------------------------------------------------------

sub build() {
    
    my $bdir = $options{builddir};
    
    print "> build in $bdir\n" if($options{debug});

    configure() unless ( -e "$bdir/CMakeCache.txt" );
    
    chdir_to($bdir);
    
    execute( "make -j4" );
}

#==============================================================================
# main

parse_commandline();

parse_plan();

#    foreach my $r (sort keys %repos) 
#    {
#        my $repo = $repos{$r};
#        foreach my $k ( sort keys %{ $repo } )
#        {
#            my $v = $repo->{$k};
#            print "$r $k $v\n";
#        }
#    }

populate()  if $options{populate};
refresh()   if $options{refresh};
generate()  if $options{generate};
configure() if $options{configure};
build()     if $options{build};

