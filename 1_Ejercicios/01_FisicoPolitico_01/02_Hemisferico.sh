#!/usr/bin/env bash

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=02_Hemisferico
	echo $title

#	Proyecciones acimutales requieren 3 parametros + 1 opcional (lon0/lat0[/horizon]/width
#	L(a)mbert Equal Area; (S)tereographic; Orto(g)rafica; (E)quidistante
	PROJ=S-65/-30/90/15c
	PROJ=G-65/-30/90/15c

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
	gmt basemap -R$REGION -J$PROJ -B+n

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
#	gmt coast -Sdodgerblue2
	gmt coast -Sdodgerblue2 -C200
#	gmt coast -Swhite -C200

#	Dibujar Paises (1 paises, 2 estados/provincias en America, 3 limite maritimo)
	gmt coast -N1/0.2,-

#	Dibujar Linea de Costa
	gmt coast -Df -W1/

#	Resaltar paises DCW (-E). Codigos ISO 3166-1 alph-2. (AR: Argentina soberana, FK: Malvinas, GS: Georgias del Sur). Pintar de color (+g), Dibujar borde (+p). 
	gmt coast -EAR,FK,GS+grosybrown2+p
	
#	Resaltar provincias DCW (-E). Codigos ISO 3166-2:AR (X: Cordoba, L: La Pampa, J: San Juan).
#	gmt coast -EAR.X,AR.L,AR.J+gorange+p

#	Dibujar marco del mapa 
	gmt basemap -Bg

#	Dibujar paralelos principales y meridiano de Greenwich a partir del archivo paralelos.txt -Am (lineas siguen meridianos)
	gmt plot 'Paralelos.txt' -Ap -W0.50,.-

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
gmt end show

#	Borrar archivos tempostales
	rm gmt.*

#	Ejercicios Sugeridos
#    ***********************************************************************
#	1. Cambiar el horizonte del mapa a 60º (horizon, linea 11).
#	2. Centrar mapa en Moscú (Long0: 37.617778. Lat0: 55.755833) y en otra ciudad (buscar en internet sus coordenadas; linea 11 o 12).
#	3. Cambiar la resolucion de la base de datos de GSHHG a (c)ruda, (l)ow, (m)edium, (h)igh, (f)ull (linea 30).
#	4. Resaltar otros países y 2 continentes (=AF, =AN, =AS, =EU, =OC, =NA o =SA) con distintos colores. Buscar código ISO y definir color (linea 52).
#	5. Resaltar 2 provincias Argentinas (linea 55).