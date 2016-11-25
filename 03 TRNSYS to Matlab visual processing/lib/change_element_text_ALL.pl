# SCRIPT: SVG Parser
# M. Jones 09 Oct 24 - Created file
# M. Jones 09 Oct 25 - hacked together a solution
#!/usr/local/bin/perl -w

# Inputs: 
# 1 - the SVG file to modify
# 2 - the XPath Statement 
# 3 - What to change the text into!

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

my $ChangeFile = $ARGV[0];

my $SVGfile = $ARGV[1];

#my $XPathString = $ARGV[1];

#$XPathString = "//" . $XPathString; # This is a hack, the // is not passed by DOS commands line argument!

#my $newText = $ARGV[2];


open (ChangeFileFH, $ChangeFile);
# Load XML tree
my $entireTree = XML::XPath->new(filename => $SVGfile);

my $line;
my $XPathString;
my $newText;
while ($line = <ChangeFileFH>) {
   #print $line;
   my @splitLine = split(' \|\| ', $line); # Need the \| to escape the |!
   $XPathString = @splitLine[0];
   
   $newText = @splitLine[1];
	#print "$XPathString \n";
	#print "$newText \n";
	
	# Find / replace inside the tree based on XPath
	my $foundPath = $entireTree->exists($XPathString); # Is the XPath there? 
	
	if ($foundPath != 0) {
			# Update the current node
		$entireTree->setNodeText($XPathString, $newText);
	}
	else {
		#print "Couldn't find $XPathString";
	}
}
close(ChangeFileFH);

open(FHout, "> $SVGfile") or die;

# Find all 
my $EntireNodeList = $entireTree->find('/'); 
foreach my $node ($EntireNodeList->get_nodelist) {
	print FHout XML::XPath::XMLParser::as_string($node); # Print all!
	#print XML::XPath::XMLParser::as_string($node); # Print all!
}
close FHout;

