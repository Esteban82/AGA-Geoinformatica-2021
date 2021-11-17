#!/bin/bash
clear

#	Temas a ver:
#	1. Agrupar datos
#	2. Crear heatmap a partir de datos de sismos.


#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=34_Heatmap
	echo $title
 
#	Region Geografica y proyección
	REGION=-79/-20/-63/-20
#	REGION=-74/-64/-36/-28
	PROJ=M15c

#   Resolucion de la grilla de densidades (heatmap)
	res=10k
#	res=30m
#	res=50k

#	Grilla mapa base
	GRD=@earth_relief_04m

# 	Nombre archivo de salida
	CUT=tmp_$title.nc

#	Parametros GMT
#	-----------------------------------------------------------------------------------------------------------
#	Parametros de Fuentes: Titulo del grafico, del eje (label) y unidades del eje (ANNOT_PRIMARY)
	gmt	set FONT_TITLE 16,4,Black
	gmt	set FONT_LABEL 10p,19,Black
	gmt	set FONT_ANNOT_PRIMARY 8p,Helvetica,Black
	gmt	set MAP_FRAME_AXES WesN

#	Sub-seccion COLOR
	gmt set COLOR_NAN white

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png

#	Setear variables
	gmt basemap -R$REGION -J$PROJ -B+n

#	Dibujar Mapa Base
#	-----------------------------------------------------------------------------------------------------------
#	Crear CPT Mapa Fondo
	gmt makecpt -T-11000,0,9000 -Cdodgerblue2,white

#	Crear Imagen a partir de grilla con sombreado
	gmt grdimage $GRD -C -I

#	Dibujar Bordes Administrativos. N1: paises. N2: Provincias, Estados, etc.
	gmt coast -N1/0.30 
	gmt coast -N2/0.25,-.

#	***********************************************************************
#	Procesar Sismos
#	-----------------------------------------------------------------------------------------------------------
#	Combinar archivos con datos de sismicidad en un unico archivo.
	cat Datos/query_* > tmp_sismos.txt

#	Extraer datos de Longitud y Latitud. -s: no escribe datos con NaN
	gmt convert tmp_sismos.txt -i2,1 -hi1 -s > tmp_LongLat.txt

#	Crear tabla de datos con cantidad de sismos (-Sn) en cada bloque (de $res x $res; -I). -C: Ubicacion en centro del bloque.
	gmt blockmean tmp_LongLat.txt -Sn -C -I$res > tmp_Heatmap.xyz

#	Crear grilla a partir de tabla de datos
#	gmt xyz2grd tmp_Heatmap.xyz -I$res -GAscii.grd=ei
	gmt xyz2grd tmp_Heatmap.xyz -I$res -G$CUT

#	Analisis de datos
	gmt grdinfo $CUT -T
	gmt grdinfo $CUT -T+a1
	gmt grdinfo $CUT -T+a2.5
	gmt grdinfo $CUT -T+a5

#	Crear Variable para CPT
	T=$(gmt grdinfo $CUT -T+a5)

#	Crear CPT. Paleta Maestra (-C).
	gmt makecpt -Chot -Di $T

#	Crear Imagen a partir de grilla con sombreado y cpt
#	gmt grdimage $CUT -C
#	gmt grdimage $CUT -C    -t50
#	gmt grdimage $CUT -C -Q
	gmt grdimage $CUT -C -Q -t50

#	Agregar escala de colores a partir de CPT (-C). Posici�n (x,y) +wlargo/ancho. Anotaciones (-Ba). Leyenda (+l). 
	gmt colorbar -C -DjRT+o1.7c/0.7+w9/0.618c+ef -Baf+l"Cantidad de Sismos cada 100 km@+2@+"  -F+gwhite+p+i+s

#	Dibujar frame (-B): Anotaciones (a), frame (f), grilla (g)
	gmt basemap -Bxaf -Byaf

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo de salida (ps)
gmt end

	rm tmp_* gmt.*

#	Ejercicios sugeridos
#	1. Cambiar la resolución de la grilla de densidades (lineas 21-23).
#	2. Cambiar region geografica del mapa.
