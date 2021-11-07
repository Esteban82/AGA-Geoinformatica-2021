#!/usr/bin/env bash
clear

#	Definir Variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=EJ13.3_Bloque3D_Cubrir_Pendiente
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
	GRD=@earth_relief_01m
	GRD=@earth_relief_30s

# 	Nombre archivo de salida y Variables Temporales
	CUT=temp_$title.nc
	CUT2=temp_$title-2.nc
    COLOR=temp_$title.cpt
	SHADOW=temp_$title-shadow.nc

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


#	Crear Paleta de Color
	#gmt makecpt -Cdem4 -T0/7000
	gmt makecpt -Cdem4 -T0/$max

#	Calcular Grilla con modulo del gradiente
	gmt grdgradient $CUT -D -Stemp_mag.grd -fg

#	Convertir modulo del gradiente a inclinacion (pendiente) en radianes (ATAN), y luego a grados (R2D)
	gmt grdmath temp_mag.grd ATAN R2D = $CUT2

#	Crear variables con valores maximo
	max=`gmt grdinfo $CUT2 -Cn -o5`

#	Crear Paleta de Color
    gmt makecpt -Cbatlow -T0/$max -I -Di
    gmt grd2cpt $CUT2 -Crainbow -L0/20 -I -Di

#	Crear Grilla de Pendientes para Sombreado (Hill-shaded). Definir azimuth del sol (-A)
	gmt grdgradient $CUT -A160 -G$SHADOW -Nt0.8

#	Dibujar Figura
#	--------------------------------------------------------------------------------------------------------
#	Bloque 3D
#	gmt grdview $CUT -R$REGION3D -J$PROJ -JZ$PROZ -p$persp -I$SHADOW -C -Qi300
#	gmt grdview $CUT -R$REGION3D -J$PROJ -JZ$PROZ -p$persp -I$SHADOW -C -Qi300 -N$BASE+glightgray -Wf0.5
	#gmt grdview $CUT -R$REGION3D -J$PROJ -JZ$PROZ -p$persp -I$SHADOW -C -Qi300 -N$BASE+glightgray -Wf0.5 \
	#-BnSwEZ -Baf -Bzaf+l"Altura (m)"
#	gmt grdview $CUT -R$REGION3D -J$PROJ -JZ$PROZ -p$persp -I$SHADOW -C -Qi300 -N$BASE+glightgray -Wf0.5 \
#   -BnSwEZ+b -Baf -Bzaf+l"Altura (m)"
    gmt grdview $CUT -R$REGION3D -J$PROJ -JZ$PROZ -p$persp -I$SHADOW -C -Qi300 -N$BASE+glightgray -Wf0.5 \
    -BnSwEZ -Baf -Bzaf+l"Altura (m)" -G$CUT2

#	Dibujar datos culturales en bloque 3D
#	-----------------------------------------------------------------------------------------------------------
#	Pintar Oceanos (-S) y Lineas de Costa en 2D
	gmt coast -p$persp/0 -Df -Sdodgerblue2 -A0/0/1 
	gmt coast -p$persp/0 -Df -W1/0.3,black 
	
#	Dibujar datos de coast en 3D
#	gmt psxy -R$REGION3D -J$PROJ -JZ$PROZ -p$p -T -K -P >> $OUT
	gmt coast -R$REGION -Df -M -N1/ | gmt grdtrack -G$CUT -sa | gmt plot3d -R$REGION3D -p$persp -W0.5,black 
	gmt coast -R$REGION -Df -M -N2/ | gmt grdtrack -G$CUT -sa | gmt plot3d -R$REGION3D -p$persp -W0.2,black,-

#	Dibujar datos IGN en 3D
#	gmt grdtrack -R$REGION "E:\Facultad\Datos_Geofisicos\IGN\1_GMT\003_Red_Ferroviaria.gmt"  -G$CUT -sa | gmt plot3d -R$REGION3D -p$persp -Wthin,blue
#	gmt grdtrack -R$REGION "E:\Facultad\Datos_Geofisicos\IGN\1_GMT\005_Centros_Poblados.gmt" -G$CUT -sa | gmt plot3d -R$REGION3D -p$persp -W0.2,black,- -Sc0.1 -Gred
#	gmt grdtrack -R$REGION "E:\Facultad\Datos_Geofisicos\IGN\1_GMT\010_Ejidos_Urbanos.gmt"   -G$CUT -sa | gmt plot3d -R$REGION3D -p$persp -Wfaint -Ggreen

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo de salida (ps)
gmt end
	
#	Borrar archivos temporales
	#rm temp_* gmt*
#	pause