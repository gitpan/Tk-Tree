use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Tk::Tree',
    VERSION           => '4.75',
    PREREQ_PM         => {
                           Tk        => 800.024,
                           Tk::HList => 3.040,
                         }, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Tk/Tree.pod', # retrieve abstract from module
       AUTHOR         => 'Chris Dean, Renee Baecker, Slaven Rezic') : ()),
);

sub MY::postamble {
    my $postamble = <<'EOF';

#TKWC=$(HOME)/work/Tk/trunk
TKWC=$(HOME)/work/svk-checkouts/Tk-amd64
MYDIFF=diff -up

diff-tk:
	@$(MYDIFF) t/dirtree.t         $(TKWC)/t/
	@$(MYDIFF) lib/Tk/Tree.pm      $(TKWC)/Tixish/
	@$(MYDIFF) lib/Tk/Tree.pod     $(TKWC)/pod/
	@$(MYDIFF) lib/Tk/DirTree.pm   $(TKWC)/Tixish/
	@$(MYDIFF) lib/Tk/DirTree.pod  $(TKWC)/pod/

pre-dist:
	cpan_check_versions

EOF

    if (defined $ENV{USER} && $ENV{USER} eq 'eserte' && $^O =~ /bsd/i && -f "../../perl.release.mk") {
	$postamble .= <<'EOF';

.include "../../perl.release.mk"
.include "../../perl.cvs.mk"

EOF
    }

    $postamble;
}
