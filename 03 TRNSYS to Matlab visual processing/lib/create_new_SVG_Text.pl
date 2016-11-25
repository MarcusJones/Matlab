# SCRIPT: SVG Parser
# M. Jones 09 Oct 24 - Created file
# M. Jones 09 Oct 25 - hacked together a solution


# Works only on TEXT elements! (Grouped TSpan elements)
#!/usr/local/bin/perl -w

# Inputs: 
# $SVGfile - the SVG file to modify
# $searchIDText - what ID to search for within all "text" elements
# $newText  - what to replace the ID with (replace all occurances of string 2 with string 3)

#Outputs:
# A temporary file which is deleted!
# A modified SVG!

use strict;
use English;
use XML::XPath;
use XML::XPath::XMLParser;

package main;

##########################################
# Variables

my $SVGfile = $ARGV[0];

my $searchIDText = $ARGV[1];

my $newText = $ARGV[2];

##########################################
# Open file and parse

my $entireTree = XML::XPath->new(filename => $SVGfile);
my $entireNL = $entireTree->find('/');
my $entireNode = $entireNL->get_node(1); # Here it is!
my $XPathString = "//text[\@id=\'" .  $searchIDText . "\']";

my $foundNL = $entireTree->find($XPathString); # find the template node
my $foundNode = $foundNL->get_node(1); # Here it is!

#print XML::XPath::XMLParser::as_string($entireNode), "\n"; 
my $NewNodeText = XML::XPath::XMLParser::as_string($foundNode); 

#print $NewNodeText, "\n";

$NewNodeText =~ s/$searchIDText/$newText/gx; # Replace all instances of searchIDText!

#print $NewNodeText;

my $newTempFile = $SVGfile . ".temp";
open(FH, "+< $SVGfile");
open(FHout, "> $newTempFile") or die;

# Print until insertion point
while (<FH>){
#	print FHout$_ unless (($_ =~ m\ </g> \x ) || ($_ =~ m\ </svg> \x )) ; NO LONGER WORKS ?
	print FHout$_ unless (($_ =~ m\</svg>\x )) ; # Have to manually cause this at end!!!
	#if ($_ =~ m\ </g> \x )
	#print FHout $_ unless 
	
	#print FHout $_ unless ($_ =~ m\ </svg> \x ) ;
	
}
close FH;

# Add the newly copied node
print FHout $NewNodeText;

# End off the SVG XML (This is not very elegant!)
print  FHout"\n</g> </svg>";

close FH;

close FHout;

# Delete the original SVG, and rename the new to the old
unlink $SVGfile;
rename($newTempFile, $SVGfile) or die;
unlink $newTempFile;