#!/usr/bin/env perl

# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

# ==========================================================================
# sg.pl -- Serialisation Generator
# ==========================================================================
#
# PURPOSE
#
#   Generates .b ("bless") files that are #included into C++ class bodies
#   to provide eckit's persistence / serialisation infrastructure:
#
#     - Bless constructor    ClassName(eckit::Bless& b)
#     - Evolve constructor   ClassName(eckit::Evolve b)
#     - specName()           static type identifier string
#     - isa()                RTTI-style type chain registration
#     - schema()             member layout introspection
#     - describe()           human-readable dump  (unless hand-written)
#     - _export()            binary export via eckit::Exporter
#
#   A header opts in by containing  #include "path/ClassName.b"  inside
#   the class body.  The build system (CMake) detects this and invokes
#   sg.pl on the header at configure/build time.
#
# USAGE
#
#   perl sg.pl <header.h> [output_dir] [namespace]
#
#     header.h   -- C++ header to parse (required)
#     output_dir -- directory for generated .b files (default: dirname of header)
#     namespace  -- C++ namespace qualifying helper functions (default: "eckit")
#
# HOW IT WORKS
#
#   1. Preprocessing  (parse sub, lines 177-183 in original)
#      - Strip all preprocessor lines (^#...) -- includes, guards, macros
#      - Strip all C++ line comments (//...)
#      - Tokenize: split on word boundaries (\b), then split each
#        non-word token into individual characters so that operators,
#        braces, and punctuation each become a single token.
#      - Drop empty/whitespace-only tokens.
#
#   2. Parsing
#      A hand-written recursive-descent parser walks the token stream
#      looking for class/struct definitions (possibly preceded by
#      template<...>).  For each class found it records:
#        - name, base classes (super), template parameters
#        - member variables  (name + type)
#        - member functions  (name, type, args, const/static/virtual/...)
#        - nested classes
#
#   3. Code generation
#      For each parsed class, a .b file is written to output_dir
#      containing the C++ method bodies listed above.
#
# KNOWN LIMITATIONS
#
#   The parser is intentionally minimal -- just enough to handle the
#   class declarations found in eckit headers that use the .b mechanism.
#
#   - Template parameters: only "class", "bool", and "int" are accepted
#     as parameter keywords.  "typename" and non-type template parameters
#     other than bool/int will cause a parse error.
#   - Multi-declaration members (int a, b, *c;) are not supported.
#   - Block comments (/* ... */) are only handled inside class bodies,
#     not at file scope.
#   - C-style casts, complex SFINAE expressions, and many modern C++
#     constructs are not understood and will cause parse failures if
#     they appear in headers processed by this script.
#   - Pure virtual = 0 is supported; = default / = delete are not.
#   - Explicit template specializations (template <>) are skipped
#     entirely, since they are never persistence classes.
#
# ==========================================================================

use strict;

use File::Basename;

# --------------------------------------------------------------------------
# Command-line arguments
# --------------------------------------------------------------------------

# (1) C++ header file to process (required)
my $file = $ARGV[0];

# (2) Output directory for generated .b files (optional, defaults to
#     the directory containing the input file)
my $base = $ARGV[1];

# (3) C++ namespace used to qualify helper functions in the generated
#     code -- eckit::_describe, eckit::_export, etc. (optional,
#     defaults to "eckit")
my $namespace = $ARGV[2];

if( $base eq "" )
{
	$base = dirname($file);
}

if( $namespace eq "" )
{
    $namespace = "eckit"
}

# --------------------------------------------------------------------------
# Parse the header and generate .b files
# --------------------------------------------------------------------------

# Parse returns a list of "class" objects -- one per class definition
# found in the header (forward declarations are skipped).
my @c = parser::parse($file);

foreach my $c ( @c )
{
	my $n = $c->name;

	# Each class gets its own .b file, written to stdout redirected
	# to $base/$n.b.
	open(STDOUT,">$base/$n.b") || die "$base/$n.b: $!";

	# ------------------------------------------------------------------
	# Build the Bless constructor initialiser list.
	# Bless is the "deserialise from raw memory" path.  Base classes
	# are initialised with (b) and members with (b(&member)).
	# ------------------------------------------------------------------
	my @init1;
	push @init1, map { "$_(b)" } $c->super;
	push @init1, map { "$_(b(\&$_))" } $c->members;

	my $col1 = "";
	$col1=":\n" if(@init1);
	my $init1 = join(",\n",map {"\t$_"} @init1);

	# ------------------------------------------------------------------
	# Build the Evolve constructor initialiser list.
	# Evolve is the "deserialise from named-field archive" path.
	# Base classes get (b("ClassName")) and members get
	# (b("ClassName","memberName")).
	# ------------------------------------------------------------------
	my @init2;
	push @init2, map { "$_(b(\"$n\"))" } $c->super;
	push @init2, map { "$_(b(\"$n\",\"$_\"))" } $c->members;

	my $col2 = "";
	$col2=":\n" if(@init2);
	my $init2 = join(",\n",map {"\t$_"} @init2);

	# ------------------------------------------------------------------
	# describe() -- human-readable recursive dump of the object tree.
	# Calls _startClass / base::describe / _describe(member) / _endClass.
	# ------------------------------------------------------------------
	my @s = map { "${_}::describe(s,depth+1)"      } $c->super;
	my @m = map { "${namespace}::_describe(s,depth+1,\"$_\",$_)" } $c->members;
	my $d = join(";\n\t","${namespace}::_startClass(s,depth,specName())",@s,@m,"${namespace}::_endClass(s,depth,specName())");

	# ------------------------------------------------------------------
	# _export() -- binary export via eckit::Exporter.
	# Same pattern: _startClass / base::_export / _export(member) / _endClass.
	# ------------------------------------------------------------------
	my @s = map { "${_}::_export(h)"      } $c->super;
	my @m = map { "${namespace}::_export(h,\"$_\",$_)" } $c->members;
	my $D = join(";\n\t","${namespace}::_startClass(h,\"$n\")",@s,@m,"${namespace}::_endClass(h,\"$n\")");

	# ------------------------------------------------------------------
	# specName() -- static method returning the type's string identifier.
	# For plain classes this is a const char* literal "ClassName".
	# For template instantiations it builds a std::string at runtime:
	#   "ClassName<" + Traits<T1>::name() + "," + Traits<T2>::name() + ">"
	# ------------------------------------------------------------------
	my $spec = "\"$n\"";
	my @tmpl = $c->template;

	my $spec_type = "const char*";

	if(@tmpl)
	{
		$spec_type = "std::string";
		my $x = join("+ ',' + ",  map { "Traits<$_>::name()"; } @tmpl);
		$spec = <<"EOS";
        std::string("$n<\") + $x + ">"
EOS
		$spec =~ s/\n/ /g;
	}

	# ------------------------------------------------------------------
	# isa() -- registers this type (and all bases) in eckit's RTTI chain.
	# Generates:  Base1::isa(t); Base2::isa(t); eckit::Isa::add(t, specName());
	# ------------------------------------------------------------------
	my $isa = "${namespace}::Isa::add(t,specName());";
	foreach my $s ( $c->super )
	{
		$isa = "${s}::isa(t);$isa";
	}

	# ------------------------------------------------------------------
	# schema() -- introspection of member layout (name, size, offset, type).
	# ------------------------------------------------------------------
	my $schema;
	@s = map { "${_}::schema(s)"      } $c->super;
	@m = map { $a=$_->[0]; $b=$_->[1]; "s.member(\"$a\",member_size($n,$a),member_offset($n,$a),\"$b\")" } $c->members_types;
	$schema = join(";\n\t","s.start(specName(),sizeof($n))",@s,@m,"s.end(specName())");

	# ------------------------------------------------------------------
	# Emit the .b file
	# ------------------------------------------------------------------

	# Bless constructor and Evolve constructor
	print <<"EOF";

${n}(${namespace}::Bless& b)$col1$init1
{
}

${n}(${namespace}::Evolve b)$col2$init2
{
}

static ${spec_type} specName()      { return ${spec}; }
static void isa(TypeInfo* t)  { ${isa} }
static ${namespace}::Isa* isa()             { return ${namespace}::Isa::get(specName());  }

static void schema(${namespace}::Schema& s)
{
	$schema;
}

EOF

	# describe() is only generated if the class doesn't already define
	# its own -- allows hand-written overrides.
	if(!$c->has_method("describe"))
	{
print <<"EOF";

void describe(std::ostream& s,int depth = 0) const {
	$d;
}


EOF
	}

	print <<"EOF";

void _export(${namespace}::Exporter& h) const {
	$D;
}


EOF

}

# Dead code -- older schema-only generator kept for reference.
# Guarded by if(0) so it never executes.
if(0)
{
foreach my $c ( @c )
{
	my $n = $c->name;
	open(OUT,">${n}.b");
	select OUT;
	print "static void schema(${namespace}::Schema& s) {\n";
	foreach my $x ( $c->super )
	{
		print "${x}::schema(s);\n";
	}
	foreach my $x ( $c->members )
	{
		print "s(\"${n}::$x\",offsetof($n,$x),sizeof(&(($n*)0)->$x));\n";
	}
	print "}\n";
}
}

# ==========================================================================
# package parser -- recursive-descent C++ header parser
# ==========================================================================
#
# Parses a minimal subset of C++ sufficient to extract class definitions
# with their base classes, member variables, and method signatures.
#
# The token stream is stored in the package-level @TOKENS array.
# Each "sub" below either consumes tokens or peeks at the head.
#
# ==========================================================================

package parser;
use Carp;
my @TOKENS;

# --------------------------------------------------------------------------
# parse($file) -> @classes
#
# Entry point.  Reads the file, preprocesses it into a token stream,
# and runs the top-level grammar loop.
#
# Preprocessing:
#   1. Strip lines starting with # (preprocessor directives, include
#      guards, macros).  This means #define'd code is invisible to us.
#   2. Strip // line comments.
#   3. Tokenize: split on word boundaries, then split non-word chunks
#      into individual characters (so "{", "(", "*", etc. are each one
#      token).  Drop whitespace-only and empty tokens.
#
# Top-level grammar:
#   Repeatedly scan for "typedef", "template", "class", or "struct".
#   - typedef:  skip to ";" (not interesting for .b generation)
#   - template: parse template parameter list, then the class that follows
#   - class/struct: parse class definition
#
# Returns a list of "class" objects (blessed hashrefs).  Forward
# declarations and explicit specializations return undef and are
# filtered out.
# --------------------------------------------------------------------------
sub parse {
	my ($file) = @_;
	local $/ = undef;
	open(IN,"<$file") || croak "$file: $!";
	my $x = <IN>;
	close(IN);

	# Preprocessing
	$x =~ s/^#.*$//mg;      # strip preprocessor lines
	$x =~ s/\/\/.*$//mg;    # strip line comments

	# Tokenize
	@TOKENS =
		grep { length($_);                }   # drop empty tokens
		map  { /\W/ ? split('',$_) :  $_; }   # split non-word tokens into chars
		map  { s/\s//g; $_;               }   # strip whitespace within tokens
		split(/\b/, $x );                      # split on word boundaries

	# Top-level grammar loop
	my @c;
	my $x;
	while($x = consume_until("(typedef|template|class|struct)"))
	{
		if($x eq 'typedef')
		{
			consume_until(";");
			next;
		}

		if($x eq 'template')
		{
			push @c, parse_template();
		}
		else
		{
			push @c, parse_class();
		}
	}

	# Filter out undefs (forward declarations, skipped specializations)
	return grep { defined $_; } @c;
}

# --------------------------------------------------------------------------
# parse_template() -> class | undef
#
# Called after consuming the "template" keyword.  Parses the template
# parameter list <...>, then the class/struct definition that follows.
#
# Special case: explicit specializations (template <>) have an empty
# parameter list.  These are never persistence classes so we skip the
# entire declaration and return undef.
# --------------------------------------------------------------------------
sub parse_template {
	my @tmp = template_args();
	if(!@tmp)
	{
		# Explicit specialization (template <>): not a new class,
		# skip the entire declaration.
		my $x = consume_until('(;|\{)');
		if($x eq '{')
		{
			unshift @TOKENS, $x;
			consume_block('{','}');
			next_is(";");
		}
		return;
	}
	return parse_class(@tmp) if(next_is("(class|struct)"));
}

# --------------------------------------------------------------------------
# template_args() -> @parameter_names
#
# Parses the angle-bracketed template parameter list.
#
# Handles:
#   template <>                       -> empty list (explicit specialization)
#   template <class T>                -> ("T")
#   template <class T, class U>       -> ("T", "U")
#   template <class T = DefaultType>  -> ("T")  (default is discarded)
#   template <bool B>                 -> ("B")
#   template <int N>                  -> ("N")
#
# Does NOT handle "typename" -- only "class", "bool", and "int" are
# accepted as parameter keywords.
# --------------------------------------------------------------------------
sub template_args {
	my @tmp;
	expect_next("<");

	# Empty parameter list: template <>
	if(next_is(">"))
	{
		return @tmp;
	}

	for(;;)
	{
		expect_next("(class|bool|int)");
		push @tmp, next_ident();

		# Skip default argument: = SomeType<...>
		if(next_is("="))
		{
			my $x = consume_until('(,|\>|\<)');
			unshift @TOKENS,$x;
			while($x eq '<')
			{
				consume_block('<','>');
				$x = consume_until('(,|\>|\<)');
				unshift @TOKENS,$x;
			}
		}
		last unless(next_is(","));
	}
	expect_next(">");
	return @tmp;
}

# --------------------------------------------------------------------------
# parse_class(@template_params) -> class | undef
#
# Parses a class or struct definition.  @template_params is empty for
# non-template classes.
#
# Grammar (simplified):
#   ClassName ;                            -> forward declaration, return undef
#   ClassName : [virtual] [public] Base    -> inheritance
#   ClassName { ... } ;                    -> full definition
#
# Inside the class body, recognises:
#   - Access specifiers (public/private/protected:)
#   - Friend declarations (skipped)
#   - Nested typedefs, using, typename, enum (skipped to ;)
#   - Nested class/struct (recursive parse_class)
#   - Template member functions
#   - Member variables (type + name, terminated by ; , or =)
#   - Member functions (type + name + (...) + optional body)
#   - C-style block comments (/* ... */)
#   - Operator overloads (operator+, operator(), operator new[], etc.)
#   - Pure virtual (= 0)
#   - Constructor initialiser lists (: member(init), ...)
#
# Returns a blessed "class" hashref with fields:
#   name      -> string
#   super     -> [base class names]
#   template  -> [template parameter names]
#   members   -> [{name, type, static?}]
#   methods   -> [{name, type, args, const?, static?, virtual?, ...}]
#   classes   -> [nested class objects]
# --------------------------------------------------------------------------
sub parse_class {
	my (@tmp) = @_;
	my $self = {};
	my $name = next_ident();
	$self->{name}     = $name;
	$self->{template} = \@tmp if(@tmp);

	# Forward declaration: "class Foo;"
	return if(next_is(";"));

	# Inheritance list: "class Foo : public Base1, virtual Base2"
	if(next_is(":"))
	{
		for(;;)
		{
			ignore_while("(public|private|protected|virtual)");
			push @{$self->{super}}, next_ident();
			last unless(next_is(","));
		}
	}

	# Class body
	expect_next('{');
	while(!peek_next('}'))
	{
		# --- Block comments inside class body (/* ... */) ---
		if(next_is('\/'))
		{
			if(next_is('\*'))
			{
				while(!next_is('\/'))
				{
					consume_until('\*');
				}
				next;
			}
			else
			{
				unshift @TOKENS, "/";
			}

		}

		# --- Access specifiers ---
		if(next_is("(public|private|protected)"))
		{
			expect_next(":");
			next;
		}

		# --- Friend declarations (skip entirely) ---
		if(next_is("friend"))
		{
			my $x = consume_until("(;|{)");
			if($x eq "{")
			{
				unshift @TOKENS, $x;
				consume_block('{','}');
			}
			next;
		}

		# --- typedef, using, typename, enum (skip to ;) ---
		if(next_is("(typedef|using|typename|enum)"))
		{
			consume_until(";");
			next;
		}

		# --- Nested class/struct ---
		if(next_is("(class|struct)"))
		{
			push @{$self->{classes}}, parse_class();
			next;
		}

		# --- Begin parsing a member variable or method declaration ---
		my %m;

		# Template member functions: template <class T> void foo(...)
		while(next_is("template"))
		{
			push @{ $m{template} } , template_args();
		}

		my @x;

		$m{explicit} = 1 if(next_is("explicit"));
		$m{static}   = 1 if(next_is("static"));
		$m{virtual}  = 1 if(next_is("virtual"));

		# Accumulate type + name tokens.  The last identifier before
		# a delimiter ( ; , = ( ) is the member/method name; everything
		# before it is the type.
		my $x;
		while($x = next_is_ident())
		{
			push @x, $x;
			push @x,'*' while(next_is('\*'));
			push @x,'&' while(next_is('\&'));
			$m{name} = $x;

			# --- Member variable: terminated by , ; or = ---
			my $s;
			if($s = next_is('(,|;|=)'))
			{
				pop @x;
				$m{type} = make_type(@x);
				if(exists $m{static})
				{
					push @{$self->{class_members}}, \%m;
				}
				else
				{
					push @{$self->{members}}, \%m;
				}
				consume_until(";") if($s eq '=');
				last;
			}

			# --- Method: name followed by (...) ---
			if(peek_next('\('))
			{
				pop @x;
				$m{type} = make_type(@x);

				# Parse argument list
				my @args = consume_block('(',')');
				shift @args;   # remove opening '('
				pop @args;     # remove closing ')'

				# Split arguments on top-level commas
				# (commas inside <> or () are nested, not separators)
				my @a;
				my $n = 0;
				my @z;
				foreach my $a ( @args )
				{
					if($a eq ',' && $n == 0)
					{
						push @a, make_type(@z);
						@z = ();
						next;
					}
					$n++ if($a eq '<');
					$n++ if($a eq '(');
					$n-- if($a eq ')');
					$n-- if($a eq '>');
					push @z,$a;
				}
				push @a, make_type(@z) if(@z);
				$m{const} = 1 if(next_is("const"));
				$m{override} = 1 if(next_is("override"));
				$m{args}  = \@a;
				if(exists $m{static})
				{
					push @{$self->{class_methods}}, \%m;
				}
				else
				{
					push @{$self->{methods}}, \%m;
				}

				# Method body or declaration
				if(next_is(':'))
				{
					# Constructor initialiser list: skip to { and consume body
					consume_until('\{');
					unshift @TOKENS, '{';
					consume_block('{','}');
				}
				else
				{
					if(peek_next('\{'))
					{
						# Inline method body
						consume_block('{','}');
					}
					else
					{
						# Pure virtual (= 0) or plain declaration (;)
						if(next_is("="))
						{
							expect_next("0");
							$m{abstract} = 1;
						}
						expect_next(";");
					}
				}
				last;
			}
		}

	}
	expect_next("}");
	expect_next(";");
	return bless($self,"class");
}

# ==========================================================================
# Token stream primitives
# ==========================================================================

# --------------------------------------------------------------------------
# consume_until($regex) -> $token | undef
#
# Discards tokens until one matches $regex, then returns that token.
# Returns undef if the token stream is exhausted.
# --------------------------------------------------------------------------
sub consume_until {
	my ($r) = @_;
	while(@TOKENS)
	{
		my $x = shift @TOKENS;
		return $x if($x =~ /^$r$/);
	}
	return undef;
}

# --------------------------------------------------------------------------
# consume_block($open, $close) -> @tokens
#
# Consumes a balanced block of tokens delimited by $open/$close
# (e.g. '{'/'}', '('/')', '<'/'>').  Returns all consumed tokens
# including the delimiters.  Handles nesting.
#
# Precondition: $TOKENS[0] must equal $open.
# --------------------------------------------------------------------------
sub consume_block {
	my ($bra,$ket) = @_;
	my $n = 0;
	my @x;
	croak "@TOKENS" unless($bra eq $TOKENS[0]);
	while(@TOKENS)
	{
		my $x = shift @TOKENS;
		$n++ if($x eq $bra);
		$n-- if($x eq $ket);
		push @x,$x;
		return @x if($n == 0);
	}
}

# --------------------------------------------------------------------------
# ignore_while($regex)
#
# Consumes and discards consecutive tokens matching $regex.
# Stops at the first non-matching token (which is left in the stream).
# --------------------------------------------------------------------------
sub ignore_while {
	my ($r) = @_;
	while(@TOKENS)
	{
		return unless($TOKENS[0] =~ /^$r$/);
		shift @TOKENS;
	}
}

# --------------------------------------------------------------------------
# expect_next($regex) -> $token
#
# Consumes the next token and asserts it matches $regex.
# Croaks (dies with stack trace) on mismatch.
# --------------------------------------------------------------------------
sub expect_next {
	my ($r) = @_;
	my $ident = shift @TOKENS;
	croak "$ident is not $r" unless($ident =~ /^$r$/);
	return $ident;
}

# --------------------------------------------------------------------------
# next_ident() -> $identifier
#
# Consumes and returns the next identifier (via next_is_ident).
# Croaks if the next token is not an identifier.
# --------------------------------------------------------------------------
sub next_ident {
	my $x = next_is_ident();
	croak "not an ident " unless($x);
	return $x;
}

# --------------------------------------------------------------------------
# next_is($regex) -> $token | undef
#
# If the next token matches $regex, consumes and returns it.
# Otherwise returns undef and leaves the stream unchanged.
# --------------------------------------------------------------------------
sub next_is {
	my ($r) = @_;
	if($TOKENS[0] =~ /^$r$/)
	{
		return shift @TOKENS;
	}
	return undef;
}

# --------------------------------------------------------------------------
# next_is_ident() -> $identifier | undef
#
# Tries to consume a C++ identifier from the token stream.
# Handles several complex cases:
#
#   - Operator overloads: "operator+", "operator()", "operator new",
#     "operator delete[]", "operator<<", etc.
#   - Destructors: "~ClassName"
#   - Template identifiers: "Foo<Bar, Baz>" (angle brackets consumed
#     as a block and appended to the name)
#   - Qualified names: "Namespace::Name" (one level of :: only)
#
# Returns the full identifier string, or undef if the next token is
# not the start of an identifier.
# --------------------------------------------------------------------------
sub next_is_ident {
	# Check for "operator" keyword first
	my $op = next_is("operator");
	if($op)
	{
		my $x;
		# operator new / operator delete / operator new[] / operator delete[]
		if($x = next_is("(new|delete)"))
		{
			$op .= " $x";
			if(next_is('\['))
			{
				expect_next('\]');
				$op .= "[]";
			}
			return $op;
		}

		# operator()
		if(next_is('\('))
		{
			expect_next('\)');
			$op .= "()";
		}

		# operator+, operator<<, operator==, operator!=, etc.
		my $z;
		while($z = next_is('[\-+/\*\[\]<>=!]'))
		{
			$op .= $z;
		}
		return $op;
	}

	# Optional ~ for destructors
	my $y = next_is('\~');

	# The identifier itself (any \w+ token)
	my $x = next_is('\w+');
	if($x)
	{
		$x = (defined $y ? "$y$x" : $x);

		# Template arguments: Foo<Bar>
		if(peek_next("<"))
		{
			my @x = consume_block("<",">");
			$x .= join("",@x);
		}

		# Scope resolution: Namespace::Name (one level)
		if(next_is(":"))
		{
			if(next_is(":"))
			{
				my $z = next_is_ident();
				return "${x}::${z}";
			}
			else
			{
				# Single colon was not ::, put it back
				unshift @TOKENS, ":";
			}
		}
	}
	return $x;
}

# --------------------------------------------------------------------------
# peek_next($regex) -> bool
#
# Returns true if the next token matches $regex, without consuming it.
# --------------------------------------------------------------------------
sub peek_next {
	my ($r) = @_;
	if($TOKENS[0] =~ /^$r$/)
	{
		return 1;
	}
	return 0;
}

# --------------------------------------------------------------------------
# make_type(@tokens) -> $type_string
#
# Joins a list of type tokens into a human-readable type string.
# Inserts spaces between consecutive word tokens and between
# pointer/reference sigils and following words.  Normalises ">>"
# to "> >" for C++03 compatibility.
# --------------------------------------------------------------------------
sub make_type {
	my (@a) = @_;
	my $p;
	my @x;
	foreach my $a ( @a )
	{
		push @x, " " if(defined $p && $p =~ /^(\w+|\&|\*)$/ && $a =~ /^\w+$/);
		push @x, $a;
		$p = $a;
	}
	my $s = join('',@x);
	$s =~ s/>>/> >/g;
	return $s;
}

# ==========================================================================
# package class -- data object representing a parsed C++ class
# ==========================================================================
#
# Fields (hashref keys):
#   name           -> string: class name
#   super          -> [string]: base class names
#   template       -> [string]: template parameter names
#   members        -> [{name, type}]: non-static member variables
#   class_members  -> [{name, type}]: static member variables
#   methods        -> [{name, type, args, const?, override?}]: non-static methods
#   class_methods  -> [{name, type, args}]: static methods
#   classes        -> [class]: nested class definitions
#
# ==========================================================================

package class;

# name() -> $string
sub name {
	my ($self) = @_;
	return $self->{name};
}

# super() -> @strings  (base class names)
sub super {
	my ($self) = @_;
	return $self->{super} ? @{$self->{super}} : ();
}

# members() -> @strings  (member variable names)
sub members {
	my ($self) = @_;
	my @x = $self->{members} ? @{$self->{members}} : ();
	return map { $_->{name} } @x;
}

# methods() -> @strings  (method names)
sub methods {
	my ($self) = @_;
	my @x = $self->{methods} ? @{$self->{methods}} : ();
	return map { $_->{name} } @x;
}

# has_method($name) -> bool
# Returns true if the class has a method with the given name.
# Used to check whether describe() is hand-written.
sub has_method {
	my ($self,$name) = @_;
	return grep { $_ eq $name } $self->methods;
}

# members_types() -> @[ [$name, $type] ]
# Returns member variables with both name and type.
sub members_types {
	my ($self) = @_;
	my @x = $self->{members} ? @{$self->{members}} : ();
	return map { [ $_->{name}, $_->{type} ]  } @x;
}

# template() -> @strings  (template parameter names)
sub template {
	my ($self) = @_;
	return $self->{template} ? @{$self->{template}} : ();
}
1;
