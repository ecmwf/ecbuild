#!/usr/bin/perl

# (C) Copyright 1996-2015 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

use strict;

my $LICENSE = <<"EOF";
(C) Copyright 1996-2015 ECMWF.

This software is licensed under the terms of the Apache Licence Version 2.0
which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
In applying this licence, ECMWF does not waive the privileges and immunities 
granted to it by virtue of its status as an intergovernmental organisation nor
does it submit to any jurisdiction.
EOF

my %COMMENTS = (

		java       => { start => "/*\n"  , end => " */\n\n"  , comment => " * " },
		xml        => { start => "<!--\n", end => "-->\n\n" , after => "\<\?xml[^<]*\>" },
#		xsd        => { start => "<!--\n", end => "-->\n\n" },
#		jsp        => { start => "<!--\n", end => "-->\n\n" },
		sh         => { comment => "# ", end => "\n", after => "^#!/.*\n" },
		pl         => { comment => "# ", end => "\n", after => "^#!/.*\n" },
		pm         => { comment => "# ", end => "\n", after => "^#!/.*\n" },
		py         => { comment => "# ", end => "\n", after => "^#!/.*\n" },
		js         => { start => "/*\n"  , end => " */\n\n"  , comment => " * " },
		c          => { start => "/*\n"  , end => " */\n\n"  , comment => " * " },
		cc         => { start => "/*\n"  , end => " */\n\n"  , comment => " * " },
		cpp        => { start => "/*\n"  , end => " */\n\n"  , comment => " * " },
		cxx        => { start => "/*\n"  , end => " */\n\n"  , comment => " * " },
		h          => { start => "/*\n"  , end => " */\n\n"  , comment => " * " },
		hh         => { start => "/*\n"  , end => " */\n\n"  , comment => " * " },
		hpp        => { start => "/*\n"  , end => " */\n\n"  , comment => " * " },
		l          => { start => "/*\n"  , end => " */\n\n"  , comment => " * " },
		'y'        => { start => "/*\n"  , end => " */\n\n"  , comment => " * " },
		'f'        => { comment => "C ", end => "C\n\n" }, # assume f77
		'F'        => { comment => "C ", end => "C\n\n" }, # assume f77
		'for'      => { comment => "C ", end => "C\n\n" }, # assume f77
		'f77'      => { comment => "C ", end => "C\n\n" },
		'f90'      => { comment => "! ", end => "!\n\n" },
		cmake      => { end => "\n", comment => "# " },
		css        => { start => "/*\n"  , end => " */\n\n"  , comment => " * " },
		sql        => { comment => "-- ", end => "\n" },
		properties => { comment => "# ", end => "\n" },
		def        => { comment => "# ", end => "\n" },

		);
        
my %cmdargs = map { $_ => 1 } @ARGV;

foreach my $file ( @ARGV )
{
    next if( $file eq "-u" or $file eq "--update" );

#   my $doit=0;
    my $doit=1;

	$file =~ /\.(\w+)$/;
	my $ext = $1;

	my $c = $COMMENTS{$ext};

	unless($c)
	{
		print "$file: unsupported extension. File ignored\n";
		next;
	}

	open(IN,"<$file") or die "$file: $!";
	my @text = <IN>;
	close(IN);

	if(join("",@text) =~ /icensed under the/gs) 
	{
        if( exists( $cmdargs{"-u"} ) or exists( $cmdargs{"--update"} ) )
        {
            # lets update the year if needed
            my $currentyear = (localtime)[5] + 1900;
            if($doit)
            {
                print("$file: updating license year to $currentyear\n");
                system("perl -pi -e 's/Copyright ([0-9]{4})-[0-9]{4} ECMWF/Copyright \$1-$currentyear ECMWF/' $file");
            }
        }
        else
        {    
            print "$file: License already stated. File ignored\n";
        }
		next;
	}

	open(OUT,">$file.tmp") or die "$file.tmp: $!";

	if($c->{after})
	{
		my @x;
		my $re = $c->{after};
		loop: while(@text)
		{
			if($text[0] =~ m/$re/)
			{
				print OUT @x, shift @text;
				@x = ();
				last loop;
			}
			push @x,shift @text;
		}
		@text = (@x,@text);
	}

	print OUT $c->{start};
	foreach my $line ( split("\n",$LICENSE) )
	{
		print OUT $c->{comment}, $line,"\n";
	}
	print OUT $c->{end};

	print OUT @text;
	close(OUT) or die "$file: $!";

    if($doit)
    {
        use File::Copy qw(cp);
        use File::Compare qw(compare_text compare);

        if(compare_text("$file.tmp",$file))
        {
            print "UPDATING file $file\n";
            system("p4 edit $file") unless(-w $file);
#s            cp($file,"$file.old") or die "cp($file,$file.old): $!";
            cp("$file.tmp",$file) or die "cp($file.tmp,$file): $!";
        }
    }
    else
    {
        print "IGNORING file $file\n";
    }

    unlink("$file.tmp");


}

