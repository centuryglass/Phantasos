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
$file =~ s/--\[\[.*?\]\]//gs; #remove block comments
$file =~ s/--.*//g; #remove single line comments

my($tokensrc) = ($file =~ /.*__lua__\n(.*)\n__gfx__.*/s);
$tokensrc =~ s/".*?"/ /gs; #temporarily remove strings
#extract all variable names
my @tokens = ($tokensrc =~ /[a-z][a-z\d_]*/g);
my %tmap;

#words on this list will not be touched.
#todo: add all the missing reserved words
my @reserved = (
"_draw",
"_init",
"_update",
"abs",
"add",
"all",
"and",
"assert",
"atan2",
"band",
"bnot",
"bor",
"break",
"btn",
"btnp",
"bxor",
"camera",
"cartdata",
"circ",
"circfill",
"clip",
"cls",
"cocreate",
"color",
"coresume",
"cos",
"costatus",
"cstore",
"cursor",
"del",
"dget",
"do",
"draw",
"dset",
"else",
"elseif",
"end",
"eq",
"false",
"fget",
"flip",
"flr",
"for",
"foreach",
"fset",
"function",
"if",
"in",
"len",
"line",
"local",
"lt",
"map",
"max",
"memcpy",
"memset",
"menuitem",
"mget",
"min",
"mset",
"music",
"mul",
"nil",
"not",
"or",
"pairs",
"pal",
"palt",
"peek",
"pget",
"poke",
"print",
"printh",
"pset",
"rect"
"rectfill",
"repeat",
"return",
"reload",
"rnd",
"self",
"setmetatable",
"sfx",
"sget",
"shl",
"shr",
"sin",
"spr",
"sqrt",
"srand",
"sset",
"sspr",
"stat",
"stop",
"sub",
"then",
"time",
"trace",
"true",
"type",
"unm",
"until",
"while",
"yield"
);


foreach my $t (@tokens){
	#variable names that are already less than three characters are not changed.
	#instead, add them to the reserved list to prevent conflicts
	#hexadecimal numbers are also filtered out on this step
	if(length($t)>2 and !($t =~ /x[abcdef\d]+/)){
		$tmap{"$t"}=1;
	}
	else{
		push(@reserved,$t);
	}
}
foreach my $rval(@reserved){
  delete $tmap{$rval};
}

#Save strings to  list, and mark their places in the file
my @strings = ($file =~ /(".*?")/gs);
my $si = 0;
foreach my $str(@strings){
  $file =~ s/\Q$str\E/"<STRING$si>"/;
  $si += 1;
}

#pick replacement variable names sequentially
my $tokenInd = 0;
sub indexToAlpha{
  my $base10 = $tokenInd+1;
  my $str = "";
  while($base10 > 0){
    $str = $str.chr($base10%26+ord('a'));
    $base10 -= $base10%26;
    $base10 /= 26;
  }
  return $str;
}

my $tokenswaps="";
while(scalar (keys %tmap) > 0){
  foreach my $token(keys %tmap){
#tokens referenced in strings won't be replaced
    foreach my $str(@strings){
      if($str =~ /\Q$token\E/){
        delete $tmap{$token};
        #print "found $token in string, removing\n";
        last;
      }
    }
    if(!exists $tmap{$token}){
      next;
    }
    my $match = 0;
    my $replacement = indexToAlpha();
    my $found = 1;
    while($found){
      $found = 0;
      foreach my $r(@reserved){
        if($replacement eq $r){
          print("$replacement is reserved, skipping\n");
          $tokenInd++;
          $replacement = indexToAlpha();
          $found = 1;
          last;
        }
      }
    }
    while(exists $tmap{$replacement}){
      $tokenInd++;
      $replacement = indexToAlpha();
    }
    $tokenswaps=$tokenswaps."$token -> $replacement \n";
    $file =~ s/(?<=\W)$token(?=\W)/$replacement/g;
    delete $tmap{$token};
    $tokenInd++;
    #print("replaced $token with $replacement, ".scalar (keys %tmap)." remaining\n");
  }
}


my($header,$code,$data) = ($file =~ /(.*__lua__\n)(.*)(\n__gfx__.*)/s);
#$code =~ s/\h+/ /g; #replace excess whitespace with single spaces
#remove unnecessary newlines
my @lines = split("\n",$code);
$code = "";
my $no_whitespace="[\\[\\]\\(\\)\\{\\},*+=%-]";
foreach my $line(@lines){
#single line if statements and += type combined operators
#tend to break if they don't have their own lines, but every
#other newline is unnecessary
  if($line =~ /if\s*\(|\+=|-=|\*=|\/=|%=/){
    $code=$code."\n$line\n";
  }
  else{
    $code = $code.$line." ";
  }
}
$code =~ s/\n+/\n/g;

#replace excess whitespace with single spaces
$code =~ s/\h+/ /g;

#remove unneeded whitespace around special characters
$code =~ s/(?<=[!-\/[-^`:-\@{-~])\h+//g;
$code =~ s/\h+(?=[!-\/[-^`:-\@{-~])//g;
#$code =~ s/(?<=[\[\](){}.*+=%,"'^-])\h+//g;
#$code =~ s/\h+(?=[\[\](){}.*+=%,"'^-])//g;

#remove unnecessary whitespace at the start and end of lines
$code =~ s/(?<=\n)\s+//gs;
$code =~ s/\h+(?=$)//g;

$file=$header.$code.$data;

#put strings back
$si = 0;

foreach my $str(@strings){
  $file =~ s/"<STRING$si>"/$str/;
  $si += 1;
}


$file =~ s/^\s+//g;
$filename =~ s/\..*$//;
open(LUA,">","$filename"."_min.p8");
print(LUA $file);
close(LUA);
open(MAP,">","$filename tokens.txt");
print(MAP $tokenswaps);
close(MAP);
