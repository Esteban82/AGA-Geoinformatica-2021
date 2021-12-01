#!/usr/bin/env bash
clear

#	Temas a ver:
#	1. Dibujar columnas en 3D
#	2. Extrar informacion y graficar texto

#	Definir Variables del mapaS
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=49_Sismicidad3D
	echo $title

#	Region: Cuyo
	REGION=-80/-53/-40/-20
#	REGION=-74/-64/-36/-28

#	Resolucion de la grilla de densidades (heatmap)S
	res=10k
	Max=100

#	Proyeccion Mercator (M)
	PROJ=M15c
	PROZ=3c
	persp=210/40
		
	OUT=tmp_$title.txt

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
	gmt basemap -R$REGION/0/$Max -J$PROJ -JZ$PROZ -p$persp -B+n

#	Mapa Base 
	gmt grdimage -p @earth_relief -I
#	gmt grdimage -p @earth_day

#	Dibujar limites
	gmt coast -p -N1 -N2

#	Dibujar Eje X,Y,Z
	gmt basemap -p -BWSneZ -Bxf -Byf -Bz+l"Sismos cada 100 km@+2@+" 


#	Procesar Sismos
#	-----------------------------------------------------------------------------------------------------------
#	Combinar datos y crear tabla de datos
	cat Datos/query_* | gmt convert -i2,1 -hi1 -s | gmt blockmean -R$REGION -Sn -C -I$res > $OUT

#	Dibujar Columnas
#	--------------------------------------------------------------------------
	gmt makecpt -Chot -Di -T0/$Max
	
#	gmt plot3d -p $OUT -So0.03u
	gmt plot3d -p $OUT -So0.03u -C -i0:2,2 -Vi
#	gmt plot3d -p $OUT -So0.03u -C -i0:2,2 -t50
#	gmt plot3d -p $OUT -So0.02u -C -i0:2,2 #-t50
	
#	gmt plot3d -p $OUT -So0.0833333ub0 -C -i0:2,2 -t50

#	------------------------------------------------
#	Dibujar escala vertical
	gmt colorbar -p -C -DJRM+o0.3c/0+w70%+ef -B

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo de salida (ps)
gmt end

#	Borrar archivos temporales
rm gmt.*
