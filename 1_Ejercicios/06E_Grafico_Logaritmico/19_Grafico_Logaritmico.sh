#!/bin/bash

#	Temas a ver: 
#	1. Graficos Logaritmicos (Diagrama de Clasificación de Rocas Volcánicas)

#	Variables del Mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=19_Grafico_Logaritmico
	echo $title

#	Dominio de datos (Xmin/Xmax/Ymin/Ymax)
	REGION=0.01/10/0.001/10

#	Proyeccion No Geografica. Lineal, Logaritmica, Exponencial. JXwidth[/height]
	PROJ=X15cl/10cl

#	Parametros GMT
#	-----------------------------------------------------------------------------------------------------------
#	Parametros de Fuentes: Titulo del grafico, del eje (label) y unidades del eje (ANNOT_PRIMARY)
	gmt set	FONT_TITLE 24,4,Black
	gmt set	FONT_LABEL 16p,19,Red
	gmt set	FONT_ANNOT_PRIMARY 12p,Helvetica,Black

#	Ejes a dibujar. Mayuscula: eje y unidades. Minuscula: eje. Sin letra, no dibujta el eje.
	gmt set	MAP_FRAME_AXES WeSn

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png
	
#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n
	
#	Definir color de fondo del grafico (+g) 
	gmt basemap -B+g200

#	Tìtulo de la figura
	gmt basemap -B+t"Diagrama de Clasificaci\363n de Rocas"

#	Titulo de los ejes (X Y) por separado: (a)notacion), (f)rame y (l)abel. p: anotacion cientifica. l: orden de mangnitud del valor (100 se anota como 2)
	gmt basemap -Bxa2f3+l"Nb/Y (ppm)"
	gmt basemap -Bya1f3+l"Zr/Ti (ppm)"
#	gmt basemap -Bya2f3+l"Zr/Ti (ppm)"
#	gmt basemap -Bya3f3+l"Zr/Ti (ppm)"
#	gmt basemap -Bya1f3p+l"Zr/Ti (ppm)"
#	gmt basemap -Bya1f3l+l"Zr/Ti (ppm)"

#	Graficar Campos
	gmt plot "NbY_ZrTi.txt" -Wthin

#	Graficar Datos
#	gmt plot "Litofacies2" -Sc0.25 -Gred   
#	gmt plot "Litofacies3" -St0.25 -Gblue  
#	gmt plot "Lacolito"    -Ss0.25 -Ggreen 
	gmt plot "Lacolito"    -Ss5 -Ggreen@50 -W1,red
#	gmt plot "Lacolito"    -Ss5 -Ggreen    -W1,red -t50

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
gmt end

	rm gmt.*

#	Ejercicios Sugeridos:
#	-----------------------------------------------------------------------------------------------------------
#	1. Ver el efecto de la "l" que aparece en PROJ (línea 16). Borrarlos. 
#	2. Modificar rango de datos (linea 13) con escala logaritmica.
#	3. Probar las otras combinaciones para dibujar los intervalos en el eje logarítmico Y: a1, a2 y a3 y agregando p y l (líneas 45 a 48).
