#! /usr/bin/perl
#http://www.hackforums.net/showthread.php?tid=4198805

print"\n";
print "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n" ;
print "                      	SPIDERSCAN SQL  v 1 \n" ;
print "                     	Coded By 4N0NYK1NG\n" ;
print "         INSTAGRAM: https://www.instagram.com/cybrr_warrior_official_/\n\n" ;
print "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n" ;
print "\n";


use LWP::UserAgent;
$ua = LWP::UserAgent->new;

print "\e[2J";
system(($^O eq 'MSWin32') ? 'cls' : 'clear');

my ($host, $method) = @ARGV ;

unless(($ARGV[1]) && (($method eq "s") || ($method eq "i"))) {
   print "Usage: perl $0 <host> <method>\n";
   print "\tMethod: s - spider\n";
   print "\t        i - possible injections\n\n";
   exit 1;
}

$ua->agent("$0/0.1 " . $ua->agent);
$target = $host;
$target =~ s/http:\/\///g;
$host = "http://".$host if ($host !~ /^http:/);

@excluir = (".exe", ".ace", ".zip", ".doc", ".pdf", ".txt");

@links = ();
@analizado = ();
@sql = ();

analizar($host);

for ($i = 0; $i <= $#links; $i++) {
   push(@analizado, $links[$i]);
   analizar($links[$i]);
}

$salir = 0;

while ($salir < 10) {
   $salir++;
   
   for ($i1 = 0; $i1 <= $#links; $i1++) {
      $analizar = 1;
      $valor = "";
      
      for ($j1 = 0; $j1 <= $#analizado; $j1++) {
     if ($analizado[$j1] eq $links[$i1]) {
        $analizar = 0;
     }
     else {
        $valor = $links[$i1];
     }
      }
      
      if ($analizar == 1) {
     push(@analizado, $valor);
     $salir = 0;
     print "Analyzing ... ".$valor."\n";
     analizar($valor);
      }
   }
}

print "\e[2J";
system(($^O eq 'MSWin32') ? 'cls' : 'clear');

if ($method eq "s") {
   print "PAGES FOUND:\n";

   for ($i = 0; $i <= $#links; $i++) {
      print $links[$i] . "\n";
   }
   
   print "\n";
}

if ($method eq "i") {
   print "POSSIBLE INJECTIONS:\n";

   for ($i = 0; $i <= $#sql; $i++) {
      print $sql[$i] . "\n";
   }
   
   print "\n";
}


sub analizar() {
   my $url = shift;

   @linkstmp = ();
   
   $req = HTTP::Request->new(GET => $url);
   $req->header('Accept' => 'text/html');
   
   $res = $ua->request($req);
   
   if ($res->is_success) { 
      $result = $res->content;
      $result =~ s/ //g;
      
      extraer($result);
   } 
#   else { print "Error: " . $res->status_line . "\n";}
}


sub extraer() {
   my $cad = shift;
   
   $x = 8;
   
   while ($x > 7) {
      $x = index(lc($cad), "<ahref=\"") + 8;

      if ($x > 7) {
     $aux = substr($cad, $x, length($cad) - $x);
     $y = index($aux, "\"");
      }
      
      if (($x > 7) && ($y > -1))
      {
     $link = substr($cad, $x, $y);
     $link = $host."/".$link if ($link !~ /^http/);
     
     $target2 = $target;
     $target2 !~ s/www.//g;

     if (($link !~ /#/) && (($link =~ /$target/) || ($link =~ /$target2/))) {
        $aux = $link;
        
        if (lc($link) =~ /javascript/) {
           $z1 = index($link, "'");

           if ($z1 > -1) {
          $aux = substr($link, $z1 + 1);
          $z2 = index($aux, "'");
          $aux = substr($aux, 0, $z2);
          $link = $aux;
           }
           else {
          $z1 = index($link, "\"");
          
          if ($z1 > -1) {
             $aux = substr($link, $z1 + 1);
             $z2 = index($aux, "\"");
             $aux = substr($aux, 0, $z2);
             $link = $aux;
          }
           }
        }

        if (($aux =~ /$target/) || ($aux =~ /$target2/)) {
           $excluido = 0;
           
           for ($z3 = 0; $z3 <= $#excluir; $z3++) {
          if ($aux =~ /$excluir[$z3]/) {
             $excluido = 1;
          }
           }
           
           if ($excluido == 0) {
          anadir($link);
           }
        }
     }
     
     $cad = substr($cad, $x + $y + 1);
      }
   }
}


sub anadir() {
   my $link = shift;
   my $isregistered = 0;
   
   $tmp = $link;
   $z = index($link, "?");
   
   if ($z > -1) {
      $tmp = substr($link, 0, $z);
   }
   
   for ($i = 0; $i <= $#links; $i++) {
      if ($links[$i] eq $tmp) {
     $isregistered = 1;
      }
   }
   
   if ($isregistered == 0) {
      push(@links, $tmp);
      
      if ($tmp !~ $link) {
     push(@sql, $link);
      }
   }