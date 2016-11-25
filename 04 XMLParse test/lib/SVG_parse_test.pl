# SCRIPT: SVG Parser
# M. Jones 09 Oct 24 - Created file

#!/usr/local/bin/perl -w
# http://www.perl.com/pub/a/1998/12/cooper-01.html

use strict;
use English;
use XML::XPath;
use XML::XPath::XMLParser;
use File::Basename;

use constant PI    => 4 * atan2(1, 1);

package main;

##########################################
# Variables
my $file = 'D:\L Scripts\03L Perl\04 Perl\06 Perl SVG Parsing\EmptyTemplate2.svg';              # the file to parse
my $searchTag = "tspan";
my $infile;			# Input file
$infile = $ARGV[0];	# Assign to argument
my $base; my $dir; my $ext;
($base, $dir, $ext) = fileparse($infile,'\..*');
my $newFile = 'd:\new.txt';
open(FH, "> $newFile");

##########################################
# Open file and parse    

my $xp = XML::XPath->new(filename => $file);
 
#$xp->getNodeText('/tspan')
#print $xp->findnodes('//tspan');
#print $xp->getNodeText('//tspan');

#$xp->setNodeText('//tspan', 'NEW TEXT FOR ALL');

# Smack the XML document with an XPath statement and store them into a nodeset!
my $entireNodeset2 = $xp->find('/'); # Root node, entire text!


my $layerNodeset = $xp->find('//g'); # find the layer nodeset
my $MOA_templateNodeset = $xp->find('//text[@id=\'MOA_template\']'); # find the Moist Air text template node
my $MOA_templateNode = $MOA_templateNodeset->get_node(1);
my $FLD_templateNodeset = $xp->find('//text[@id=\'FLD_template\']'); # find the Fluid template node
my $FLD_templateNode = $FLD_templateNodeset->get_node(1);

#print XML::XPath::XMLParser::as_string($MOA_templateNode), "\n";
#print XML::XPath::XMLParser::as_string($FLD_templateNode); "\n\n";

#$entireNodeset -> append($MOA_templateNodeset);

# Now loop through all of the returned nodes (XML::XPath::Node::Element)
#foreach my $node ($textTemplateNodeset->get_nodelist) {
	#print XML::XPath::XMLParser::as_string($node)
#}

my $entireNode = $entireNodeset2->get_node(1);
my $entireChildren = $entireNode->childNodes();
#print $entireChildren -> size();
print XML::XPath::XMLParser::as_string($entireNode), " \n************\n"; # Print all!

#Write the new XML structure

#foreach my $node ($entireNodeset2->get_nodelist) {
#	print XML::XPath::XMLParser::as_string($node), " \n************\n"; # Print all!
#}

#$nodeset-



close FH;



# ############################
# use XML::XPath;

# my $file = 'customers.xml';
# my $xp = XML::XPath->new(filename=>$file);

# # An XML::XPath nodeset is an object which contains the result of
# # smacking an XML document with an XPath expression; we'll do just
# # this, and then query the nodeset to see what we get.
# my $nodeset = $xp->find('//zip');

# my @zipcodes;                   # Where we'll put our results
# if (my @nodelist = $nodeset->get_nodelist) {
  # # We found some zip elements! Each node is an object of the class
  # # XML::XPath::Node::Element, so I'll use that class's 'string_value'
  # # method to extract its pertinent text, and throw the result for all
  # # the nodes into our array.
  # @zipcodes = map($_->string_value, @nodelist);

  # # Now sort and prepare for output
  # @zipcodes = sort(@zipcodes);
  # local $" = "\n";
  # print "I found these zipcodes:\n@zipcodes\n";
# } else {
  # print "The file $file didn't have any 'zip' elements in it!\n";
# }

# To the best of my knowledge XML::XPath doesn't have any real save support. I suppose you might try something like

# Code:

# XML::XPath::XMLParser::as_string($xp->find('/'))

# To write the XML document to a string, and then write the write the returned string to a file.

# But all in all I think you would be better off switching to the XML::GDOME module which has more official save support through the XML::GDOME::Document::toString(mode) function.

# http://search.cpan.org/~tjmather/XML.../XML/GDOME.pod