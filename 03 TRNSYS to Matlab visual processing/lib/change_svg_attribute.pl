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

#my $SVGfile = $ARGV[0];
my $SVGfile = "Y:\\08 Analysis\\SVG Analysis\\WaterSide.svg";

#my $XPathString = $ARGV[1];

#$XPathString = "//" . $XPathString; # This is a hack, the // is not passed by DOS commands line argument!

#my $newText = $ARGV[2];

##########################################
# Open file and parse

# Load XML tree
my $entireTree = XML::XPath->new(filename => $SVGfile);
# Find / replace inside the tree based on XPath

#my $XPathString = "\svg"; 

#print $entireTree->getNodeType();

#$entireTree->setNodeText($XPathString, $newText);

#my $foundPath = $entireTree->exists($XPathString);

# my $entireNodeList = $entireTree->find('/'); # find all 
# foreach my $node ($entireNodeList->get_nodelist) {
	# print XML::XPath::XMLParser::as_string($node), " \n\n"; # Print all!
# }

#$entireTree->setNodeText(\*\@, $newText);

my $xPathSearch =  "//text[\@style]";
my $fontElementsList = $entireTree->find($xPathSearch); # find all 
foreach my $node ($fontElementsList->get_nodelist) {
	print XML::XPath::XMLParser::as_string($node), " \n\n"; # Print all!
}

print "YXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n\n";
print "YXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n\n";
print "YXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n\n";
print "YXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n\n";
print "YXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n\n";
print "YXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n\n";

my $newAttribText = "font-size:10px;font-style:normal;font-variant:normal;font-weight:normal;font-stretch:normal;text-align:start;line-height:125%;writing-mode:lr-tb;text-anchor:start;fill:#000000;fill-opacity:1;stroke:none;display:inline;enable-background:new;font-family:Arial;-inkscape-font-specification:Arial";

$entireTree->setNodeText($xPathSearch, $newAttribText);

my $entireNodeList = $entireTree->find('/'); # find all 
foreach my $node ($entireNodeList->get_nodelist) {
	print XML::XPath::XMLParser::as_string($node), " \n\n"; # Print all!
}

# # if ($foundPath != 0) {
	# $entireTree->setNodeText($XPathString, $newText);
	# # print "found $XPathString";
# # }
# # else {
	# # print "Couldn't find $XPathString";
# # }


# # rename($newTempFile, $SVGfile) or die;

# # unlink $newTempFile;