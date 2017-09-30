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
my $strings="";
my @strings = ($file =~ /(".*?")/gs);
foreach my $str(@strings){
  if(length($str)>9){
    $strings=$strings."\n".$str;
  }
}
$filename =~ s/\..*$//;
open(LUA,">","$filename"."_str.p8");
print(LUA $strings);
close(LUA);
