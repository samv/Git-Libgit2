use 5.010001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Git::Libgit2',
    VERSION_FROM      => 'lib/Git/Libgit2.pm', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Git/Libgit2.pm', # retrieve abstract from module
       AUTHOR         => 'Sam Vilain <samv@cpan.org>') : ()),
    LIBS              => ['-lgit2'], # e.g., '-lm'
    DEFINE            => '', # e.g., '-DHAVE_SOMETHING'
    INC               => '-I.', # e.g., '-I. -I/usr/include/other'
    TYPEMAPS          => ['perlobject.map'],
	# Un-comment this if you add C files to link with later:
    #OBJECT            => '$(O_FILES)', # link all the C files too
);
