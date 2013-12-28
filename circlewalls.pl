my $pi = 4*atan2(1,1);
my $radius = 20;
my $prevX = $radius;
my $prevY = 0;
my $curY = 0;
my $curX = 0;
my $centerX = 240;
my $centerY = 290; 

for ($count = 0; $count <= 360; $count+= 20) {
	$curX = cos($count * $pi / 180) * $radius;
	$curY = sin($count * $pi / 180) * $radius;
	$curX += $centerX;
	$curY += $centerY;
 	print "<wall x1='$prevX' y1='$prevY' x2='$curX' y2='$curY'  inactiveUntil='111' anchorX='240' anchorY='160' rotSpeed='120'/>\n";
 	$prevX = $curX;
 	$prevY = $curY;
}