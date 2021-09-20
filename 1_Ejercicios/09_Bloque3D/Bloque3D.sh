#!/usr/bin/env bash
clear

#	Definir Variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=Bloque3D
	echo $title

#	Region: Cuyo
	REGION=-72/-64/-35/-30
	BASE=-10000
	TOP=10000	
	REGION3D=$REGION/$BASE/$TOP

#	Proyeccion Mercator (M)
	PROJ=M14c
	PROZ=4c
	persp=160/30

#	Grilla 
	GRD=@earth_relief_30s
#	GRD=@earth_relief_15s
#	GRD=@earth_relief_03s

# 	Nombre archivo de salida y Variables Temporales
	CUT=tmp_$title.nc
	SHADOW=tmp_$title-shadow.nc

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

#	Recortar Grilla
	gmt grdcut $GRD -G$CUT -R$REGION

#	Crear variables con valores minimo y maximo
	max=`gmt grdinfo $CUT -Cn -o5`

#	Crear Paleta de Color
	gmt makecpt -Cdem4 -T0/$max

#	Crear Grilla de Pendientes para Sombreado (Hill-shaded). Definir azimuth del sol (-A)
	gmt grdgradient $CUT -A160 -G$SHADOW -Nt0.8

#	Dibujar Figura
#	--------------------------------------------------------------------------------------------------------
#	Bloque 3D. 
#	gmt grdview $CUT -R$REGION3D -J$PROJ -JZ$PROZ -p$persp -I$SHADOW -C -Qi
#	gmt grdview $CUT -R$REGION3D -J$PROJ -JZ$PROZ -p$persp -I$SHADOW -C -Qi -Wf0.5 -N$BASE
#	gmt grdview $CUT -R$REGION3D -J$PROJ -JZ$PROZ -p$persp -I$SHADOW -C -Qi -Wf0.5 -N$BASE+glightgray
	gmt grdview $CUT -R$REGION3D -J$PROJ -JZ$PROZ -p$persp -I$SHADOW -C -Qi -Wf0.5 -N$BASE+glightgray -BnSwEZ -Baf -Bzaf+l"Altura (m)"

#	Pintar Oceanos (-S) y Lineas de Costa
	gmt coast -p$persp/0 -Df -Sdodgerblue2 -A0/0/1 
	gmt coast -p$persp/0 -Df -W1/0.3,black 

	gmt basemap $CUT -R$REGION3D -J$PROJ -JZ$PROZ -p$persp -B+n -Vi

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo de salida (ps)
gmt end

#	Borrar archivos temporales
	rm tmp_* gmt*
