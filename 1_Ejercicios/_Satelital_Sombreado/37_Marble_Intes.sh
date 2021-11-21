#!/bin/bash
clear

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Resolucion de Blue/Black Marble: 01d, 30m, 20m, 15m, 10m, 06m, 05m, 04m, 03m, 02m, 01m, 30s
	RES=05m
	
#	Mosaicos de la NASA: BlackMarble (night) o BlueMarble (day)
	daytime=day
	daytime=night

#	Titulo del mapa
	title=Marble_Intes_${daytime}
	echo $title

#	Proyeccion Geografica
#	PROJ=W-65/15c
	PROJ=M15c
#	PROJ=G-65/-30/90/15c
#	PROJ=S-65/-30/90/15c

#	Region geografica
#	REGION=d
#	REGION=-100/30/-50/20
	REGION=BR
#	REGION=BR,AR

#	Archivos Temporales
	CUT=tmp_$title.nc
	SHADOW=tmp_$title-shadow.nc

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png

#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n

#	Crear grilla para efecto de sombreado a partir del DEM
	gmt grdgradient @earth_relief_$RES -Nt1 -A45 -G$SHADOW -R$REGION

#	Graficar Imagen Satelital
	gmt grdimage @earth_${daytime}_$RES -I$SHADOW

#	Dibujar Paises
	gmt coast -N1/0.2,- 

#	Dibujar marco del mapa 
gmt basemap -Bxaf -Byaf

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
gmt end #show

#	rm tmp_* gmt.*