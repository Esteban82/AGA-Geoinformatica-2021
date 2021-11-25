#!/bin/bash
clear

#	Temas a ver
#	1. Agregar efecto de sombreado a una imagen satelital.

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Resolucion de Blue/Black Marble: 01d, 30m, 20m, 15m, 10m, 06m, 05m, 04m, 03m, 02m, 01m, 30s
	RES=10m
	
#	Mosaicos de la NASA: BlackMarble (night) o BlueMarble (day)
	daytime=day
#	daytime=night

#	Titulo del mapa
	title=37_Satelital_Sombreado_${daytime}
	echo $title

#	Mapamundis. Mollweide (M), Robinson (N), Eckert VI (Ks)
#	PROJ=W-65/15c
	PROJ=N-65/15c
#	PROJ=Ks-65/15c

#	Proyecciones acimutales requieren 3 parametros + 1 opcional (lon0/lat0[/horizon]/width
#	L(a)mbert Equal Area; (S)tereographic; Orto(g)rafica; (E)quidistante
#	PROJ=S-65/0/90/15c
#	PROJ=S-65/-30/90/15c
#	PROJ=G-65/0/90/15c
#	PROJ=G-65/-30/90/15c
#	PROJ=G-65/-90/90/15c

#	Region geografica
	REGION=d

#	Archivos Temporales
	SHADOW=tmp_$title-shadow.nc

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png

#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n

#	Sombreado a partir del DEM
#	gmt grdgradient @earth_relief_$RES -A45 -G$SHADOW -R$REGION -Nt0.8
#	gmt grdgradient @earth_relief_$RES -A45 -G$SHADOW -R$REGION -Nt1
#	gmt grdgradient @earth_relief_$RES -A45 -G$SHADOW -R$REGION -Nt1.2
	gmt grdgradient @earth_relief_$RES -A45 -G$SHADOW -R$REGION -Ne0.6
 
#	Graficar Imagen Satelital
	gmt grdimage @earth_${daytime}_$RES -I$SHADOW

#	Dibujar Paises
	gmt coast -N1/0.2,- 

#	Dibujar marco del mapa
	gmt basemap -Bxaf -Byaf

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
gmt end #show

	rm tmp_*
	
#	Ejercicios sugeridos
#	1. Probar las distintas proyecciones.
#	2. Ver los distintos argumentos para crear el grilla de sombreado. 
	
