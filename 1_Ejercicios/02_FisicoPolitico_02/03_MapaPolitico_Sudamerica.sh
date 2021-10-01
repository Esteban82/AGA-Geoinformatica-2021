#!/usr/bin/env bash

#	Temas a ver:
#	1. Ver uso practico de variable ($color)
#	2. Definir las propiedades de las lineas en GMT (color, ancho, estilo).
#	3. Definir regiones del mapa con WESN


#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=03_MapaPolitico_Sudamerica
	echo $title

#	Region: Sudamérica (limites W/E/S/N)
	REGION=-85/-33/-58/15

#	Proyeccion Conica (lon0/lat0/lat1/lat2/width). Proyeccion Albers (B); Lambert (L): Equidistant (D).
#	PROJ=D-60/-30/-40/0/15c
	PROJ=B-60/-30/-40/0/15c

#	Parametros por Defecto
#	-----------------------------------------------------------------------------------------------------------
#	Sub-seccion GMT
	gmt set GMT_VERBOSE w

#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png

#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n

#	Resaltar paises DCW (AR: Argentina soberana, FK: Malvinas, GS: Georgias del Sur y Sandwich del Sur, CO: Colombia)
	gmt coast -EAR,FK,GS+grosybrown2+p

#	Pintar areas húmedas: Oceanos (-S) y Lagos (-Cl/)f
	color=117/197/240
	gmt coast -Sdodgerblue2 -Cl/$color

#	Dibujar Bordes Administrativos. N1: paises. N2: Provincias, Estados, etc. N3: limites marítimos (Nborder[/pen])
	gmt coast -Df -N1/0.75
	gmt coast -Df -N2/0.25,-.

#	Dibujar Linea de Costa (level/, where level is 1-4 and represent coastline, lakeshore, island-in-lake shore, and lake-in-island-in-lake shore)
	gmt coast -Df -W1/0.25

#	Dibujar rios -Iriver[/pen] 
#	0 = Double-lined rivers (river-lakes)
#	1 = Permanent major rivers
#	2 = Additional major rivers
#	3 = Additional rivers
#	4 = Minor rivers
	gmt coast -Df -I0/thin,$color
	gmt coast -Df -I1/thinner,$color
	gmt coast -Df -I2/thinner,$color,-
	gmt coast -Df -I3/thinnest,$color,-...
	gmt coast -Df -I4/thinnest,$color,4_1:0p

#	Dibujar frame
	gmt basemap -Baf

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
gmt end show

	rm gmt.*

#	Ejercicios Sugeridos:
#	1. Modificar el color de los rios (variable $color).
#	2. Modificar las lineas de los rios (ancho, estilo de linea).
