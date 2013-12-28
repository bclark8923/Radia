my $pi = 4*atan2(1,1);
my $radius = 130;
my $clockwidth = 25;
my $prevX = $radius;
my $prevY = 0;
my $curY = 0;
my $curX = 0;
my $centerX = 240;
my $centerY = 160; 

for ($count = 0; $count < 360; $count+= 30) {
    
    
	my $outsideX1 = cos(($count+3) * $pi / 180) * $radius + $centerX;
	my $outsideY1 = sin(($count+3) * $pi / 180) * $radius + $centerY;
	my $outsideX2 = cos(($count-3) * $pi / 180) * $radius + $centerX;
	my $outsideY2 = sin(($count-3) * $pi / 180) * $radius + $centerY;
    
	my $insideX1 = cos(($count+3) * $pi / 180) * ($radius-$clockwidth) + $centerX;
	my $insideY1 = sin(($count+3) * $pi / 180) * ($radius-$clockwidth) + $centerY;
	my $insideX2 = cos(($count-3) * $pi / 180) * ($radius-$clockwidth) + $centerX;
	my $insideY2 = sin(($count-3) * $pi / 180) * ($radius-$clockwidth) + $centerY;
    
 	print "<wall x1='$outsideX1' y1='$outsideY1' x2='$outsideX2' y2='$outsideY2' />\n";
 	print "<wall x1='$insideX1' y1='$insideY1' x2='$insideX2' y2='$insideY2' />\n";
 	print "<wall x1='$insideX1' y1='$insideY1' x2='$outsideX1' y2='$outsideY1' />\n";
 	print "<wall x1='$insideX2' y1='$insideY2' x2='$outsideX2' y2='$outsideY2' />\n";
}