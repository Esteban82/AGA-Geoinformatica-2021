#!/usr/bin/env bash
clear

#	Temas a ver:
#	1. Dibujar columnas en 3D
#	2. Extrar informacion y graficar texto

#	Definir Variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=Copa_America_Titulos
	echo $title

#	Region: Cuyo
	REGION=-85/-33/-58/15
	REGION3D=$REGION/0/15

#	Proyeccion Mercator (M)
	PROJ=M15c
	PROZ=5c
	persp=210/40

#	Parametros Generales
#	-----------------------------------------------------------------------------------------------------------
#	Sub-seccion FUENTE
	gmt set FONT_ANNOT_PRIMARY 8,Helvetica,black
	gmt set FONT_LABEL 8,Helvetica,black

#	Sub-seccion FORMATO
	gmt set FORMAT_GEO_MAP ddd:mm:ssF

#	Sub-seccion GMT
	gmt set GMT_VERBOSE w

#	Sub-seccion MAPA
	gmt set MAP_FRAME_TYPE fancy
	gmt set MAP_FRAME_WIDTH 0.1
	gmt set MAP_GRID_CROSS_SIZE_PRIMARY 0
	gmt set MAP_SCALE_HEIGHT 0.1618
	gmt set MAP_TICK_LENGTH_PRIMARY 0.1

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png

#	Setear variables
	gmt basemap -R$REGION3D -J$PROJ -JZ$PROZ -p$persp -B+n

#	Mapa  Base
	gmt coast -p -G200 -Sdodgerblue2 -N1

#	Titulo
	gmt basemap -p -B+t"Copas Am\351ricas Ganadas"

#	Dibujar Eje X,Y,Z
	gmt basemap -p -BWSneZ -Bxf -Byf -Bzafg+l"Cantidad"

#	Dibujar Columnas
#	--------------------------------------------------------------------------
#	Dibujar Datos en Columnas (o) con color fijo. -So: base de la columna
#	gmt plot3d -p "CopaAmerica.csv" -So0.5c -Wthinner -Gred
#	gmt plot3d -p "CopaAmerica.csv" -So0.7c -Wthinner -Gred

#	Dibujar Datos en Columnas (o) con color variable
#	------------------------------------------------
#	Extraer info
#	gmt info CopaAmerica.csv
	T=$(gmt info CopaAmerica.csv -T1 -i2)

#	Crear CPT con info previa (-ilong,lat,altura,valor para el color)
	gmt makecpt -Crainbow $T
	gmt plot3d -p "CopaAmerica.csv" -So0.5c -Wthinner -i0,1,2,2 -C
#	------------------------------------------------

#	Escribir Numero
	gmt convert "CopaAmerica.csv" -o0,1,2 | gmt text -p -Gwhite@30 -D0/-0.8c -F+f20p,Helvetica-Bold,firebrick=thinner+jCM

#	Dibujar escala vertical
	gmt colorbar -p -C -DJRM+o0.3c/0+w13/0.618c -L0.1 #-B+l"Cantidad"

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo de salida (ps)
gmt end

#	Borrar archivos temporales
rm gmt.*
