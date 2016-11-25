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

my $SVGfile = $ARGV[0];

my $XPathString = $ARGV[1];

$XPathString = "//" . $XPathString; # This is a hack, the // is not passed by DOS commands line argument!

my $newText = $ARGV[2];

##########################################
# Open file and parse

# Load XML tree
my $entireTree = XML::XPath->new(filename => $SVGfile);
# Find / replace inside the tree based on XPath

my $foundPath = $entireTree->exists($XPathString);

if ($foundPath != 0) {
	$entireTree->setNodeText($XPathString, $newText);

	# Delete the original SVG and replace
	#unlink $SVGfile;

	# Write the changes to a temporary file
	#my $newTempFile = $SVGfile . ".temp";
	open(FHout, "> $SVGfile") or die;

	# Find all 
	my $EntireNodeList = $entireTree->find('/'); 
	foreach my $node ($EntireNodeList->get_nodelist) {
		print FHout XML::XPath::XMLParser::as_string($node); # Print all!
	}
	close FHout;
	#print "Changed value of \'$XPathString\' element to \'$newText\'";
}
else {
	#print "Couldn't find $XPathString";
}


#rename($newTempFile, $SVGfile) or die;

#unlink $newTempFile;