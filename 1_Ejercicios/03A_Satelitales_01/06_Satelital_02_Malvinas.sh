#!/usr/bin/env bash
clear

#	Temas a ver:
#	1. Definir region del mapa a partir de una grilla/raster.
#	2. Dibujar y personalizar norte geografico.
#	3. Dibujar y personalizar escala.
#	4. Dibujar y personalizar norte marco de la figura.

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=06_Satelital_02_Malvinas
	echo $title

#	Imagen satelital (Geotfiff)
	#IMG=Datos/SanJuan_Geo.tif
	IMG=Datos/Malvinas_Geo.tif
	
#	Region Geografica
	REGION=$IMG
#	REGION=-61.5/-57.5/-52.5/-51
#	REGION=-60/-57.5/-52.5/-51
	
#	Proyeccion: (M)ercator y Ancho de la figura) 
	PROJ=M15c

#	Parametros Generales
#	-----------------------------------------------------------------------------------------------------------
#	Parametros de Fuentes: Titulo del grafico, del eje (label) y unidades del eje (ANNOT_PRIMARY)
	gmt set	FONT_TITLE 12,4,Black
	gmt set	FONT_LABEL 10p,19,Black
	gmt set	FONT_ANNOT_PRIMARY 8p,Helvetica,Black

#	Sub-seccion FORMATO
#	gmt set FORMAT_GEO_MAP ddd.xxxG
#	gmt set FORMAT_GEO_MAP ddd.xxxF
#	gmt set FORMAT_GEO_MAP ddd:mm:ss
	gmt set FORMAT_GEO_MAP ddd:mm:ssF

#	Sub-seccion MAPA
#	gmt set MAP_FRAME_TYPE inside
#	gmt set MAP_FRAME_TYPE fancy+
	gmt set MAP_FRAME_TYPE fancy

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png

#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n

#	Graficar Imagen Satelital
	#gmt grdimage "@earth_day_01m"
	gmt grdimage $IMG

#	Pintar areas humedas: Oceanos (-S) y Lagos (-Cl/)f
	color=dodgerblue2
	gmt coast -Df -S$color 

#	Dibujar Linea de Costa (level/, where level is 1-4 and represent coastline, lakeshore, island-in-lake shore, and lake-in-island-in-lake shore)
	gmt coast -Df -W1/faint

#	Dibujar Norte (-Td). Ubicacion definida por coordenads geograficas (g) centrado en Lon0/Lat0, ancho (+w). Opcionalmente se pueden definir el nivel (+f), puntos cardinales (+l)
#	gmt basemap -Tdg-58/-51.25+w1.25c+f3+lO,E,S,N --FONT_TITLE=8p,4,Black
#	gmt basemap -Tdg-58/-51.25+w1.25c+f2	      --FONT_TITLE=8p,4,Black
#	gmt basemap -Tdg-58/-51.25+w1.25c+f1+l        --FONT_TITLE=8p,4,Black
	gmt basemap -Tdg-58/-51.25+w1.25c	          --FONT_TITLE=8p,4,Black

#	Agregar Norte personalizado a partir de una imagen
	#gmt image "Datos/Norte.png" -DjTR+o0.9+w0.9c

#	Dibujar Escala en el mapa centrado en -Lg Lon0/Lat0, calculado en el meridiano (+c) y de ancho (+w). Opcionalmente se puede elegir un estilo elegante(+f), agregar las unidades arriba de escala (+l) o con los valores (+u).
#	-Fl: Agrega fondo a la escala. +gfill: color fondo. +p(pen): borde principal. +i(pen): borde interno. +r(radio): borde redondeado. +s: sombra
	gmt basemap -Lg-58/-52:20+c-51:45+w50k+f+l
#	gmt basemap -Lg-58/-52:20+c-51:45+w50k+f+u
#	gmt basemap -Lg-58/-52:20+c-51:45+w50k+f 
#	gmt basemap -Lg-58/-52:20+c-51:45+w50k   
#	gmt basemap -Lg-58/-52:20+c-51:45+w50k+f   -Fl+gwhite
#	gmt basemap -Lg-58/-52:20+c-51:45+w50k+f   -Fl+gwhite+p       
#	gmt basemap -Lg-58/-52:20+c-51:45+w50k+f   -Fl+gwhite+p+i     
#	gmt basemap -Lg-58/-52:20+c-51:45+w50k+f   -Fl+gwhite+p+i+r   
#	gmt basemap -Lg-58/-52:20+c-51:45+w50k+f   -Fl+gwhite+p+i+r+s 

#	Dibujar frame (-B): Anotaciones (a), frame (f), grilla (g). Opcionalmete agregar valores.
#	Ejes a dibujar. Mayuscula: eje y unidades. Minuscula: eje. Sin letra: no dibuja el eje (para graficos XY).
	gmt basemap -BWesN -Baf
#	gmt basemap -BWesN -Bafg
#	gmt basemap -BWesN -Byaf
#	gmt basemap -BWesN -Bxafg -Byaf  
#	gmt basemap -BWesN -Bxa1f0.5g0.25 -Byaf

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
gmt end #show

rm gmt.conf

#	-----------------------------------------------------------------------------------------------------------
#	Ejercicios Sugeridos:
#	1. Especificar tipo de letra (lineas 31-33).
#
#	2. Norte Geografico (lineas 65-72).
#	2.1. Ver los nortes geograficos que resultan de las distintans combinaciones de: +f(1,2,3), +l y +lO,E,S,N. (lineas 66 a 68).
#	2.2. Las letras de las coordenas estan definidos por FONT_TITLE. Cambiar los parametros que definen el estilo de letra (tamaño, tipo de letra, color).
#	2.3. Agregar un fondo blanco (-Ft).
#
#	3. Escala grafica (lineas 74-84).
#	3.1. Ver las escalas que resultan de la combinacion de +f, +l y +u (lineas 76 a 79).
#	3.2. Ver como cambian los recuadros de la escala con -Fl (lineas 80 a 84).

#	4. Marco del Mapa (lineas 86-92)
#	4.1. Ver los marcos que resultan de las distintas combinaciones de: afg (lineas 88 a 92).
#	4.2. Ver como cambian las coordenadas geograficas (del marco) segun FORMAT_GEO_MAP (lineas 36-39)
#	4.3. Ver como cambian los ejes al editar MAP_FRAME_AXES (-BWesN; lineas 88 a 92).