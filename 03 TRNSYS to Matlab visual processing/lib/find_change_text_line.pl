# SCRIPT: SVG Parser
# M. Jones Aug 2010

# Inputs: 
# 1 - The text file to modify
# 2 - Search critera (regexp)
# 3 - What to change the line into!

#Outputs:
# A temporary file which is deleted!
# A modified SVG!

use strict;

my $textFile = $ARGV[0];

my $searchString = $ARGV[1];

my $newLine = $ARGV[2];

# Open
open FILE, $textFile or die $!;

#print $textFile;
#print $searchString;
#print $newLine;

#Open the file and read data
#Die with grace if it fails
open (FILE, "<$textFile") or die "Can't open $textFile: $!\n";
my @lines = <FILE>;
close FILE;

#Open same file for writing, reusing STDOUT
open (FILE, ">$textFile") or die "Can't open $textFile: $!\n";

#Walk through lines, putting into $_, and substitute 2nd away
for ( @lines ) {
	#print "In";
	#print $_; 

		if ($_ =~ m/$searchString/) {
			#print "HI";
			#$_ =~ s/$_/TIME = 20/;
			#$_ =~ "TIME = 20\n";
			print FILE $newLine, "\n";
			
		}
		else {
			print FILE $_;
		}

	
}

	
#	if($_ =~ m/$searchString/)  {
		#print "$_\n";
		
		#my $newLine =~ s/$_/TIME = 10/;
		#}
#Finish up
close STDOUT;





##print "HI";
#
## Loop
#while (<FILE>) { 
#	#print "In";
#	#print $_; 
#	
#	if($_ =~ m/$searchString/)  {
#		#print "$_\n";
#		
#		#my $newLine =~ s/$_/TIME = 10/;
#		
#		$_ =~ s/$_/Al Gore/;
#		
#		print $_;
#	}
#}
#
#close FILE;
#
##perl -pi -e 's/ReplaceMe/REPLACED/ if /MatchText/' filename