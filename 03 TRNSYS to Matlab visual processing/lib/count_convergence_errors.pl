# SCRIPT:

use strict;
use English;
#use XML::XPath;
#use XML::XPath::XMLParser;

package main;


my $listFile = $ARGV[0];
my $convergenceCnt = 0;
#D:\L SZDLC TRN\HVAC\Main.log

open FH, $ARGV[0];

while (my $line = <FH>) { 
	if 
}