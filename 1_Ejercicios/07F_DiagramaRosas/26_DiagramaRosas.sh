#!/bin/bash
#clear

#	Temas a ver:
#	1. Calcular azimuth y longitud de lineas.
#	2. Graficar diagrama de rosas.

#	Variables del Mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=26_DiagramaRosas
	echo $title

#	Dominio de datos y radio del diagrama
	REGION=0/1/0/360

#	Parametros diagrama de rosas
#	-T: 180ª ambiguedad. -Zu: valor unitario para cada segmento. -D: Centrado en la clase.
#	A: Ancho en grados del sector.
	Param="-A5 -T -D"
#	

#	gmt set GMT_LANGUAGE ES
	
#	Grafico Cartesiano
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png

#	Preparar Datos
#	-----------------------------------------------------------------------------------------------------------
#	Calcular Azimuth (-AF) y longitud en km (-G+k). -fg: Datos geográficos. Mostrar informacion.
#	gmt mapproject -fg "Datos.txt" -G+k
#	gmt mapproject -fg "Datos.txt" -AF
#	gmt mapproject -fg "Datos.txt" -AF -G+k
#	gmt mapproject -fg "Datos.txt" -AF -G+k -o3,2
#	gmt mapproject -fg "Datos.txt" -AF -G+k -o3,2 -s

#	Calcular Azimuth (-AF) y longitud en km (-G+k). -fg: Datos geográficos. Grabar datos.
	gmt mapproject -fg "Datos.txt" -AF -G+k -o3,2 -s > "tmp_rumbo" 

#	Extraer informacion
#	--------------------------------------------------------------------------------------------------------
#	Datos Estadisticos:
	echo n, mean az, mean r, mean resultant length, max bin sum, scaled mean, linear length sum.
	gmt rose "tmp_rumbo" $Param -I 
	gmt rose "tmp_rumbo" $Param -I -o0
	gmt rose "tmp_rumbo" $Param -I -o1 --FORMAT_FLOAT_OUT=%.0f
	#gmt rose "tmp_rumbo" $Param -I -o1 --FORMAT_FLOAT_OUT=%%.0f   # Usar para windows

#	Extraer cantidad de datos y azimuth promedio
	n=$(gmt rose "tmp_rumbo" $Param -I -o0)
	az=$(gmt rose "tmp_rumbo" $Param -I -o1 --FORMAT_FLOAT_OUT=%.0)
#	az=$(gmt rose "tmp_rumbo" $Param -I -o1 --FORMAT_FLOAT_OUT=%%.0)  # Usar para windows

#	Dibujar Figura
#	--------------------------------------------------------------------------------------------------------
#	Dibujar rosa. -F: No muestra escala. 
	gmt rose "tmp_rumbo" -R$REGION $Param -Gorange -W1p -Bx0.2g0.2 -By30g30 -B+glightblue -LW,E,S,N -F -S5cn 

#	Texto con informacion
	echo N = $n        | gmt text -R1/10/1/10 -JX10 -F+cTL -Ya0.375c
	echo Mean Az = $az | gmt text -R1/10/1/10 -JX10 -F+cTL 

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
gmt end

#	Borrar archivos temporales
rm tmp_* gmt.*

#	Ejercicios sugeridos
#	1. Cambiar el ancho de clase (linea 18).
#	2. Ver las otras opciones para dibujar diagrama de rosas (lineas 59 a 61).