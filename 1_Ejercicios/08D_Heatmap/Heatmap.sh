#!/bin/bash
clear

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=Heatmap
	echo $title
 
#	Region Geografica y proyección
	REGION=-79/-20/-63/-20
#	REGION=-76/-60/-38/-26
	PROJ=M15c
#	PROJ=X15cd

#   Resolucion
#	RES=01m
	res=10k

#	Grilla
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
#	Crear archivo con datos para heatmap

#	Procesar Sismos
	#gmt blockmean -R$REGION Sismos/query.csv -Sn -C -h1 -i2,1 -I$res > tmp_Heatmap.xyz
	gmt blockmean -R$REGION Sismos/query.csv -Sn -h1 -i2,1 -I$res -G$CUT -A

#	Crear grilla
	#orgmt xyz2grd -G$CUT tmp_Heatmap.xyz -I$res

#	Analisis de datos
#	gmt histogram temp_Heatmap.xyz -T1 -i2 -Z0
	gmt grdinfo $CUT -T5
	gmt grdinfo $CUT -T5+a1
	gmt grdinfo $CUT -T5+a2.5
	gmt grdinfo $CUT -T5+a5

#	Crear Paleta de Colores. Paleta Maestra (-C), Definir rango (-Tmin/max/intervalo), CPT continuo (-Z)
#	gmt grd2cpt $CUT -Z -Di -Chot -L1/14
	gmt makecpt -Chot -Di -T1/14

#	Crear Imagen a partir de grilla con sombreado y cpt
	gmt grdimage $CUT -C -Q -t25

#	Agregar escala de colores a partir de CPT (-C). Posici�n (x,y) +wlargo/ancho. Anotaciones (-Ba). Leyenda (+l). 
	gmt colorbar -C -DjRT+o1.7c/0.7+w9/0.618c+ef -Baf+l"Cantidad de Sismos cada 100 km@+2@+"  -F+gwhite+p+i+s

#	Terminar de Dibujar Mapa Base
#	-----------------------------------------------------------------------------------------------------------
#	Dibujar Escala centrado en -Ln(%/%), unidad arriba de escala (+l), unidad con los valores (+u)
	gmt basemap -Ln0.11/0.075+c-32:00+w800k+f+l -F+gwhite+p+i+s

#	Dibujar frame (-B): Anotaciones (a), frame (f), grilla (g)
	gmt basemap -Bxaf -Byaf

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo de salida (ps)
gmt end

#	rm tmp_* gmt.*
#	pause
