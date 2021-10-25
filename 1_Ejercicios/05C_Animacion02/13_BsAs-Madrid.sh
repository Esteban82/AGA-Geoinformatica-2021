#!/usr/bin/env bash

#	Titulo de la animación
	title=12_BsAs-Madrid

#	Lista de Valores: Archivo con los valores que se usaran para el script principal 
	gmt project -C-58.5258/-34.8553 -E-3.56083/40.47222 -Q -G50 > "tmp_time.txt"

cat << 'EOF' > main.sh
gmt begin
#	Setear la region y proyeccion
	gmt basemap -Rd -JG${MOVIE_COL0}/${MOVIE_COL1}/15c -B+n -Yc -Xc

#	Pintar areas secas (-G). Resolucion datos full (-Df)
	gmt coast -Da -G200 -Sdodgerblue2 -N1/0.2,-
	gmt basemap -Bg0
gmt end
EOF

#	Movie: Crear figuras y animacion
#	Opciones C: Canvas Size. -G: Color fondo
	gmt movie "main.sh" -N$title -T"tmp_time.txt" -C15cx15cx100 -D24 -Vi -Ml,png -Gblack -Fmp4 -Zs

#	Borrar Temporales
	rm tmp_*
#	-------------------------------------------------
#	Apagar (-s) o Hibernar (/h) PC
#	Linux
#	shutdown -h # apagar
#systemctl suspend  #suspender

##  Windows 
#	shutdown -h # Hibernar
#sleep 2h 45m 20s && systemctl suspend -i
