#!/bin/bash
clear

#	Temas a ver:
#	1. Calcular azimuth y longitud de lineas.
#	2. Graficar diagrama de rosas.

#	Variables del Mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=26_DiagramaRosas
	echo $title

#	Region: Argentina
	REGION=0/1/0/360

#	Proyeccion (tamaño del grafico)
	PROJ=X10

#	gmt set GMT_LANGUAGE ES
	
#	Grafico Cartesiano
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png

#	Preparar Datos
#	-----------------------------------------------------------------------------------------------------------
#	Calcular Azimuth (-AF) y longitud en km (-G+k). -fg: Datos geográficos.
	gmt mapproject -fg "Datos.txt" -G+k
#	gmt mapproject -fg "Datos.txt" -AF
#	gmt mapproject -fg "Datos.txt" -AF -G+k
#	gmt mapproject -fg "Datos.txt" -AF -G+k -o3,2
#	gmt mapproject -fg "Datos.txt" -AF -G+k -o3,2 -s
	gmt mapproject -fg "Datos.txt" -AF -G+k -o3,2 -s > "tmp_rumbo" 


#	Datos Estadisticos. Ver cantidadd de datos
	echo n, mean az, mean r, mean resultant length, max bin sum, scaled mean, linear length sum.
	gmt rose "tmp_rumbo" -I -D -T
#	pause

#	Extraer info de N y Mean Az para el grafico
	gmt rose "tmp_rumbo" -I -D -T > tmp_q
	gmt info "tmp_q" -C -o0
	gmt info "tmp_q" -C -o2 --FORMAT_FLOAT_OUT=%.0f
#	gmt info "tmp_q" -C -o2 --FORMAT_FLOAT_OUT=%%.0f

#	Extraer cantidad de datos y azimuth promedio
	n=$(gmt info "tmp_q" -C -o0)
	az=$(gmt info "tmp_q" -C -o2 --FORMAT_FLOAT_OUT=%.0f)
#	az=$(gmt info "tmp_rumbo" -C -o2 --FORMAT_FLOAT_OUT=%%.0f)

#	Dibujar Figura
#	--------------------------------------------------------------------------------------------------------
#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n

#	Grafico 
#	-----------------------------------------------------------------------------------------------------------
#	Dibujar rosa. -A: Ancho del sector en grados. -D: Centrado en la clase. -F: No muestra escala. -T: 180 ambiguedad. -Zu:
	gmt rose "tmp_rumbo" -Gorange -W1p -Bx0.2g0.2 -By30g30 -B+glightblue -LW,E,S,N -F -A10 -S5cn -D -T

#	Texto con info
	echo N = $n        | gmt text -R1/10/1/10 -JX10 -F+cTL -Ya0.375c
	echo Mean Az = $az | gmt text -R1/10/1/10 -JX10 -F+cTL 

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
gmt end


#	Borrar archivos temporales
#	rm temp_* gmt.*
