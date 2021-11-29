#!/usr/bin/env bash
clear

#	Temas a ver:
#	1. Calcular distancias a un sitio
#	2. Curvas de nivel nivel intermedio.

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=44_Distancia_Meca
	echo $title

#	Proyecciones miscelaneas.
	PROJ=W40/15c
#	PROJ=G40/90/15c
	
#	Region geografica del mapa (W/E/S/N) d=-180/180/-90/90 g=0/360/-90/90
	REGION=d

#	Definir coordenadas del punto
	long=40
	lat=21

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png

#	Setear variables
	gmt basemap -R$REGION -J$PROJ -B+n

#	Mapa satelital de base
	gmt grdimage @earth_day

#	Dibujar limite de Paises (N1:pen División administrativa 1, países) 
	gmt coast -N1/0.2,-

#	Crear grilla con distancias (en m) a un sitio
	gmt grdmath -Rg -I1 $long $lat SDIST = tmp_dist.nc

#	Crear Curvas de Nivel de Color
#	*****************************************************************
	Intervalo=1000

#	Extaer rango de disntancias
	T=$(gmt grdinfo tmp_dist.nc -T$Intervalo)

#	Crear CPT 
#	gmt makecpt -T0/21000/500  -Crainbow -I
	gmt makecpt $T -Crainbow -I

#	Contornos de color
#	gmt grdcontour tmp_dist.nc -C
#	gmt grdcontour tmp_dist.nc -C -A+u" km"+f6+p+o+gwhite@50
#	gmt grdcontour tmp_dist.nc -C -A+u" km"+f6+p+o+gwhite@50 -W+c
#	gmt grdcontour tmp_dist.nc -C -A+u" km"+f6+p+o+gwhite@50 -W+cl
#	gmt grdcontour tmp_dist.nc -C -A+u" km"+f6+p+o+gwhite@50 -W+cl -T
	gmt grdcontour tmp_dist.nc -C -A+u" km"+f6+p+o+gwhite@50 -W+cl -T+a

#	*****************************************************************

#	Pintar area de noche en cierta fecha
	gmt solar -W1p -Gblack -t50 -T
#	gmt solar -W1p -Gblack -t50 -T+d2018-06-21T10:07:00

#	Dibujar marco del mapa (-B). Lineas de grillas (g). 
	gmt basemap -B0

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo de salida (ps)
gmt end

	rm tmp_*