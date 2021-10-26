#!/bin/bash

#	Temas a ver
#	1. Agregar leyenda.
#	2. Agregar mapa de ubicacion.

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=08_Tectonico
	echo $title

#	Region Geografica
	REGION=-79/-20/-63/-50

#	Proyeccion Cilindrica: (M)ercator
	PROJ=M15c

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
	gmt plot "Datos/transform.gmt" -A -W0.4,black -Sf2.0c/0.25+l+s -Gblack
	gmt plot "Datos/trench.gmt"    -A -W0.4,green -Sf0.6c/0.15+l+t -Ggreen
	gmt plot "Datos/ridge.gmt"     -A -W1.0,red
	gmt plot "Datos/ridge.gmt"     -A -W0.4,white

#	Plates Project: LIPs. Dibujar patrones
#	gmt plot "Datos/LIPS.2011.gmt" -A -Gp300/29 
#	gmt plot "Datos/LIPS.2011.gmt" -A -Gp300/29
	gmt plot "Datos/LIPS.2011.gmt" -A -Gp300/29:BivoryFred3 

#	Dibujar Sismos
#	-----------------------------------------------------------------------------------------------------------
#	Crear cpt para sismos someros (<100 km), intermedios (100 - 300 km) y profundos (> 300 km)
#	gmt makecpt -Cred,green,blue,black -T0,100,300,600,1000
	gmt makecpt -Crainbow -T0/700
	gmt colorbar -DjBL+o0.2c+w-3c/0.5c

#	Dibujar Sismos del USGS segun magnitud (-Scp), y color segun profundidad (-C). 
#	-Scp: El tamaño del circulo corresponde a la magnitud medida en puntos tipograficos. 
#	gmt plot "Sismos/USGS.txt"  -W0.1 -Gred -Sc0.1c		# Tamaño y color fijo 
#	gmt plot "Sismos/USGS.txt"  -W0.1 -C    -Sc0.1c    	# Color variable (3 columna) y tamaño fijo
	gmt plot "Sismos/USGS.txt"  -W0.1 -C 	-Scp		# Color (3a col) y tamaño (4a col) variable 

#	Convertir tabla de datos 	
#	gmt convert query.csv -h1 -i2,1,3,4 > Sismos.txt

#	Plotear datos originales (ver -h y -i)
#	gmt plot "Sismos/query.csv" -W.1 -C -Scp -h1 -i2,1,3,4     

#	Dibujar Mecanismos Focales
#	-----------------------------------------------------------------------------------------------------------
#	Datos Global CMT. Tamaño Proporcional a la magnitud (-M: Tamaño Homogeneo)
#	gmt meca "Mecanismos_Focales/CMT_1976-2013.txt" -Sd0.15/6
#	gmt meca "Mecanismos_Focales/CMT_1976-2013.txt" -Sd0.15/0 -Gred          
#	gmt meca "Mecanismos_Focales/CMT_2014-2015.txt" -Sd0.15/0 -Gorange
#	gmt meca Mecanismos_Focales/CMT_*.txt           -Sd0.15/0 -Gorange
	gmt meca Mecanismos_Focales/CMT_*.txt           -Sd0.15/0 -Gorange -M
	
#	-----------------------------------------------------------------------------------------------------------
#	Dibujar Escala en el mapa centrado en -Lg Lon0/Lat0, calculado en meridiano (+c), ancho (+w), elegante(+f), unidad arriba de escala (+l), unidad con los valores (+u)
	#gmt basemap -Lf-68/-62/-54/500k+l
	gmt basemap -Lg-68/-62+c-54+w500k+f+l

#	Dibujar frame (-B): Anotaciones (a), frame (f), grilla (g)
	gmt basemap -Bxaf -Byaf


#	-----------------------------------------------------------------------------------------------------------
#	Leyenda. H: Encabezado. D: Linea horizontal. N: # columnas verticales. V: Linea Vertical
#
	echo H 10 Times-Roman Leyenda del Mapa >> temp_legend

	echo N 3 >> temp_legend
	echo S 0.25c - 0.5c - 3.0p,red		0.75c Dorsal 				>> temp_legend
	echo S 0.25c f+l+t 0.5c t 1.0p,green 	0.75c Subucci\363n 			>> temp_legend
	echo S 0.25c f+l+s 0.5c s 1p,black  	0.75c L\355mite Transforme		>> temp_legend
	echo G 0.075c >> temp_legend

	echo S 0.25c c 0.25c red   0.40p 	0.5c Sismos someros (0-100 km)	 	>> temp_legend	
	echo S 0.25c c 0.25c green 0.40p 	0.5c Sismos intermedios (100-300 km) 	>> temp_legend	
	echo S 0.25c c 0.25c blue  0.40p 	0.5c Sismos profundos (300-700 km) 	>> temp_legend
	echo G 0.075c >> temp_legend

	echo N 4 >> temp_legend
	echo S 0.25c r 0.5c p300/29  0.25p 	0.75c LIPS 		 >> temp_legend
	echo S 0.25c r 0.5c purple4  0.25p 	0.75c Ofiolitas 	 >> temp_legend
	echo S 0.25c - 0.5c - 1.0p,violet 	0.75c Zonas de Fracturas >> temp_legend
	echo S 0.25c - 0.5c - 0.80p,orange	0.75c Dorsales Extintas  >> temp_legend	
	echo G 0.075c >> temp_legend
	
	echo M -70 -57 500+u f 						 >> temp_legend
	
 	gmt pslegend -R -J -O -K "temp_legend" >> $OUT -Dx7.5/-0.2+w15/0+jTC -F+p+i+r 
	
#	Leyenda Auxiliar
	echo H 10 Times-Roman  > "temp_legend"	
	echo N 3 >> "temp_legend"
	echo S 0.25c - 0.5c - 1.0p,white >> "temp_legend"
 	gmt pslegend -R -J -O -K "temp_legend" >> $OUT  -Dx7.5/-0.2+w15/0+jTC

#	-----------------------------------------------------------------------------------------------------------
#	Mapa de Ubicacion (INSET)
	gmt inset begin
#	Recuadro debajo Mapa Inset
	gmt psbasemap -R -J -O -K -DjTR+w3.81c+o0.381c/0.254c         -F+gwhite+p1p+c0.1c+s >> $OUT -V
	pause
 	
#	Dibujar Mapa INSET
	gmt pcoast -Rd -JG-49.5/-57.5/3.81c -O -K -W0.3p,black -B90 -Dc -Gblack -Swhite -X10.809c -Y1.98505c >> $OUT
#	gmt pscoast -Rd -JG-49.5/-57.5/2.5c -O -K -W0.3p,black -B90 -Dc -Gblack -Swhite -X12.5c -Y5.0c >> $OUT


#	Crear y Dibujar Recuadro de zona de estudio
#		REGION=-79/-20/-63/-50
	echo -79 -63 >> "temp_Recuadro"
	echo -79 -50 >> "temp_Recuadro"
	echo -20 -50 >> "temp_Recuadro"
	echo -20 -63 >> "temp_Recuadro"

	gmt psxy "temp_Recuadro" -R -J -Ap -W0.45p,red -O -L -K >> $OUT
	gmt inset end

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
	gmt end

	rm gmt.conf
#	-----------------------------------------------------------------------------------------------------------
#
#	Ejercicios Sugeridos:
#	1. E