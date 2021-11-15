#!/bin/bash
clear

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Resolucion de Blue/Black Marble: 01d, 30m, 20m, 15m, 10m, 06m, 05m, 04m, 03m, 02m, 01m, 30s
	RES=05m

#	Mosaicos de la NASA: BlackMarble (night) o BlueMarble (day)
	daytime=day
#	daytime=night

#	Titulo del mapa
	title=Marble_Intes_${daytime}_$RES
	echo $title

#	Mapamundis. Mollweide (M), Robinson (N), Eckert VI (Ks)
#	PROJ=W-65/15c
#	PROJ=N-65/15c
#	PROJ=Ks-65/15c
#	PROJ=M15c

#	Proyecciones acimutales requieren 3 parametros + 1 opcional (lon0/lat0[/horizon]/width
#	L(a)mbert Equal Area; (S)tereographic; Orto(g)rafica; (E)quidistante
#	PROJ=S-65/0/90/15c
#	PROJ=G-65/0/90/15c
	PROJ=G-65/-30/90/15c
#	PROJ=S-65/-30/90/15c
#	PROJ=G-65/30/90/15c

#	Region geografica del mapa (W/E/S/N) d=-180/180/-90/90 g=0/360/-90/90
	REGION=d
#	REGION=-100/30/-90/20	
#	REGION=AR

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

#	Crear grilla para efecto de sombreado a partir del DEM
	gmt grdgradient "@earth_relief_$RES" -Nt1 -A45 -G"temp_intens.nc"

#	Graficar Imagen Satelital
#	gmt grdimage "@earth_${daytime}_$RES" 
	gmt grdimage "@earth_${daytime}_$RES" -I"temp_intens.nc"

#	Dibujar Paises (1 paises, 2 estados/provincias en America, 3 limite maritimo)
	gmt coast -N1/0.2,- 

#	Dibujar Linea de Costa
	gmt coast -W1/

#	Dibujar marco del mapa 
	gmt basemap -B0

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
	gmt end #show

	rm temp_* gmt.*