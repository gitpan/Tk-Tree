# Tree -- TixTree widget
#
# Derived from Tree.tcl in Tix 4.1
#
# Chris Dean <ctdean@cogit.com> 

package Tk::Tree;

use strict;
use vars qw( @ISA $VERSION );
@ISA = qw( Tk::VTree );

$VERSION = "0.02";

use Tk;
use Tk::VTree;

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
