#!/usr/bin/env bash

#	Temas a ver: 
#	1. Crear animaciones basicas.
#	2. Crear listar de valores.

#	Titulo de la animación
title=10_TierraGirando

#	Archivo con lista de Valores que se usaran para el script principal 
	gmt math -T0/359/1 -o1 T = "tmp_time.txt"				# Rotación Inversa
#	gmt math -T0/359/1 -o1 T -I = "tmp_time.txt"			# Rotación Normal
#	gmt math -T0/359/1 -o1 T -65 ADD -I = "tmp_time.txt"	# Rotación Normal empezando en meridiano -65
	
#	Movie: Crear figuras y animacion
#	Opciones C: Canvas Size. -N: Nombre de la animacion. -G: Color fondo. D: fps. F: formato video. M: Master frame.
	gmt movie "Master_Hemisferico.sh" -N$title -T"tmp_time.txt" -C15cx15cx100 -D24 -Vi -Ml,png -Gblack -Fmp4 -Z

#	Borrar Temporales
	rm gmt.conf
#	-------------------------------------------------
#	Apagar (-s) o Hibernar (/h) PC
#	Linux
#	shutdown -h # apagar
#	systemctl suspend  #suspender

##  Windows 
#	shutdown -h # Hibernar

#	-----------------------------------------------------------------------------------------------------------
#	Ejercicios Sugeridos:
#	1. Cambiar la velocidad de la animación (-D24).
#	2. Probar crear las animaciones con las distintas listas de archivos (lineas 11 a 13).
#	3. Crear una nueva la lista de valores.