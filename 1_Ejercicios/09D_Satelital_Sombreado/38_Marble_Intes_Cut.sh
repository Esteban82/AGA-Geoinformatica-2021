#!/usr/bin/env bash
clear

#	Temas a ver
#	1. Agregar efecto de sombreado a una imagen satelital. 

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Resolucion de Blue/Black Marble: 01d, 30m, 20m, 15m, 10m, 06m, 05m, 04m, 03m, 02m, 01m, 30s
	RES=03m
	
#	Mosaicos de la NASA: BlackMarble (night) o BlueMarble (day)
	daytime=day
#	daytime=night

#	Titulo del mapa
	title=38_Marble_Intes_Cut_${daytime}_$RES
	echo $title

#	Region y Proyeccion 
	REGION=-85/-54/9/26
	PROJ=M15c

#	Archivos Temporales
	CUT=tmp_%title.nc
	SHADOW=tmp_$title-shadow.nc

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png

#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n

#	Descargar dem
#	gmt grdcut @earth_relief_$RES -G$CUT

#	Sombreado a partir del DEM
	gmt grdgradient @earth_relief_$RES -Nt0.8 -A45 -G"tmp_intens.nc" -R$REGION

#	Recortar imagen satelital
#	gmt grdcut @earth_${daytime}_$RES -Gmarble.tif=gd:GTiff+cTILED=YES+cCOMPRESS=DEFLATE+cPREDICTOR=3 -R$REGION -Vi
#	gmt grdcut @earth_${daytime}_$RES -Gmarble.tif=gd:GTiff+cPREDICTOR=3 -R$REGION -Vi

#	Graficar Imagen Satelital
#	gmt grdimage "@earth_${daytime}_$RES" 
	gmt grdimage "@earth_${daytime}_$RES" -I"tmp_intens.nc"
#	gmt grdimage marble.tif -I"tmp_intens.nc"

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
