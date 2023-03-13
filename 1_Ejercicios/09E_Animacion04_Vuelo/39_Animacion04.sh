#!/usr/bin/env bash

#	Temas a ver
#	1. Crear animación simulando un vuelo entre dos ciudades.

#	Titulo de la animación
title=39_Animacion04

# 1. Crear archivos con las variables 
cat << 'EOF' > include.sh
# Ciudades (Longitud/Latitud)
Inicio=-68.304444/-57.807222	# Ushuaia
#Inicio=-58.5258/-34.8553		# Buenos Aires
#Inicio=139.692222/35.689722	# Tokyo

Fin=-65.6/-22.105556			# La Quiaca
#Fin=-70.666667/-33.45			# Santiago de Chile
#Fin=-0.1275/51.507222			# Londres

# Intervalo en km del trayecto (de esto depende la cantidad de frames)
#Intervalo=10
Intervalo=5

#Altura=100
Altura=160
EOF

# 2. Crear archivos para la animacion
cat << 'EOF' > pre.sh
gmt begin
	gmt project -C$Inicio -E$Fin -G$Intervalo -Q | gmt mapproject -fg -AF -s3 > flight_path.txt 
	gmt image Fondo.jpg -Dx0/0+w24c -X0 -Y0
gmt end
EOF
cat << 'EOF' > main.sh
gmt begin
	gmt grdimage -JG${MOVIE_COL0}/${MOVIE_COL1}/${MOVIE_WIDTH}+du+z$Altura+a${MOVIE_COL3}+t55+v36 -Rg @earth_day -Xc -Y-5c
	gmt coast -N1/thinner -N2/faint
gmt end
EOF
# 2. Crear la animacion
gmt movie main.sh -Chd -N$title -Iinclude.sh -Tflight_path.txt -Sbpre.sh -H2 -Vi -Ml,png -Zs -Fmp4

#	Ejercicios Sugeridos
#	1. Cambiar los puntos de inicio y final.
#	2. Cambiar la equidistancia (la cantidad de frames depende de esto).
#	3. Cambiar al altura de vuelo.