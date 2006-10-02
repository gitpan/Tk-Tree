use Test::More;

SKIP:{
    eval "use Test::Pod::Coverage";
    skip "Test::Pod::Coverage required",1 if $@;
    plan tests => 2;
    pod_coverage_ok("Tk::Tree");
    pod_coverage_ok("Tk::DirTree");
}


