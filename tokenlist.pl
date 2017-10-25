use strict;
use warnings;

my $filename = $ARGV[0];
open(LUA,"<",$filename);
my $read = <LUA>;
my $file = "";
while(defined($read)){
  $file = $file.$read;
  $read = <LUA>;
}
close(LUA);
print("read ".length($file)." chars\n");

#remove strings:
my @strings = ($file =~ /(".*?")/gs);
foreach my $str(@strings){
  $file =~ s/\Q$str\E//;
}

$file =~ s/--\[\[.*?\]\]//gs; #remove block comments
$file =~ s/--.*//g; #remove single line comments

#extract all variable names
my($tokensrc) = ($file =~ /.*__lua__\n(.*)\n__gfx__.*/s);

my @tokens = ($tokensrc =~ /[a-z][a-z\d_]*/g);
my %tmap;
foreach my $t(@tokens){
	$tmap{$t}=1;
}
@tokens = sort keys %tmap;
@tokens = sort {length($b)<=>length($a)} @tokens;
my $tokenmap="";
my $cmatch="";

my @lines=split("\n",$file);
print("Found ".scalar @tokens." tokens over ".scalar @lines." lines\n");
foreach my $token(@tokens){
	$tokenmap=$tokenmap."$token ";
	my $first=1;
	for(my $i=0;$i<(scalar @lines);$i++){
		my $line=$lines[$i];
		if($line =~ /(?<![a-z\d_])$token(?![a-z\d_])/){
			if($first==1){
				$first=0;
			}else{
				$tokenmap=$tokenmap.",";
			}
			$tokenmap=$tokenmap."$i";
		}
	}
	$tokenmap=$tokenmap."\n";
}

$tokenmap=join("\n",sort(split("\n",$tokenmap)));
open(MAP,">","$filename tokens.txt");
print(MAP $tokenmap);
close(MAP);