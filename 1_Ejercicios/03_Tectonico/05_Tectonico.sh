#!/bin/bash

#	Dibujar lineas y simbolos (nivel intermedio) y patrones.


#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=05_Tectonico
	echo $title

#	Region Geografica
	REGION=-79/-20/-63/-50

#	Proyeccion Cilindrica: (M)ercator
	PROJ=M18c

#	Parametros GMT
#	-----------------------------------------------------------------------------------------------------------
#	Parametros de Fuentes: Titulo del grafico, del eje (label) y unidades del eje (ANNOT_PRIMARY)
	gmt set	FONT_TITLE 16,4,Black
	gmt set	FONT_LABEL 10p,19,Black
	gmt set	FONT_ANNOT_PRIMARY 8p,Helvetica,Black
	gmt set	MAP_FRAME_AXES WesN

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png
	
#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n

#	Pintar areas humedas: Oceanos (-S) y Lagos (-Cl/)f
	color=dodgerblue2
	gmt coast -Da -S$color

#	Dibujar Linea de Costa (level/, where level is 1-4 and represent coastline, lakeshore, /island-in-lake shore, and lake-in-island-in-lake shore)
	gmt coast -Da -W1/faint

#	Datos Tectonicos
#	-----------------------------------------------------------------------------------------------------------
#	Plates Project: Limite de Placas
	gmt plot "Datos\transform.gmt" -A -W0.4,black -Sf2.0c/0.25+l+s -Gblack
	gmt plot "Datos\trench.gmt"    -A -W0.4,green -Sf0.6c/0.15+l+t -Ggreen
	gmt plot "Datos\ridge.gmt"     -A -W1.0,red
	gmt plot "Datos\ridge.gmt"     -A -W0.4,white

#	Plates Project: LIPs. Dibujar patrones
#	gmt plot "Datos\LIPS.2011.gmt" -A -Gp300/29 
#	gmt plot "Datos\LIPS.2011.gmt" -A -Gp300/29
	gmt plot "Datos\LIPS.2011.gmt" -A -Gp300/29:BivoryFred3 

#	Dibujar Sismos
#	-----------------------------------------------------------------------------------------------------------
#	Crear cpt para sismos someros (<100 km), intermedios (100 - 300 km) y profundos (> 300 km)
#	gmt makecpt -Cred,green,blue,black -T0,100,300,600,1000
	gmt makecpt -Crainbow -T0/700
	gmt colorbar -DjBL+o0.2c+w-3c/0.5c

#	Dibujar Sismos del USGS segun magnitud (-Scp), y color segun profundidad (-C). 
#	-Scp: El tamaño del circulo corresponde a la magnitud medida en puntos tipograficos. 
#	gmt plot "Sismos\USGS.txt"  -W0.1 -Gred -Sc0.1c		# Tamaño y color fijo 
#	gmt plot "Sismos\USGS.txt"  -W0.1 -C    -Sc0.1c    	# Color variable (3 columna) y tamaño fijo
	gmt plot "Sismos\USGS.txt"  -W0.1 -C 	-Scp		# Color (3a col) y tamaño (4a col) variable 

#	Convertir tabla de datos 	
#	gmt convert query.csv -h1 -i2,1,3,4 > Sismos.txt

#	Plotear datos originales (ver -h y -i)
#	gmt plot "Sismos\query.csv" -W.1 -C -Scp -h1 -i2,1,3,4     
 

#	Dibujar Mecanismos Focales
#	-----------------------------------------------------------------------------------------------------------
#	Datos Global CMT. Tamaño Proporcional a la magnitud (-M: Tamaño Homogeneo)
#	gmt meca "Mecanismos_Focales\CMT_1976-2013.txt"   -Sd0.15/6
#	gmt meca "Mecanismos_Focales\CMT_1976-2013.txt"   -Sd0.15/0 -Gred          
#	gmt meca "Mecanismos_Focales\CMT_2014-2015.txt"   -Sd0.15/0 -Gorange
#	gmt meca "Mecanismos_Focales\CMT_*.txt"           -Sd0.15/0 -Gorange
	gmt meca "Mecanismos_Focales\CMT_*.txt"           -Sd0.15/0 -Gorange -M
	
#	-----------------------------------------------------------------------------------------------------------
#	Dibujar Escala en el mapa centrado en -Lg Lon0/Lat0, calculado en meridiano (+c), ancho (+w), elegante(+f), unidad arriba de escala (+l), unidad con los valores (+u)
	gmt basemap -Lf-68/-62/-54/500k+l

#	Dibujar frame (-B): Anotaciones (a), frame (f), grilla (g)
	gmt basemap -Bxa8f4 -Bya4f2

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
	gmt end

	rm gmt.conf
#	-----------------------------------------------------------------------------------------------------------
#	Ejercicios Sugeridos:
#	1. En las lineas 44-45 se utilza plot para dibujar lines correspodientes a fallas de rumbo e inversas. Modificar el formato (ver manpage de plot el formato de -Sf).
#	2. En las lineas 72-74 se crea un cpt que luego se utiliza para pintar los sismos. Modificar los rangos de valores de cpt y los colores asginados. 
#	3. Ver como descargar y dibujar mecanismos focales (90-98).
