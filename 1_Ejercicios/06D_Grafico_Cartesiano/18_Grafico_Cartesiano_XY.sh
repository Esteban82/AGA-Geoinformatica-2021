#!/usr/bin/env bash

#	Temas a ver
#	1. Crear graficos cartesianos
#	2. Agregar transparencias 

#	Variables del Mapa
#	-----------------------------------------------------------------------------------------------------------
	title=18_Grafico_Cartesiano_XY
	echo $title

#	Dominio de datos (Xmin/Xmax/Ymin/Ymax)
	REGION=50/80/0/6

#	Proyeccion No Geografica. Lineal (JXwidth[/height])
#	PROJ=X15c
	PROJ=X15c/10c

#	Parametros GMT
#	-----------------------------------------------------------------------------------------------------------
#	Parametros de Fuentes: Titulo del grafico, del eje (label) y unidades del eje (ANNOT_PRIMARY)
	gmt set	FONT_TITLE 32,4,Black
	gmt set	FONT_LABEL 16p,19,Red
	gmt set	FONT_ANNOT_PRIMARY 12p,Helvetica,green

	gmt set PS_CHAR_ENCODING ISOLatin1+

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png
	
#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n

#	Tìtulo de la figura (-B+t)
	gmt basemap -B+t"Diagrama Harker"

#	Definir color de fondo del grafico (-B+g). Porcentaje de transparencia (-t)
#	gmt basemap -B+g200
	gmt basemap -B+gblack -t80

#	Titulo de los ejes (X Y) por separado: (a)notacion), (f)rame y (l)abel. Agregar prefijo (+p) y unidad (+u) a los valores. @- Inicio/Fin Subindice. 
	gmt basemap -Bxa5f1+l"SiO@-2@- (wt. \045)"
	gmt basemap -Bya1f1+l"MgO (wt. \045)"

#	Graficar Datos
	gmt plot "SiO2-MgO.txt" -Sc0.25 -Gdeepskyblue3

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
	gmt end

	rm gmt.*

#	Ejercicios Sugeridos:
#	-----------------------------------------------------------------------------------------------------------
#	1. Editar  FONT_TITLE, FONT_LABEL y FONT_ANNOT_PRIMARY (lineas 24 y 26).
#	2. Modificar el dominio de datos (REGION; linea 12) y editar los intervalos de los ejes X Y (lineas 43 y 44)
#	3. Modificar las dimensiones del gráfico a 15 cm de ancho y 10 cm de alto (linea 17).
#	4. Modificar los títulos de los ejes y el título del gráfico. Utilizar acentos y símbolos ISOLatin1+, escribir en superíndice y subrayado (lineas 39, 50 y 51).