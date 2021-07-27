#!/bin/bash

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=EJ1.5_Modern_MapaPolitico_Argentina
	echo $title

#	Region: Buenos Aires
	REGION=-64/-42/-56/-33r
#	Region: Argentina
#	REGION=-78/-50/-56/-21
	REGION=-81/-55/-53/-21r

#	Proyecciones Cilindricas: 
#	(C)assini, C(y)lindrical equal area: Lon0/lat0/Width
#	Miller cylindrical (J): Lon0/Width
#	(M)ercartor, E(q)udistant cilindrical, (T)ransverse Mercator: (Lon0(/Lat0/))Width
#	(U)TM: Zone/Width
#	PROJ=C-65/-35/13c
#	PROJ=J-65/13c
	PROJ=T-60/-30/13c
#	PROJ=M15c
#	PROJ=U-20/13c

#	Parametros por Defecto
#	-----------------------------------------------------------------------------------------------------------
#	Sub-seccion GMT
	gmtset GMT_VERBOSE w

#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
	gmt begin $title png

#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n

#	Pintar areas húmedas: Oceanos (-S) y Lagos (-Cl/) y Rios-Lagos (-Cr/)
	color=dodgerblue2
	gmt coast -Df -S$color -Cl/green -Cr/red

#	Resaltar paises DCW (AR: Argentina soberana, FK: Malvinas, GS: Georgias del Sur y Sandwich del Sur)
	gmt coast -EAR,FK,GS+grosybrown2+p

#	Dibujar Bordes Administrativos. N1: paises. N2: Provincias, Estados, etc. N3: limites marítimos (Nborder[/pen])
	gmt coast -Df -N1/0.75
	gmt coast -Df -N2/0.25,-.

#	Dibujar Linea de Costa (level/, where level is 1-4 and represent coastline, lakeshore, island-in-lake shore, and lake-in-island-in-lake shore)
	gmt coast -Df -W1/0.25

#	Datos Instituto Geografico Nacional (IGN)
#	-----------------------------------------------------------------------------------------------------------
#	Descripcion psxy: Lineas (-Wpen), Puntos (-Ssímbolo/size), Relleno simbolos o polígonos (-Gfill).
#	-G: pinta el area definida por los puntos.
#	-G y -W: Pinta el área y dibuja las lineas del borde
#	-W: Dibuja las lineas del borde 
#	-S: dibuja los simbolos sin relleno
#	-S -G: dibuja simbolos con relleno
#	-S -W -G: dibuja simbolos con relleno y borde

#	Cursos y Cuerpos de Agua
	gmt plot "E:\Facultad\Datos_Geofisicos\IGN\1_GMT\004_Cuerpos_De_Agua.gmt" -G$color
	gmt plot "E:\Facultad\Datos_Geofisicos\IGN\1_GMT\001_Cursos_De_Agua.gmt" -Wfaint,blue

#	Departamentos
	gmt plot "E:\Facultad\Datos_Geofisicos\IGN\1_GMT\Departamentos.gmt" -Wthinnest,-

#	Limites administrativos
	gmt plot "E:\Facultad\Datos_Geofisicos\IGN\1_GMT\limites_politico_administrativos.gmt" -Wthinner

# 	Red vial y ferroviaria
#	gmt plot "E:\Facultad\Datos_Geofisicos\IGN\1_GMT\002_Red_Vial.gmt"        -Wthin,blue
	gmt plot "E:\Facultad\Datos_Geofisicos\IGN\1_GMT\003_Red_Ferroviaria.gmt" -Wthin,red

#	Pueblos y Ejidos Urbanos. -SsimboloTamaño. Simbolos: A (star), C (Círculo), D (Diamante), G (octagono), H (hexagono), I (triangulo invertido), N (pentagono), S (cuadrado), T (triangulo).
#	Tamaño: diámetro del círculo (Mayuscula: misma área que el circulo; Minúscula (diámetro del círculo que abarca a las símbolos)
	gmt plot  "E:\Facultad\Datos_Geofisicos\IGN\1_GMT\005_Centros_Poblados.gmt" -Sc0.05 -Ggreen -Wred
	gmt plot  "E:\Facultad\Datos_Geofisicos\IGN\1_GMT\010_Ejidos_Urbanos.gmt"   -Wfaint -Ggreen

#	Dibujar frame
	gmt basemap -Baf

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
	gmt end show

	rm temp_* gmt.*

#	Ejercicios Sugeridos:
#	1. Modificar REGION para que abarque a Europa.
#	2. Modificar el color de los rios (variable $color).
#	3. Modificar las lineas de os rios (ancho, estilo de linea).
