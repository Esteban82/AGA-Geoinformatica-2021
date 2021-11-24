ECHO off
cls


REM
	SET CPT=Aspect-Slope_Brewer_HSV.cpt
	SET W=0.5p

gmt begin Aspect-Slope_Brewer_HSV png

	gmt set MAP_GRID_PEN_PRIMARY 0.5p

REM	Dibuja la superficie
	gmt basemap -JP5c+a -R0/360/0/5 -Byg1
rem	gmt basemap -JP4c+a -R0/360/0/4 -Byg1


REM	Nivel de 5 cm
	SET R=5c
	echo 0 0 20 | gmt plot -Sc%R% -C%CPT% -W%W%

REM	Nivel de 4 cm
	SET R=4c
	echo 0 0 -22.5 22.5  | gmt plot -SW%R% -C%CPT% -G+z -W%W% -Z21
	echo 0 0 22.5 67.5   | gmt plot -SW%R% -C%CPT% -G+z -W%W% -Z22
	echo 0 0 67.5 112.5  | gmt plot -SW%R% -C%CPT% -G+z -W%W% -Z23
	echo 0 0 112.5 157.5 | gmt plot -SW%R% -C%CPT% -G+z -W%W% -Z24
	echo 0 0 157.5 202.5 | gmt plot -SW%R% -C%CPT% -G+z -W%W% -Z25
	echo 0 0 202.5 247.5 | gmt plot -SW%R% -C%CPT% -G+z -W%W% -Z26
	echo 0 0 247.5 292.5 | gmt plot -SW%R% -C%CPT% -G+z -W%W% -Z27
	echo 0 0 292.5 337.5 | gmt plot -SW%R% -C%CPT% -G+z -W%W% -Z28

REM	Nivel de 3 cm
	SET R=3c
	echo 0 0 -22.5 22.5  | gmt plot -SW%R% -C%CPT% -G+z -W%W% -Z31
	echo 0 0 22.5 67.5   | gmt plot -SW%R% -C%CPT% -G+z -W%W% -Z32
	echo 0 0 67.5 112.5  | gmt plot -SW%R% -C%CPT% -G+z -W%W% -Z33
	echo 0 0 112.5 157.5 | gmt plot -SW%R% -C%CPT% -G+z -W%W% -Z34
	echo 0 0 157.5 202.5 | gmt plot -SW%R% -C%CPT% -G+z -W%W% -Z35
	echo 0 0 202.5 247.5 | gmt plot -SW%R% -C%CPT% -G+z -W%W% -Z36
	echo 0 0 247.5 292.5 | gmt plot -SW%R% -C%CPT% -G+z -W%W% -Z37
	echo 0 0 292.5 337.5 | gmt plot -SW%R% -C%CPT% -G+z -W%W% -Z38

REM	Nivel de 4 cm
	SET R=2c

	echo 0 0 -22.5 22.5  | gmt plot -SW%R% -C%CPT% -G+z -W%W% -Z41
	echo 0 0 22.5 67.5   | gmt plot -SW%R% -C%CPT% -G+z -W%W% -Z42
	echo 0 0 67.5 112.5  | gmt plot -SW%R% -C%CPT% -G+z -W%W% -Z43
	echo 0 0 112.5 157.5 | gmt plot -SW%R% -C%CPT% -G+z -W%W% -Z44
	echo 0 0 157.5 202.5 | gmt plot -SW%R% -C%CPT% -G+z -W%W% -Z45
	echo 0 0 202.5 247.5 | gmt plot -SW%R% -C%CPT% -G+z -W%W% -Z46
	echo 0 0 247.5 292.5 | gmt plot -SW%R% -C%CPT% -G+z -W%W% -Z47
	echo 0 0 292.5 337.5 | gmt plot -SW%R% -C%CPT% -G+z -W%W% -Z48


	gmt basemap -Bxa45
	gmt basemap -Bxg45 -JP5c+a+t22.5

	gmt end show
rem	pause
