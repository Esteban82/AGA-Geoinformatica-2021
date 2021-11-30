#!/usr/bin/env bash

#	Variables del Mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo de la figura
	title=Grafico_Dunlop2002
	echo $title

#	Dominio de datos (eje X e Y)
	REGION=1/100/0.005/1

#	Proyeccion Lineal (X). Ancho y alto (en cm)
	PROJ=X15cl/10cl

#	Parametros GMT
#	-----------------------------------------------------------------------------------------------------------
#	Parametros de Fuentes: Titulo del grafico, del eje (label) y unidades del eje (ANNOT_PRIMARY)
	gmt set	FONT_TITLE 16,4,Black
	gmt set	FONT_LABEL 10p,19,Red
	gmt set	FONT_ANNOT_PRIMARY 8p,Helvetica,Blue

	gmt set PS_CHAR_ENCODING ISOLatin1+
	gmt set IO_SEGMENT_MARKER B

#	Ejes a dibujar. Mayuscula: eje y unidades. Minuscula: eje. Sin letra, no dibuja el eje.
	gmt set	MAP_FRAME_AXES WS

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png
	
#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n

#	Tìtulo de la figura (-B+t)
	gmt basemap -B+t"Diagrama de Dunlop 2002"

#	Color de fondo del grafico (-B+g"color")
	gmt basemap -B+g200

#	Titulo de los ejes (X Y) por separado: (a)notacion), (f)rame y (l)abel. @- Inicio/Fin Subindice. 
	gmt basemap -Bxa2f3+l"H@-RC@-/H@-C@-"
	gmt basemap -Bya2f3+l"J@-RS@-/J@-S@-"

 #	Lineas para grafico Dunlop 2002
 #	**************************************************************
 #	Crear archivo auxiliar para las lineas
 	cat > tmp_Lineas <<- END
	1,0.02
	100,0.02
	
	1,0.5
	100,0.5
	
	2,0.005
	2,1
	
	5,0.005
	5,1
	END

#	Graficar Lineas del Grafico
	gmt plot "tmp_Lineas" -Wthin
#	***********************************

#	Nombre Campos
#	**************************************************************
	cat > tmp_campos <<- END
	1.50,0.75,SD
	3.75,0.20,PSD
	10.00,0.10,SP+SD
	15.00,0.01,MD
	END
	
#	Poner Nombre de los Campos
	gmt text "tmp_Campos" -F+f12
#	***********************************

#	Graficar Datos como símbolos. Color (-G), Borde (-W) y forma (-S)
#	**************************************************************
	gmt plot "Datos.txt" -: -Wthinnest -S0.2 -Ccategorical
	
#	Leyenda
#	-----------------------------------------------------------------------------------------------------------
#	Archivo Auxiliar
	cat > tmp_leyenda <<- END
	N 1
	S 0.25c c 0.25c green thinnest 0.5c Rabot
	S 0.25c s 0.25c blue  thinnest 0.5c Hamilton
	S 0.25c t 0.25c red   thinnest 0.5c Sanctuary
	S 0.25c d 0.25c cyan  thinnest 0.5c Haslum Craig	
	END
		
#	Dibujar Leyenda
 	gmt legend tmp_leyenda -DjTR+w3/0+o-1.7/0.2+jTC -F+gwhite+p+i+r+s 

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
gmt end

	rm tmp_* gmt.*
