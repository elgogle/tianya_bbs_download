my $count=0;

#print $shtml;
while(-e $count."\.shtml" ){
    eval( open(my $fh, "<", $count."\.shtml") );

    my $shtml;
    $shtml .= $_ for <$fh>;
    close $fh;

    print "Replace $count page file\n";
    eval( open(my $fh, ">", $count."\.shtml") );

    $shtml =~ s/\"\s*http[A-Za-z0-9\/\.\:\-\_\?\=]+\"/\"\"/g;
    print $fh $shtml;
    close $fh;
    $count++;
}

#print $_."\n" for  $shtml =~ /\"\s*http[A-Za-z0-9\/\.\:\-\_\?\=]+\"/g;