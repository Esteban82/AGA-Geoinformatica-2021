#!/usr/bin/env bash
clear

#	Temas a ver
#   1. Hacer mapas a partir de DEM. 
#	2. Agregar efecto de sombreado (-I)
#	3. Dibujar y personalizar barra de color.

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=07_Topografico
	echo $title

#	Region: Argentina
	REGION=-72/-64/-35/-30
	REGION=AR,BR,CO
	REGION=AR,CL,GS

#	Proyeccion Mercator (M)
	PROJ=M15c

#	Resoluciones grillas: 01d, 30m, 20m, 15m, 10m, 06m, 05m, 04m, 03m, 02m, 01m, 30s, 15s, 03s, 01s.
	RES=05m

#	Fuente a utilizar
	GRD=@earth_relief_$RES

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
	gmt begin $title png
	
#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n

#	Crear Imagen a partir de grilla. Usa el CPT por defecto y la ajusta al rango de valores de alturas automaticamente.
#	gmt grdimage $GRD

#	Idem y agrega efecto de sombreado. a= azimut. nt1=metodo de ilumninacion
#	gmt grdimage $GRD -I
#	gmt grdimage $GRD -I+a45
	gmt grdimage $GRD -I+a45+nt1

#	Agregar escala de colores a partir de CPT (-C). Posición (x,y) +wlargo/ancho. Anotaciones (-Ba). Leyenda (+l). 
#	gmt colorbar -DJBC
#	gmt colorbar -DJRM
#	gmt colorbar -DJRM   -I
#	gmt colorbar -DJRM+o0.3c/0+w11/0.618c -I
#	gmt colorbar -DJRM+o0.3c/0+w11/0.618c -I -Ba2000f500
#	gmt colorbar -DJRM+o0.3c/0+w11/0.618c -I -Ba2000f500 -Bx+l"Elevaciones (m)"
#	gmt colorbar -DJRM+o0.3c/0+w11/0.618c -I -Ba2000f500 -By+l"m"
# 	gmt colorbar -DJRM+o0.3c/0+w11/0.618c -I -Baf -By+l"km" -W0.001
#	gmt colorbar -DjRM -I -Baf -By+l"km" -W0.001 -F+gwhite+p+i+s
	gmt colorbar -DjRM -I -Baf -By+l"km" -W0.001 -F+gwhite+p+i+s -GNaN/0

#	-----------------------------------------------------------------------------------------------------------
#	Dibujar frame
	gmt basemap -Bxaf -Byaf

#	Dibujar Linea de Costa (W1)
	gmt coast -Da -W1/faint

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo
gmt end

#	Ejercicios Sugeridos
#	1. Modificar region del mapa y la resolucion del mapa
#	2. Modificar azimuth de la fuente de iluminuacion (az en linea 43)
#	3. Probar las distintas opciones para la escala de color (lineas 45 a 55).