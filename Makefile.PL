#$Id: Makefile.PL 1224 2008-04-30 01:53:48Z jimk $
use ExtUtils::MakeMaker;
require 5.006;
WriteMakefile(
    NAME		    => 'List::Compare',
    AUTHOR          => 'James E Keenan (jkeenan@cpan.org)',
    VERSION_FROM	=> 'lib/List/Compare.pm',
    ABSTRACT_FROM	=> 'lib/List/Compare.pm',
    PREREQ_PM		=> { Test::Simple => 0.10 },
);
