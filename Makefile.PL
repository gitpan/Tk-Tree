use 5.006001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Tk::Tree',
    VERSION_FROM      => 'lib/Tk/Tree.pm', # finds $VERSION
    PREREQ_PM         => {
                           Tk        => 800.024,
                           Tk::HList => 3.040,
                         }, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Tk/Tree.pm', # retrieve abstract from module
       AUTHOR         => 'Chris Dean, Renee Baecker') : ()),
);
