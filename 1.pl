
my $count=0;

my $nextUrlRegular="(http\:\/{2}[a-zA-Z0-9\/\.]+\/{1})([0-9]+\.shtml)(\">обр╩рЁ)";

while( -e "$count.shtml" ){
    print "modify file: ".$count.".shtml\n";
    my $countC = 109+length($count);
    my $reg = "(tianya_content_original\.gif)(.{$countC}\/)([a-zA-Z0-9_]+.[jpggif]{3})";
    open(my $fh, "<", "$count.shtml") || die "can not open file: $!";

    my @content = <$fh>;
    close $fh;

    my $shtml;
    foreach(@content){
        $shtml .= $_;
    }

    $shtml =~ s/$reg/$3$2$3/gi;
    my $next = $count+1;
    $shtml =~ s/$nextUrlRegular/$next\.shtml$3/g;
    open(my $fh, ">", "$count.shtml") || die "can not open file: $!";
    print $fh $shtml;
    close $fh;
    $count++;
}



