#!/usr/bin/perl
open(F,"testdata.txt") || die $!;
@lines = <F>;
close F;
chomp @lines;
#print @lines;
my @records;
@header = split /,/, @lines[0];
map {s/^\s+//;} @header;
for (my $r=1; $r<$#lines;$r++) {
    @data = split /,/, @lines[$r];
    map {
        s/"(.*)"/$1/;
        s/^[\s+]?(.*)[\s+]?$/$1/;
        s/\\r\\n//;
        s/\\n//;
    } @data;
    my $rec={};
    for ( my $obj=0; $obj<=$#header;$obj++) {
      $rec->{$header[$obj]} = $data[$obj];
    }
    push @records, $rec;
}
my @formattedRecords;
foreach my $rec (@records) {
    my $obj = "{";
    foreach my $k (keys $rec) {
        $obj.= "\"".$k."\":\"".$rec->{$k}."\",";
    }
    $obj=~ s/,$//;
    $obj.="}\n";
    push @formattedRecords, $obj;
}
print "{\n  \"payload\":[";
print join (",", @formattedRecords);
print "  ]\n}\n";
