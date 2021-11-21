#!/usr/bin/env bash
clear

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	RES=05m

#	Mosaicos de la NASA: BlackMarble (night) o BlueMarble (day)
	daytime=day
#	daytime=night

	title=37_Marble_Intes_Cut_${daytime}_$RES
	echo $title

	PROJ=M15c

#	BlueMarble
#	gmt grdimage -R -J -O -K >> %OUT% @earth_day_10m -Baf

#	Relief
#	gmt grdgradient @earth_relief_10m -Nt1.00 -A45 -G%SHADOW%
#	gmt grdimage -R -J -O -K >> %OUT% @earth_relief_10m -I%SHADOW% -Y7c -Baf

#	BUG
#	gmt grdimage -R -J -O -K >> %OUT% @earth_day_10m    -I%SHADOW% -Y7c -Baf

#	Region geografica del mapa (W/E/S/N) d=-180/180/-90/90 g=0/360/-90/90
	REGION=-85/-54/9/26

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
	gmt begin $title png

#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n

	gmt grdgradient @earth_relief_$RES -Nt0.5 -A45 -G"temp_intens.nc"

#	Recortar imagen satelital
#	gmt grdcut @earth_${daytime}_$RES -Gmarble.tif=gd:GTiff+cTILED=YES+cCOMPRESS=DEFLATE+cPREDICTOR=3 -R$REGION -Vi
	gmt grdcut @earth_${daytime}_$RES -Gmarble.tif=gd:GTiff+cPREDICTOR=3 -R$REGION -Vi

#	Graficar Imagen Satelital
#	gmt grdimage "@earth_${daytime}_$RES" 
#	gmt grdimage "@earth_${daytime}_$RES" -I"temp_intens.nc"
	gmt grdimage marble.tif -I"temp_intens.nc"

#	Dibujar Paises (1 paises, 2 estados/provincias en America, 3 limite maritimo)
	gmt coast -N1/0.2,- 

#	Dibujar Linea de Costae
	gmt coast -W1/ 

#	Dibujar marco del mapa 
	gmt basemap -B0

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
gmt end show

#	rm temp_* gmt.*
