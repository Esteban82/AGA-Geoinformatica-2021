#!/usr/bin/env bash

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=01_Mapamundi
	echo $title

#	Proyecciones miscelanas. Requieren 1 parámetro + 1 opcional: (Lon0/)Ancho
#	Proyeccion (W= MollWeide) 15 cm de ancho (o alto +dh). 
	PROJ=W15c
	PROJ=W-65/15c
	#PROJ=W-65/15c+dh

#	Region geografica del mapa (W/E/S/N) d=-180/180/-90/90 g=0/360/-90/90
	REGION=d

#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png

#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n

#	Pintar areas secas (-Gcolor)
	gmt coast -G200

#	Pintar areas húmedas (-SColor). Mares, Lagos y Rios.
	gmt coast -Sdodgerblue2

#	Dibujar Linea de Costa con una ancho (-Wpen) de 0.25 
	gmt coast -W

#	Dibujar limite de Paises (N1: pen División administrativa 1, países) 
	gmt coast -N1/0.2,-

#	Dibujar marco del mapa (-B). Lineas de grillas (g). 
	gmt basemap -Bg

#	Dibujar paralelos principales y meridiano de Greenwich a partir del archivo paralelos.txt -Am (lineas siguen meridianos)
	gmt plot 'Paralelos.txt' -Ap -W0.50,.-

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
gmt end # show

# 	Ejercicios sugeridos
#	***********************************************************************
#	1. Cambiar el titulo del grafico (y del archivo de salida; (variable $title).
#	2. Cambiar ancho de la figura a 10 cm de ancho (10c), y a 8 cm de alto (8+dh).
#	3. Cambiar el tipo de proyección Miscelánea Hammer (H) y Robinson (N).
#	4. Cambiar el meridiano central a 60. 
#	5. Cambiar el color para áreas secas (utilizar colornames)-
#	6. Cambiar el color para áreas húmedas (utilizar colornames).
#	7. Cambiar/agregar otros formatos de salida (pdf, eps, tiff)