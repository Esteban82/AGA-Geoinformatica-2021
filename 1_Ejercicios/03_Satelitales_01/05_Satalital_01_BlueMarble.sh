#!/usr/bin/env bash
clear

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------

	RES=05m

#	Mosaicos de la NASA: BlackMarble (night) o BlueMarble (day)
	daytime=day
#	daytime=night

#	Titulo del mapa
	title=EJ2.4_Marble_${daytime}_$RES
	echo $title

#	Mapamundis. Mollweide (M), Robinson (N), Eckert VI (Ks)
	PROJ=W-65/15c
#	PROJ=N-65/15c
#	PROJ=Ks-65/15c

#	Proyecciones acimutales requieren 3 parametros + 1 opcional (lon0/lat0[/horizon]/width
#	L(a)mbert Equal Area; (S)tereographic; Orto(g)rafica; (E)quidistante
#	PROJ=S-65/0/90/15c
#	PROJ=G-65/0/90/15c
#	PROJ=G-65/-30/90/15c
#	PROJ=S-65/-30/90/15c
#	PROJ=G-65/30/90/15c

#	Region geografica del mapa (W/E/S/N) d=-180/180/-90/90 g=0/360/-90/90
	REGION=d
#	REGION=-100/30/-90/20	
	REGION=-110/30/-90/20

#	Resolucion Datos de GSHHS: (c)ruda, (l)ow, (i)ntermdiate, (h)igh, (f)ull o (a)uto
	D=a

#	Parametros por Defecto
#	-----------------------------------------------------------------------------------------------------------
#	Sub-seccion GMT
	gmtset GMT_VERBOSE w

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png

#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n

#	Graficar Imagen Satelital
	gmt grdimage "@earth_${daytime}_$RES"

#	Dibujar Paises (1 paises, 2 estados/provincias en America, 3 limite maritimo)
	gmt coast -N1/0.2,- 

#	Dibujar Linea de Costa
	gmt coast -D$D -W1/ 

#	Dibujar marco del mapa 
	gmt basemap -B0

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
gmt end show

# Probar cambiar la resolución de la imagen satelital, cambiar a la imagen de noche (black marble) y cambiar la region geografica. 