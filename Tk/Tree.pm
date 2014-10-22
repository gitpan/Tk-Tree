# Tree -- TixTree widget
#
# Derived from Tree.tcl in Tix 4.1
#
# Chris Dean <ctdean@cogit.com> 

package Tk::Tree;

use Tk;
use Tk::VTree;
use strict;
use vars qw( @ISA $VERSION );
@ISA = qw( Tk::VTree );

$VERSION = "0.04";

Construct Tk::Widget 'Tree';

sub Populate {
    my( $w, $args ) = @_;

    $w->SUPER::Populate( $args );

    $w->configure( -highlightbackground => "#d9d9d9",
                   -background          => "#c3c3c3",
               qw/ -borderwidth         1       
                   -drawbranch          1
                   -height              10
                   -indicator           1
                   -indent              20
                   -itemtype            imagetext 
                   -padx                3
                   -pady                0
                   -relief              sunken
                   -takefocus           1
                   -wideselection       0
                   -width               20

                   -selectmode          single/ );

}

sub autosetmode {
    my( $w ) = @_;
    $w->SetModes();
}

sub close {
    my( $w, $ent ) = @_;

    my $mode = $w->GetMode( $ent );
    $w->Activate( $ent, $mode ) if( $mode eq "close" );
}

sub open {
    my( $w, $ent ) = @_;

    my $mode = $w->GetMode( $ent );
    $w->Activate( $ent, $mode ) if( $mode eq "open" );
}

sub getmode {
    my( $w, $ent ) = @_;
    return( $w->GetMode( $ent ) );
}

sub setmode {
    my( $w, $ent, $mode ) = @_;
    $w->SetMode( $ent, $mode );
}

sub SetModes {
    my( $w, $ent ) = @_;
    
    my @children;
    if( defined $ent ) {
        @children = $w->infoChildren( $ent );
    } else {
        @children = $w->infoChildren();
    }
 
    my $mode = "none";
    if( @children ) {
        $mode = "close";
        foreach my $c (@children) {
            $mode = "open" if $w->infoHidden( $c );
            $w->SetModes( $c );
	}
    }
    
    $w->SUPER::SetMode( $ent, $mode ) if defined $ent;
}

1;

__END__

#  Copyright (c) 1996, Expert Interface Technologies
#  See the file "license.terms" for information on usage and redistribution
#  of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#  
#  The file man.macros and some of the macros used by this file are
#  copyrighted: (c) 1990 The Regents of the University of California.
#               (c) 1994-1995 Sun Microsystems, Inc.
#  The license terms of the Tcl/Tk distrobution are in the file
#  license.tcl.

=head1 NAME

Tk::Tree - Create and manipulate Tree widgets


=head1 SYNOPSIS

    use Tk::Tree;

    $tree = $parent->Tree(?options?);


=head1 SUPER-CLASS

The B<Tree> class is derived from the scrolled B<HList>
class and inherits all the commands, options and subwidgets of its
super-class.


=head1 STANDARD OPTIONS

B<Tree> supports all the standard options of a frame widget.
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

The B<Tree> method creates a new window 
and makes it into a Tree widget and return a reference to it.  Additional
options, described above, may be specified on the command line or in
the option database to configure aspects of the Tree widget such as its
cursor and relief.
The Tree widget can be used to display hierachical data in a tree
form. The user can adjust the view of the tree by opening or closing
parts of the tree.
To display a static tree structure, you can add the entries into the
B<hlist> subwidget and hide any entries as desired. Then you can
call the B<autosetmode> method. This will set up the Tree widget so
that it handles all the I<open> and I<close> events
automatically. (Please see the demonstration program
F<examples/perl-tree>).
The above method is not applicable if you want to maintain a dynamic
tree structure, i.e, you do not know all the entries in the tree and
you need to add or delete entries subsequently. To do this, you should
first create the entries in the B<hlist> subwidget. Then, use the
setmode method to indicate the entries that can be opened or closed,
and use the B<-opencmd> and B<-closecmd> options to handle
the opening and closing events. (Please see the demonstration program
F<examples/perl-dyntree>).


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


Open the entry givaen by I<entryPath> if its I<mode> is B<open>.


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


=back 


=head1 BINDINGS

The basic mouse and keyboard bindings of the Tree widget are the same
as the bindings of the HList widget.
In addition, the entries can be opened or closed under the following
conditions:


=over 4


=item [1]

If the I<mode> of the entry is B<open>, it can be opened by clicking
on its (+) indicator or double-clicking on the entry.


=item [2]

If the I<mode> of the entry is B<close>, it can be closed by clicking
on its (-) indicator or double-clicking on the entry.


=back 


=head1 SEE ALSO

Tk::HList, Tix(n)

=head1 AUTHOR

Perl/TK version by Chris Dean <ctdean@cogit.com>.  Original Tcl/Tix
version by Ioi Kim Lam.

=head1 ACKNOWLEDGEMENTS

Thanks to Achim Bohnet <ach@mpe.mpg.de> for all his help.

=cut
