#!/bin/bash

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
#	Resoluciones disponibles: 01d, 30m, 20m, 15m, 10m, 06m, 05m, 04m, 03m, 02m, 01m, 30s, 15s
	RES=20m

#	Definir Tipo de Histograma: Contar (-Z0), Frecuencia (-Z1).
#	Z=0
	Z=1

#	Ancho de la clase (bin width) del Histograma (-T)
	T=50
#	T=10
#	T=100

#	Titulo del mapa
	title=40_Hipsometria_Global
	echo $title

#	Definir DEM
	DEM="@earth_relief_$RES"
	
#	Dimensiones y tipo de graficos y rango de alturas
	PROJ=X15c/10c
	MIN=-11000
	MAX=8500

#	Binario (h: 2-byte signed int. f: 4-byte single-precision float).
	BIN=1h,1f

# 	Nombre archivo de salida
	color=tmp_$title.cpt

#	Parametros GMT
#	-----------------------------------------------------------------------------------------------------------
#	Parametros de Fuentes: Titulo del grafico, del eje (label) y unidades del eje (ANNOT_PRIMARY)
	gmt set FONT_TITLE 14,4,Black
	gmt set FONT_LABEL 10p,19,Red
	gmt set FONT_ANNOT_PRIMARY 8p,Helvetica,Black
	gmt set FONT_ANNOT_SECONDARY 7p,Helvetica,Black

	gmt set MAP_ANNOT_OFFSET_SECONDARY 5p
	gmt set MAP_GRID_PEN_SECONDARY 1p

	gmt set GMT_VERBOSE w

#	Inicio
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png
	
#	-----------------------------------------------------------------------------------------------------------
#	Extraer datos alturas (ponderados por area -Wa) de la grilla y guardarlos como binarios
#	-------------------------------------------------------------
	gmt grd2xyz $DEM > "tmp_datos" -Wa -o2,3 -bo$BIN

#	Convertir datos binarios a txt
#	gmt convert "tmp_datos" -bi$BIN > "tmp_datos.txt"

#	Frecuencia Altimetrica
#	-----------------------------------------------------------------------------------------------------------
#	Analizar datos y extraer info
	gmt histogram "tmp_datos" -bi$BIN -I -Z$Z+w -T$T
	MIN=$(gmt histogram "tmp_datos" -bi$BIN -Z$Z+w -T$T -I -o0)
	MAX=$(gmt histogram "tmp_datos" -bi$BIN -Z$Z+w -T$T -I -o1)
	
#	Crear CPT para los colores
	gmt makecpt -Cabyss -T$MIN/0  -N -H >  $color
	gmt makecpt -Cdem2  -T0/$MAX     -H >> $color

#	Curva Hipsometrica
#	--------------------------------------------------------------
#	Redefinir Parametros
	gmt set	MAP_FRAME_AXES WS

#	Ejes de anotaciones X,Y
	gmt histogram "tmp_datos" -bi$BIN -J$PROJ -A -C$color -T$T -Z$Z+w -Bxafg+l"Elevaciones (m)" -Byaf+l"Frecuencia Altim\351trica (\045)"

#	Curva Hipsometrica Acumulada
#	-----------------------------------------------------------------------------------------------------------
#	Redefinir Parametros
	DOMINIO=$MIN/$MAX/0/100.3
	gmt set	MAP_FRAME_AXES EN
	gmt set	FONT_LABEL 10p,19,Blue

#	Dibujar Curva Hipsometrica
#	gmt histogram "tmp_datos" -bi$BIN -J$PROJ -R$DOMINIO -A -F -Z$Z+w -T1 -S -Wthinner -Byaf+l"Frecuencia Acumulada (\045)" -B+t"An\341lisis Hipsom\351trico" -Q
	gmt histogram "tmp_datos" -bi$BIN -J$PROJ -R$DOMINIO -A -F -Z$Z+w -T1 -S -Wthinner -Byaf+l"Frecuencia Acumulada (\045)" -B+t"An\341lisis Hipsom\351trico" -Qr

#	----------------------------------------------
#	Recuadro Figura
	#gmt basemap -B0 -Bwesn

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo de salida (ps)
	gmt end

	rm gmt.* tmp_*