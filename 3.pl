my $count=0;

#print $shtml;
while(-e $count."\.shtml" ){
    eval( open(my $fh, "<", $count."\.shtml") );
    #eval( open(my $fh, "<", "170.shtml") );

    my $shtml;
    $shtml .= $_ for <$fh>;

    close $fh;


    print "Replace $count page file\n";
    eval( open(my $fh, ">", $count."\.shtml") );
    #eval( open(my $fh, ">", "000\.shtml") );

    $shtml =~ s/(\<img)[^\>]*?original=\"(.*?[jpggif])\"[^\>]*?(\>)/\1 src=\"\2\"\3/g;
    print $fh $shtml;
    close $fh;
    $count++;
}

#print $_."\n" for  $shtml =~ /\"\s*http[A-Za-z0-9\/\.\:\-\_\?\=]+\"/g;