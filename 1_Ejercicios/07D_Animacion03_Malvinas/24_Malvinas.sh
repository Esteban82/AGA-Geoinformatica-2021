#!/usr/bin/env bash
clear

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=Malvinas2
	echo $title

#	-----------------------------------------------------------------------------------------------------------
# 1. Create files needed in the loop
cat << 'EOF' > pre.sh
	DEM=@earth_relief_03s
	REGION=-61.5/-57.5/-52.5/-51

gmt begin
	gmt math -T180/540/1 T 30 SUB = angles.txt
	gmt makecpt -Cdem4 -T0/700 -H -M > a.cpt --COLOR_BACKGROUND=dodgerblue2
	gmt grdcut $DEM -R$REGION -Gdem.nc
	gmt grdclip dem.nc -Gabove.nc -Sb0/-1
gmt end
EOF
# 2. Set up the main frame script
cat << 'EOF' > main.sh
gmt begin
	gmt grdgradient above.nc -Nt1 -Gintens.nc -A-${MOVIE_COL1}
	gmt grdview above.nc -Rabove.nc -Ca.cpt -Qc${MOVIE_DPU} -Iintens.nc -JM19c -JZ0.4c -p-${MOVIE_COL0}/35+v4.5c/1.7c -X7.6c -Y5c
	gmt basemap -Bf -Tdn0.06/0.8+w1.75c+f+l,,,N -p
gmt end
EOF
# 3. Run the movie
gmt movie main.sh -Chd -N$title -Tangles.txt -Sbpre.sh -D24 -Vi -Pb -M27,png  -Zs -Gblack -Fmp4
