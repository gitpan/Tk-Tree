package Tk::Tree;
# Tree -- TixTree widget
#
# Derived from Tree.tcl in Tix 4.1
#
# Chris Dean <ctdean@cogit.com>
# Changes: Renee Baecker <module@renee-baecker.de>

use vars qw($VERSION);
$VERSION = '3.1'; # $Id: //depot/Tk/Tixish/Tree.pm#4$

use Tk;
use Tk::Derived;
use Tk::HList;
@ISA = qw(Tk::Derived Tk::HList);
use strict;

Construct Tk::Widget 'Tree';

sub Tk::Widget::ScrlTree { shift->Scrolled('Tree' => @_) }
sub Populate{
  my( $w, $args ) = @_;

  $w->SUPER::Populate( $args );

  $w->ConfigSpecs(
        -ignoreinvoke => ["PASSIVE",  "ignoreInvoke", "IgnoreInvoke", 0],
        -opencmd      => ["CALLBACK", "openCmd",      "OpenCmd",
                          sub { $w->OpenCmd( @_ ) } ],
        -indicatorcmd => ["CALLBACK", "indicatorCmd",      "IndicatorCmd",
                          sub { $w->IndicatorCmd( @_ ) } ],
        -closecmd     => ["CALLBACK", "closeCmd",     "CloseCmd",
                          sub { $w->CloseCmd( @_ ) } ],
        -indicator    => ["SELF", "indicator", "Indicator", 1],
        -indent       => ["SELF", "indent", "Indent", 20],
        -width        => ["SELF", "width", "Width", 20],
        -itemtype     => ["SELF", "itemtype", "Itemtype", 'imagetext'],
       );
}

sub autosetmode{
  my( $w ) = @_;
  $w->setmode();
}


sub add_pathimage{
  my ($w,$path,$imgopen,$imgclose) = @_;
  $imgopen  ||= "minusarm";
  $imgclose ||= "plusarm";
  
  my $separator = $w->cget(-separator);
  
  $path =~ s/([\.?()|])/\\$1/g;
  $path =~ s/\$/\\\$/g;
  $path =~ s/\\\$$/\$/;
  $path =~ s/\*/[^$separator]+/g;
  
  push(@{$w->{Images}},[$path,$imgopen,$imgclose]);
}

sub IndicatorCmd{
  my( $w, $ent, $event ) = @_;

  my $mode = $w->getmode( $ent );

  if ( $event eq "<Arm>" ){
    if ($mode eq "open" ){
     $w->_open($ent);
    }
    else{
      $w->_close($ent);
    }
  }
  elsif ( $event eq "<Disarm>" ){
    if ($mode eq "open" ){
     $w->_open($ent);
    }
    else{
      $w->_close($ent);
    }
  }
  elsif( $event eq "<Activate>" ){
   $w->Activate( $ent, $mode );
   $w->Callback( -browsecmd => $ent );
  }
}

sub close{
  my( $w, $ent ) = @_;
  my $mode = $w->getmode( $ent );
  $w->Activate( $ent, $mode ) if( $mode eq "close" );
}

sub open{
  my( $w, $ent ) = @_;
  my $mode = $w->getmode( $ent );
  $w->Activate( $ent, $mode ) if( $mode eq "open" );
}

sub getmode{
  my( $w, $ent ) = @_;

  return( "none" ) unless $w->indicatorExists( $ent );

  my $img = $w->_indicator_image( $ent );
  if($img eq "plus" || $img eq "plusarm" || grep{$img eq $_->[2]}@{$w->{Images}}){
    return( "open" );
  }
  return( "close" );
}

sub setmode{
  my ($w,$ent,$mode) = @_;
  unless (defined $mode){
    $mode = "none";
    my @args;
    push(@args,$ent) if defined $ent;
    my @children = $w->infoChildren( @args );
    if ( @children ){
      $mode = "close";
      foreach my $c (@children){
        $mode = "open" if $w->infoHidden( $c );
        $w->setmode( $c );
      }
    }
  }

  if (defined $ent){
    if ( $mode eq "open" ){
      $w->_open($ent);
    }
    elsif ( $mode eq "close" ){
      $w->_close($ent);
    }
    elsif( $mode eq "none" ){
      $w->_indicator_image( $ent, undef );
    }
  }
}

sub _open{
  my ($w,$ent) = @_;
  $w->_indicator_image( $ent, "plus" );
  for my $entry (@{$w->{Images}}){
    if($ent =~ $entry->[0]){
      $w->_indicator_image( $ent, $entry->[2] );
    }
  }
}# _folder

sub _close{
  my ($w,$ent) = @_;
  $w->_indicator_image( $ent, "minus" );
  for my $entry (@{$w->{Images}}){
    if($ent =~ $entry->[0]){
      $w->_indicator_image( $ent, $entry->[1] );
    }
  }
}# _openfolder

sub Activate{
  my( $w, $ent, $mode ) = @_;
  if ( $mode eq "open" ){
    $w->Callback( -opencmd => $ent );
    $w->_close($ent);
  }
  elsif ( $mode eq "close" ){
    $w->Callback( -closecmd => $ent );
    $w->_open($ent);
  }
  else{
  }
}

sub OpenCmd{
  my( $w, $ent ) = @_;
  # The default action
  foreach my $kid ($w->infoChildren( $ent )){
    $w->show( -entry => $kid );
  }
}

sub CloseCmd{
  my( $w, $ent ) = @_;
  # The default action
  foreach my $kid ($w->infoChildren( $ent )){
    $w->hide( -entry => $kid );
  }
}

sub Command{
  my( $w, $ent ) = @_;

  return if $w->{Configure}{-ignoreInvoke};

  $w->Activate( $ent, $w->getmode( $ent ) ) if $w->indicatorExists( $ent );
}

sub _indicator_image{
  my( $w, $ent, $image ) = @_;
  my $data = $w->privateData();
  if (@_ > 2){
    if (defined $image){
      $w->indicatorCreate( $ent, -itemtype => 'image' )
        unless $w->indicatorExists($ent);
      $data->{$ent} = $image;
      $w->indicatorConfigure( $ent, -image => $w->Getimage( $image ) );
    }
    else{
      $w->indicatorDelete( $ent ) if $w->indicatorExists( $ent );
      delete $data->{$ent};
    }
  }
  return $data->{$ent};
}

1;

__END__

#  Copyright (c) 1996, Expert Interface Technologies
#  See the openfolder "license.terms" for information on usage and redistribution
#  of this openfolder, and for a DISCLAIMER OF ALL WARRANTIES.
#
#  The openfolder man.macros and some of the macros used by this openfolder are
#  copyrighted: (c) 1990 The Regents of the University of California.
#               (c) 1994-1995 Sun Microsystems, Inc.
#  The license terms of the Tcl/Tk distrobution are in the openfolder
#  license.tcl.

=head1 NAME

Tk::Tree - Create and manipulate Tree widgets

=head1 SYNOPSIS

    use Tk::Tree;

    $tree = $parent->Tree(?options?);

=head1 SUPER-CLASS

The B<Tree> class is derived from the B<HList> class and inherits all
the commands, options and subwidgets of its super-class.  A B<Tree> is
not scrolled by default.

=head1 STANDARD OPTIONS

B<Tree> supports all the standard options of an HList widget.
See L<options> for details on the standard options.

=head1 WIDGET-SPECIFIC OPTIONS

=over 4

=item Name:		B<browseCmd>

=item Class:		B<BrowseCmd>

=item Switch:		B<-browsecmd>

Specifies a command to call whenever the user browses on an entry
(usually by single-clicking on the entry). The command is called with
one argument, the pathname of the entry.

=back

=over 4

=item Name:		B<closeCmd>

=item Class:		B<CloseCmd>

=item Switch:		B<-closecmd>

Specifies a command to call whenever an entry needs to be closed (See
L<"BINDINGS"> below). This command is called with one argument,
the pathname of the entry. This command should perform appropriate
actions to close the specified entry. If the B<-closecmd> option
is not specified, the default closing action is to hide all child
entries of the specified entry.

=back

=over 4

=item Name:		B<command>

=item Class:		B<Command>

=item Switch:		B<-command>

Specifies a command to call whenever the user activates an entry
(usually by double-clicking on the entry). The command
is called with one argument, the pathname of the entry.

=back

=over 4

=item Name:		B<ignoreInvoke>

=item Class:		B<IgnoreInvoke>

=item Switch:		B<-ignoreinvoke>

A Boolean value that specifies when a branch should be opened or
closed. A branch will always be opened or closed when the user presses
the (+) and (-) indicators. However, when the user invokes a branch
(by doublc-clicking or pressing E<lt>ReturnE<gt>), the branch will be opened
or closed only if B<-ignoreinvoke> is set to false (the default
setting).

=back

=over 4

=item Name:		B<openCmd>

=item Class:		B<OpenCmd>

=item Switch:		B<-opencmd>

Specifies a command to call whenever an entry needs to be opened (See
L<"BINDINGS"> below). This command is called with one argument,
the pathname of the entry. This command should perform appropriate
actions to open the specified entry. If the B<-opencmd> option
is not specified, the default opening action is to show all the child
entries of the specified entry.

=back

=head1 DESCRIPTION

The B<Tree> method creates a new window and makes it into a Tree widget
and return a reference to it.  Additional options, described above, may
be specified on the command line or in the option database to configure
aspects of the Tree widget such as its cursor and relief.

The Tree widget can be used to display hierachical data in a tree
form. The user can adjust the view of the tree by opening or closing
parts of the tree.

To display a static tree structure, you can add the entries into the
B<hlist> subwidget and hide any entries as desired. Then you can call
the B<autosetmode> method. This will set up the Tree widget so that it
handles all the I<open> and I<close> events automatically. (Please see
the demonstration program F<examples/perl-tix-tree>).

The above method is not applicable if you want to maintain a dynamic tree
structure, i.e, you do not know all the entries in the tree and you need
to add or delete entries subsequently. To do this, you should first create
the entries in the B<hlist> subwidget. Then, use the setmode method to
indicate the entries that can be opened or closed, and use the B<-opencmd>
and B<-closecmd> options to handle the opening and closing events. (Please
see the demonstration program F<examples/perl-tix-dyntree>).

Use either

    $w->Scrolled( "Tree", ... )
or
    $w->ScrlTree(  ... )

to create a scrolled B<Tree>.

=head1 WIDGET METHODS

The B<Tree> method creates a widget object.  This command may be used
to invoke various operations on the widget. It has the following
general form:

I<$widget>-E<gt>B<method>(?I<arg arg ...>?)

I<$widget> is a reference to the B<Tree> widget as returned by the
C<Tree> constructor method.  I<Option> and the I<arg>s
determine the exact behavior of the method.  The following commands
are possible for Tree widgets:

=over 4

=item I<$widget-E<gt>>B<autosetmode>

This command calls the B<setmode> method for all the entries in
this Tree widget: if an entry has no child entries, its mode is set to
B<none>. Otherwise, if the entry has any hidden child entries, its
mode is set to B<open>; otherwise its mode is set to B<close>.

=item I<$widget-E<gt>>B<cget>(I<option>)

Returns the current value of the configuration option given by
I<option>. I<Option> may have any of the values accepted by the
B<Tree> constructor method.

=item I<$widget-E<gt>>B<close>(I<entryPath>)

Close the entry given by I<entryPath> if its I<mode> is B<close>.

=item I<$widget-E<gt>>B<configure>(?I<option>?, I<?value, option, value, ...>?)

Query or modify the configuration options of the widget.  If no
I<option> is specified, returns a list describing all of the
available options for $widget (see L<configure> for
information on the format of this list). If I<option> is specified
with no I<value>, then the command returns a list describing the
one named option (this list will be identical to the corresponding
sublist of the value returned if no I<option> is specified).  If
one or more I<option-value> pairs are specified, then the command
modifies the given widget option(s) to have the given value(s); in
this case the command returns an empty string.  I<Option> may have
any of the values accepted by the B<Tree> constructor method.

=item I<$widget-E<gt>>B<getmode>(I<entryPath>)

Returns the current I<mode> of the entry given by I<entryPath>.

=item I<$widget-E<gt>>B<open>(I<entryPath>)

Open the entry given by I<entryPath> if its I<mode> is B<open>.

=item I<$widget-E<gt>>B<setmode>(I<entryPath, mode>)

This command is used to indicate whether the entry given by
I<entryPath> has children entries and whether the children are
visible. I<mode> must be one of B<open>,
B<close> or B<none>. If I<mode> is set to B<open>, a (+)
indicator is drawn next the the entry. If I<mode> is set to
B<close>, a (-) indicator is drawn next the the entry. If
I<mode> is set to B<none>, no indicators will be drawn for this
entry. The default I<mode> is none. The B<open> mode indicates
the entry has hidden children and this entry can be opened by the
user. The B<close> mode indicates that all the children of the entry
are now visible and the entry can be closed by the user.

=item I<$widget-E<gt>>B<add_pathimage>(I<TreeRegExp [, OpenImg, CloseImg]>)

This command defines images for a given path (images must be in xpm-format). 
The path can be determined by a simplified RegEx.
There are just three metasymbols:

^ at the beginning of the C<TreeRegExp> same as in Perl RegExp
* anything
$ at the end of the C<TreeRegExp>, the same as in Perl RegExp

Examples:
  
  $tree->add_pathimage('^root','openfolder','folder');
  
matches C<root>, C<root.foo>, C<root.bar>, but not C<foo.root>

  $tree->add_pathimage('root.*.class','openfolder','folder');
  
matches all paths containing C<<root.<anything>.class>>, but not C<<root.<anything>.<anything>.class>>
C<*> is one part of the path. If you want to use a wildcard for two steps, you
have to use C<*.*>.

  $tree->add_pathimage('class$','openfolder','folder');
  
This matches all path with C<class> at the end.

=back

=head1 BINDINGS

The basic mouse and keyboard bindings of the Tree widget are the same
as the bindings of the HList widget.
In addition, the entries can be opened or closed under the following
conditions:

=over 4

=item [1]

If the I<mode> of the entry is B<open>, it can be opened by clicking
on its (+) indicator.

=item [2]

If the I<mode> of the entry is B<close>, it can be closed by clicking
on its (-) indicator.

=back

=head1 SEE ALSO

Tk::HList, Tix(n)

=head1 AUTHOR

Perl/TK version by Chris Dean <ctdean@cogit.com>.  Original Tcl/Tix
version by Ioi Kim Lam.
Co-maintained by Renee Baecker <module@renee-baecker.de>

=head1 ACKNOWLEDGEMENTS

Thanks to Achim Bohnet <ach@mpe.mpg.de> for all his help.

=cut
