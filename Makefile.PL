use ExtUtils::MakeMaker;

# Write the Makefile
WriteMakefile(
    'NAME'         => 'Tk-Tree',
    'VERSION_FROM' => 'Tk/Tree.pm', # finds $VERSION
    'dist'         => {
        COMPRESS     => 'gzip -9f',
        SUFFIX       => '.gz', 
        DIST_DEFAULT => 'all tardist',
    },
    PMLIBDIRS => ['Tk'],
);
