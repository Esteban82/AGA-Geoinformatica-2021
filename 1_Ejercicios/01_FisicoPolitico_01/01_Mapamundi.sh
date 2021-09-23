#!/usr/bin/env bash

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=1_Mapamundi
	echo $title

#	Proyecciones miscelanas. Requieren 1 parámetro + 1 opcional: (Lon0/)Ancho
#	Proyeccion (W= MollWeide) 15 cm de ancho. 
	PROJ=W15c
	PROJ=W-65/15c

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

# Ejercicios sugeridos

