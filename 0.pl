use LWP::UserAgent;
use LWP::Simple;
require HTTP::Request;
my $ua = LWP::UserAgent->new;
$ua->agent("Schmozilla/v9.14 Platinum");


my $count=0;
my @imgUrlQueue;


my $firstLink = "http://www.tianya.cn/publicforum/content/no04/1/1789902.shtml";
my $baseUrl = "http://www.tianya.cn/publicforum/content/no04/1/";
my @nextUrlQueue;

my $nextUrlRegular="([0-9]+\.shtml)\">(下一页)";

my $imgUrlRegular = 'http\:\/{2}[a-zA-Z0-9\/\.]+\/{1}[a-zA-Z0-9_]+\.[jpggif]{3}';
my $imgUrlReplaceRegular = '(http\:\/{2}[a-zA-Z0-9\/\.]+\/{1})([a-zA-Z0-9_]+\.[jpggif]{3})';

    push @nextUrlQueue, $firstLink;

    while($#nextUrlQueue >= 0){
        my $tempNextUrl = pop @nextUrlQueue;
        print "fetch : ".$count."page\n";

        my $response = $ua->get( $tempNextUrl );
        if ($response->is_error( )){
            print "get page: ".$tempNextUrl." failed!\n";
        }else{
            print "get page: ".$tempNextUrl." successed!\n";

            fetchNextUrl($response->content, $nextUrlRegular);

            @imgUrlQueue =fetchImageUrlAndSaveHtml($response->content, $imgUrlRegular, $imgUrlReplaceRegular);
            mkdir($count);

            saveImage(@imgUrlQueue);
            $count += 1;
        }
    }


sub saveImage{
    my( @url ) = @_;
    print "img count: ".$#url."\n";

    while($#url>=0){

        my $tempUrl = pop @url;
        print "get img: ".$tempUrl."\n";

        if( $tempUrl !~ /default_avatar\.jpg/ or $tempUrl !~ /tianya_content_original\.gif/ ){
            system "wget --referer=http://www.tianya.cn/publicforum/content/no04/1/1748293.shtml --cookies=on --load-cookies=cookie.txt --keep-session-cookies --save-cookies=cookie.txt -P $count --tries=3 --timeout=10 -nc $tempUrl";
        }
    }
}

#获取下一页URL
sub fetchNextUrl{
    my( $html, $nextUrl ) = @_;
    if( $html =~ /$nextUrl/ ){
        print "next url: ".$1."\n";
        push @nextUrlQueue, $baseUrl.$1;
    }
}


#获取当前页面所有图片链接并保存当前页面且修改图片链接
sub fetchImageUrlAndSaveHtml{
    ($html, $imgUrlRegular, $imgUrlReplaceRegular) = @_;
    my @url;
    #search img url
    @url = ( $html =~ /$imgUrlRegular/g );

    #replace url
    $html =~ s/$imgUrlReplaceRegular/$count\/$2/g;

    open(my $hr, ">>", $count.".shtml") or die "can not open file: $!";
    print $hr $html;
    close $hr;

    return @url;
}

