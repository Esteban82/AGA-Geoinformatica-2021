#!/usr/bin/env bash

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=Hemisferico
	echo $title

#	Proyecciones acimutales requieren 3 parametros + 1 opcional (lon0/lat0[/horizon]/width
#	L(a)mbert Equal Area; (S)tereographic; Orto(g)rafica; (E)quidistante
#	PROJ=G-65/-30/90/15c
#	PROJ=G${MOVIE_COL0}/-30/15c
	PROJ=G${MOVIE_COL0}/-30/${MOVIE_WIDTH}

#	Region geografica del mapa (W/E/S/N) d=-180/180/-90/90 g=0/360/-90/90
	REGION=d

#	Parametros por Defecto
#	-----------------------------------------------------------------------------------------------------------
#	Sub-seccion GMT
	gmt set GMT_VERBOSE w

#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png

#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n -Yc -Xc

#	Pintar areas secas (-G). Resolucion datos full (-Df)
	gmt coast -Df -G200

#	Dibujar Antartida_Argentina. Los meridianos 74° Oeste y 25° Oeste y el paralelo 60° Sur y el Polo Sur.
#	Dibujar archivo con borde (-Wpen), Relleno (-Gfill), Lineas siguen meridianos (-Am), Cerrar polígonos (-L)
	gmt plot -L -Am -Grosybrown2 -W0.25  <<- EOF
	-74 -60
	-74 -90
	-25 -60
	EOF

#	Pintar areas húmedas: Oceanos (-S) y Lagos y Rios (-C)
	gmt coast -Sdodgerblue2 -C200

#	Dibujar Paises (1 paises, 2 estados/provincias en America, 3 limite maritimo)
	gmt coast -N1/0.2,-

#	Dibujar Linea de Costa
	#gmt coast -Df -W1/

#	Resaltar paises DCW (-E). AR: Argentina soberana, FK: Malvinas, GS: Georgias del Sur. Pintar de color (+g), Dibujar borde (+p). 
	gmt coast -EAR,FK,GS+grosybrown2+p
	
#	Dibujar marco del mapa
	gmt basemap -Bg

#	Dibujar paralelos principales y meridiano de Greenwich a partir del archivo paralelos.txt -Am (lineas siguen meridianos)
#	gmt plot 'Paralelos.txt' -Ap -W0.50,.-

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
gmt end # show