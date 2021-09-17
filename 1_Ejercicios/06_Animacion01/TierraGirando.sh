#!/usr/bin/env bash

#	Titulo de la animación
title=TierraGirando

#	Archivo con lista de Valores que se usaran para el script principal 
	gmt math -T0/359/1 -o1 T = "tmp_time.txt"		# Rotación Inversa
#	gmt math -T0/359/1 -o1 T -I = "tmp_time.txt"		# Rotación Normal
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
#systemctl suspend  #suspender

##  Windows 
#	shutdown -h # Hibernar
