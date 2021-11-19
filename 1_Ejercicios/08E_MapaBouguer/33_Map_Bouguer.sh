#!/usr/bin/env bash
clear

#	Temas a ver: 
#	1. Crear grilla a partir de tabla de datos.
#	2. Crear cpt a partir de la grilla (grd2cpt).

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=33_Mapa_Bouguer
	echo $title

#	Grilla 
	GRD=@earth_relief_30m

#	Region y proyeccion geografica
	REGION=d
	PROJ=W15c

# 	Archivos temporales
	CUT=tmp_$title.nc
	SHADOW=tmp_$title-shadow.nc

	gmt set GMT_VERBOSE w

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura.
	gmt begin $title png

#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n

#	Ver info de la tabla de datos
#	gmt info EIGEN-6C4.gdf -h37

#	Crear grilla a partir de tabla de formato gdf. Stepgrid (-I). Lineas de encabezado (-h).
	gmt xyz2grd -R$REGION EIGEN-6C4.gdf -h37 -I30m -fg -G$CUT 
#	gmt xyz2grd -R$REGION EIGEN-6C4.gdf -h37 -I30m -fg -Gtemp_grilla.asc=ei

#	Extraer informacion de la grilla recortada para determinar rango de CPT
#	gmt grdinfo $CUT

#	Crear CPT a partir de la grilla para optimizar la distribución de los colores
#	gmt grd2cpt $CUT -V
#	gmt grd2cpt $CUT -V -Z 				 			# Z: CPT continuo
#	gmt grd2cpt $CUT -V -Z -L-200/300    			# L: Limitar valores 
#	gmt grd2cpt $CUT -V -Z -L-200/300 -D    		# D: extender colores de los extremos
#	gmt grd2cpt $CUT -V -Z -L-200/300 -D -Cjet		# C: CPT maestra

#	Crear Imagen a partir de grilla con sombreado y cpt
	gmt grdimage $CUT

#	Agregar escala de colores a partir de CPT (-C). Posición (x,y) +wlargo/ancho. Anotaciones (-Ba). Leyenda (+l). 
	gmt colorbar -DJRM+o0.3c/0 -C -Ba200+l"Anomalias Bouguer (mGal)" -I

#	-----------------------------------------------------------------------------------------------------------
#	Dibujar frame
	gmt basemap -Bf

#	Dibujar Linea de Costa (W1)
	gmt coast -W1/faint -N1

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo de salida (ps)
gmt end

	rm tmp_* gmt.*

#	Ejercicios sugeridos
#	1. Ver las distintas opciones de grd2cpt.




