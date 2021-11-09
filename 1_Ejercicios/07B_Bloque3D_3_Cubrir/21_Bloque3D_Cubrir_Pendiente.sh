#!/usr/bin/env bash
clear

#	Definir Variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=21_Bloque3D_Cubrir_Pendiente
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
#	GRD=@earth_relief_01m
	GRD=@earth_relief_30s

# 	Nombre archivo de salida y Variables Temporales
	CUT=tmp_$title.nc
	CUT2=tmp_$title-2.nc
    COLOR=tmp_$title.cpt
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

#	Calcular Grilla con modulo del gradiente
	gmt grdgradient $CUT -D -Stmp_mag.grd -fg

#	Convertir modulo del gradiente a inclinacion (pendiente) en radianes (ATAN), y luego a grados (R2D)
	gmt grdmath tmp_mag.grd ATAN R2D = $CUT2

#	Crear variables con valores maximo
	max=`gmt grdinfo $CUT2 -Cn -o5`

#	Crear Paleta de Color
#	gmt makecpt -Cbatlow -T0/$max -I -Di
	gmt makecpt -Crainbow -T0/30 -I -Di

#	Crear Grilla de Pendientes para Sombreado (Hill-shaded). Definir azimuth del sol (-A)
	gmt grdgradient $CUT -A160 -G$SHADOW -Nt0.8

#	Dibujar Figura
#	--------------------------------------------------------------------------------------------------------
#	Bloque 3D
#	gmt grdview $CUT -R$REGION3D -J$PROJ -JZ$PROZ -p$p -I$SHADOW -C -Qi300 -N$BASE+glightgray -Wf0.5 \
#   -BnSwEZ+b -Baf -Bzaf+l"Altura (m)"
    gmt grdview $CUT -R$REGION3D -J$PROJ -JZ$PROZ -p$p -I$SHADOW -C -Qi300 -N$BASE+glightgray -Wf0.5 \
    -BnSwEZ -Baf -Bzaf+l"Altura (m)" -G$CUT2

#	Dibujar datos culturales en bloque 3D
#	-----------------------------------------------------------------------------------------------------------
#	Pintar Oceanos (-S) y Lineas de Costa en 2D
	gmt coast -p$p/0 -Da -Sdodgerblue2 -A0/0/1 
	gmt coast -p$p/0 -Da -W1/0.3,black 
	
#	Dibujar datos de coast en 3D
	gmt coast -R$REGION -Df -M -N1/ | gmt grdtrack -G$CUT -sa | gmt plot3d -R$REGION3D -p$p -W0.5,black 
	gmt coast -R$REGION -Df -M -N2/ | gmt grdtrack -G$CUT -sa | gmt plot3d -R$REGION3D -p$p -W0.2,black,-

#	Dibujar datos IGN en 3D
	gmt grdtrack -R$REGION RedVial_Autopista.gmt                       -G$CUT -sa | gmt plot3d -R$REGION3D -p$p -Wthinnest,black
	gmt grdtrack -R$REGION RedVial_Ruta_Nacional.gmt                   -G$CUT -sa | gmt plot3d -R$REGION3D -p$p -Wthinnest,black
	gmt grdtrack -R$REGION RedVial_Ruta_Provincial.gmt                 -G$CUT -sa | gmt plot3d -R$REGION3D -p$p -Wfaint,black
	gmt grdtrack -R$REGION lineas_de_transporte_ferroviario_AN010.shp  -G$CUT -sa | gmt plot3d -R$REGION3D -p$p -Wthinnest,darkred

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo de salida (ps)
gmt end
	
#	Borrar archivos temporales
	rm tmp_* gmt*
