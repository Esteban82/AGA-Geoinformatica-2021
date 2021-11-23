#!/usr/bin/env bash

#	Temas a ver
#	1. Crear animación simulando un vuelo entre dos ciudades.


#	Titulo de la animación
title=anim3

# 1. Crear archivos con las variables 
cat << 'EOF' > include.sh
# Ciudades (Longitud/Latitud)
#Inicio=-68.304444/-57.807222	# Ushuaia
Inicio=-58.5258/-34.8553		# Buenos Aires
#Fin=-65.6/-22.105556			# La Quiaca
Fin=-70.666667/-33.45			# Santiago de Chile
Intervalo=5k
EOF

# 2. Crear archivos para la animacion
cat << 'EOF' > pre.sh
gmt begin
	gmt project -C$Inicio -E$Fin -G$Intervalo -Q | gmt mapproject -fg -AF -s3 > flight_path.txt 
	gmt image 1.jpg -Dx0/0+w24c -X0 -Y0
gmt end
EOF
cat << 'EOF' > main.sh
gmt begin
	gmt grdimage -JG${MOVIE_COL0}/${MOVIE_COL1}/${MOVIE_WIDTH}+du+z160+a${MOVIE_COL3}+t55+v36 -Rg @earth_day -Xc -Y-5c
	gmt coast -N1/thinner -N2/faint
gmt end
EOF
# 2. Crear la animacion
gmt movie main.sh -Chd -N$title -Iinclude.sh -Tflight_path.txt -Sbpre.sh -H2 -Vi -Ml,png -Zs  -Fmp4
