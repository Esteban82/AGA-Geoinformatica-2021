#!/bin/bash
clear

#	Temas a ver
#	1. Crear histrograma.
#	2. Dibujar eje secundario.
#	3. Invertir orden del eje (de mayor a menor)

#	Variables del Mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=Histograma
	echo $title

#	Proyeccion No Geografica. Linear, Logaritmica, Exponencial. JXwidth[/height]
	PROJ=X-15c/10c
	
#	Tipo de Histograma: Contar (-Z0), Frecuencia (-Z1). 
#	Z=0
	Z=1
		
#	Ancho de la clase (bin width) del Histograma (-T)
	T=50
#	T=10
#	T=100

#	Parametros GMT
#	-----------------------------------------------------------------------------------------------------------
#	Parametros de Fuentes: Titulo del grafico, del eje (label) y unidades del eje (ANNOT_PRIMARY)
	gmt set	FONT_TITLE 16,4,Black
	gmt set	FONT_LABEL 10p,19,Red
	gmt set	FONT_ANNOT_PRIMARY 8p,Helvetica,Black
	gmt set	FONT_ANNOT_SECONDARY 7p,Helvetica,Black

	gmt set	MAP_FRAME_TYPE fancy

	gmt set	MAP_ANNOT_OFFSET_SECONDARY=5p
	gmt set	MAP_GRID_PEN_SECONDARY=1p

#	Grafico Cartesiano
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png

#	Extraer informacion
	gmt histogram "U-PB_Ages.txt" -Io -Z$Z -T$T				# Muestra infomracion en la terminal
	gmt histogram "U-PB_Ages.txt" -Io -Z$Z -T$T > tmp_info	# Guardar informacion en un archivo
	gmt histogram "U-PB_Ages.txt" -I  -Z$Z -T$T				# Muestra minimos y maximos en la terminal 
	
#	Dibujar histograma. Definir borde (-W), relleno (-G).
#	gmt histogram U-PB_Ages.txt -J$PROJ -Z$Z -T$T -Byafg+l"Frecuencia (\045)" -Bx500f100 -Gorange
#	gmt histogram U-PB_Ages.txt -J$PROJ -Z$Z -T$T -Byafg+l"Frecuencia (\045)" -Bx500f100 -Gorange -B+glightblue -Bsxc"Eje/Eones.txt"+l"Eones (Ma)"
	gmt histogram U-PB_Ages.txt -J$PROJ -Z$Z -T$T -Byafg+l"Frecuencia (\045)" -Bx500f100 -Gorange -B+glightblue -Bsxc"Eje/Eones.txt"+l"Eones (Ma)" -W

#	Dibujar histrograma aculumativo (-Q) 
#	gmt histogram U-PB_Ages.txt -J$PROJ -Z$Z -T$T -Byafg+l"Frecuencia (\045)" -Bx500f100 -Gorange -B+glightblue -Bsxc"Eje/Eones.txt"+l"Eones (Ma)" -W -Q
#	gmt histogram U-PB_Ages.txt -J$PROJ -Z$Z -T$T -Byafg+l"Frecuencia (\045)" -Bx500f100 -Gorange -B+glightblue -Bsxc"Eje/Eones.txt"+l"Eones (Ma)" -W -Qr
#	gmt histogram U-PB_Ages.txt -J$PROJ -Z$Z -T$T -Byafg+l"Frecuencia (\045)" -Bx500f100 -Gorange -B+glightblue -Bsxc"Eje/Eones.txt"+l"Eones (Ma)" -W -Qr
#	gmt histogram U-PB_Ages.txt -J$PROJ -Z$Z -T1  -Byafg+l"Frecuencia (\045)" -Bx500f100 -Gorange -B+glightblue -Bsxc"Eje/Eones.txt"+l"Eones (Ma)" -W -Qr -S

#	Otros ejes secundarios
#	gmt histogram U-PB_Ages.txt -J$PROJ -Z$Z -T$T -Byafg+l"Frecuencia (\045)" -Bx500f100 -Gorange -B+glightblue -Bsxc"Eje/Eras_Geologicas2.txt"+l"Eras (Ma)" -W
#	gmt histogram U-PB_Ages.txt -J$PROJ -Z$Z -T$T -Byafg+l"Frecuencia (\045)" -Bx500f100 -Gorange -B+glightblue -Bsxc"Eje/Eras_Geologicas3.txt"+l"Eras (Ma)" -W
	
#	-----------------------------------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
gmt end

#	rm gmt.* tmp_info

#	-----------------------------------------------------------------------------------------------------------
#	Ejercicios Sugeridos:
#	1. Ver como agregar un eje primario y secundario (lineas 55 y 56).
#	2. El negativo de la variable PROJ revierte la orientación del eje X. Ver los gráficos que resultan de agregar y quitar el "-" en los ejes.
#	3. Probar las otras opciones para hacer ejes secundarios (lineas 65 y 66).
#	4. Cambiar el tipo de histograma (Z=0, linea 19).
#	5. Cambiar el ancho de clase (Lineas 24 y 25).
