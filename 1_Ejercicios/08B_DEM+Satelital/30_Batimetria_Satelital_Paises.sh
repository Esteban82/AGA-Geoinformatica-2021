#!/usr/bin/env bash
clear

#	Temas a ver
#	1. Combinar imagenes satelitales y grillas aplicando recortes (clip) segun datos DCW.

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=30_Batimetria_Satelital
	echo $title

#	Region: Argentina
#	REGION=-72/-64/-35/-30
#	REGION=AR,BR,CO
#	REGION=AR,CL,GS
	REGION==SA

#	Proyeccion Mercator (M)
	PROJ=M15c

#	Resoluciones grillas: 01d, 30m, 20m, 15m, 10m, 06m, 05m, 04m, 03m, 02m, 01m, 30s, 15s, 03s, 01s.
	RES=03m

#	Fuente a utilizar
	GRD=@earth_relief_$RES
	SAT=@earth_day_$RES

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png
	
#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n

#	Idem y agrega efecto de sombreado. a= azimut. nt1=metodo de ilumninacion
	gmt grdimage $GRD -I
    
#	Agregar escala de colores a partir de CPT (-C). Posición (x,y) +wlargo/ancho. Anotaciones (-Ba). Leyenda (+l). 
#	gmt colorbar -DJRM -I -Baf -By+l"km" -W0.001 -F+gwhite+p+i+s -GNaN/0

#	Recorte (visual)
#	*************************************************************
    gmt coast -EAR+c   # Recorte dentro
#   gmt coast -EAR+C   # Recorte fuera

#	Graficar imagen satelital
	gmt grdimage $SAT
#   gmt grdimage $SAT -t50

#	Finalizar recorte
    gmt clip -C
#	*************************************************************

#	-------------------------------------------------------------------------------------------------
#	Dibujar frame
	gmt basemap -Bxaf -Byaf

#	Dibujar Linea de Costa (W1)
	gmt coast -N1/faint

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo
gmt end