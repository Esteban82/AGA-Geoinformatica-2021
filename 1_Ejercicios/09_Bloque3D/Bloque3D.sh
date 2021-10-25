#!/usr/bin/env bash
clear

#	Temas a ver:
#	1. Crear bloques 3D.

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
	p=160/30

#	Grilla 
#	GRD=@earth_relief_30s
	GRD=@earth_relief_15s
#	GRD=@earth_relief_03s

# 	Nombre archivo de salida y Variables Temporales
	CUT=tmp_$title.nc
	SHADOW=tmp_$title-shadow.nc

#	Parametros Generales
#	-----------------------------------------------------------------------------------------------------------
#	Sub-seccion FORMATO
	gmt set FORMAT_GEO_MAP ddd:mm:ssF

#	Sub-seccion GMT
	gmt set GMT_VERBOSE w

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
	gmt grdview $CUT -R$REGION3D -J$PROJ -JZ$PROZ -p$p -I$SHADOW -C -Qi300
#	gmt grdview $CUT -R$REGION3D -J$PROJ -JZ$PROZ -p$p -I$SHADOW -C -Qi -Wf0.5 -N$BASE
#	gmt grdview $CUT -R$REGION3D -J$PROJ -JZ$PROZ -p$p -I$SHADOW -C -Qi -Wf0.5 -N$BASE+glightgray
#	gmt grdview $CUT -R$REGION3D -J$PROJ -JZ$PROZ -p$p -I$SHADOW -C -Qi -Wf0.5 -N$BASE+glightgray -BnSwEZ -Baf -Bzaf+l"Altura (m)"

#	Pintar Oceanos (-S) y Lineas de Costa
	gmt coast -p$p/0 -Da -Sdodgerblue2 -A0/0/1 
	gmt coast -p$p/0 -Da -W1/0.3,black 

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo de salida (ps)
gmt end

#	Borrar archivos temporales
	rm tmp_* gmt*

#	Ejercicios sugeridos


