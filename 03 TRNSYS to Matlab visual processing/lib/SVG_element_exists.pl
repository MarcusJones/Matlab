# SCRIPT: SVG Parser
# M. Jones 09 Oct 24 - Created file
# M. Jones 09 Oct 25 - hacked together a solution
#!/usr/local/bin/perl -w

# Inputs: 
# 1 - the SVG file
# 2 - the XPath Statement 

# Outputs:
# True or false!

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

##########################################
# Open file and parse

# Load XML tree
my $entireTree = XML::XPath->new(filename => $SVGfile);
# Find / replace inside the tree based on XPath

my $foundPath = $entireTree->exists($XPathString);

if ($foundPath != 0) {
	print "1";
}
else {
	print "0";
}