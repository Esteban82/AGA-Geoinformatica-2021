#!/usr/bin/env bash
clear

#	Temas a ver: 
#	1. Definir resolucion de archivo de salida (DPI).
#	2. Extraer informacion de grillas y crear una variable.
#	3. Combinar CPT.

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=25_Mapa_Bouguer
	echo $title

#	Grilla 
	GRD=@earth_relief_03m

#	Region y proyeccion geografica
	REGION=d
	PROJ=W15c

# 	Archivos temporales
	CUT=temp_$title.nc
	SHADOW=temp_$title-shadow.nc
	color=temp_$title.cpt

	gmt set GMT_VERBOSE w

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura.
#	E: Resolucion mapa (en dpi)
	gmt begin $title png

#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n

#	
	gmt info EIGEN-6C4.gdf -h37 

#	Crear grilla a partir de tabla de formato gdf. Stepgrid (-I). Lineas de encabezado (-h).
	gmt xyz2grd -R$REGION -G$CUT EIGEN-6C4.gdf -h37 -I30m -fg
#	gmt grdinfo $CUT

#	Extraer informacion de la grilla recortada para determinar rango de CPT
#	gmt grdinfo $CUT

#	Crear variables con los valores minimo y maximo 
#	min=`gmt grdinfo $CUT -Cn -o4`
#	max=`gmt grdinfo $CUT -Cn -o5`
#	echo $min $max

#	Crear grilla para sombreado
#	gmt grdgradient @earth_relief_15m -A270 -G$SHADOW -Nt1

#	Crear Imagen a partir de grilla con sombreado y cpt
	gmt grdimage $CUT # -I # -C 
#	gmt grdimage $CUT -I$SHADOW

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

	rm temp_* gmt.* $top

#	Ejercicios Sugeridos
#	1. Cambiar la resolución de la imagen a 200 dpi (E200).
#	2. Probar las distintas combinaciones de CPT (lineas 53 a 78)
#	3. Probar usando otra CPT del sitio cpt-city (agregar URL en linea 84).
