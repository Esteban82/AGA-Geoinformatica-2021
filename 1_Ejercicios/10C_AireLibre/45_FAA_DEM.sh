#!/bin/bash
clear

#	Temas a ver:
#	1. Resamplear grilla (resolución vs espaciado horizontal)

#	Define map
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=45_FAA_DEM
	echo $title

#	Region: Sudamerica y Atlantico Sur
	REGION=-72/-64/-35/-30
#	REGION=AR.A

#	Proyeccion Mercator (M)
	PROJ=M15c

#	Grillas
	DEM=@earth_relief_15s
	URL="https://topex.ucsd.edu/pub/global_grav_1min/grav_31.1.nc"
	FAA=$(gmt which -G $URL) #Descarga el archivo y lo guarda con el nombre original

# 	Nombre archivo de salida
	CUT=tmp_$title.nc
	SHADOW=tmp_$title-shadow.nc

#	Parametros GMT
#	-----------------------------------------------------------------------------------------------------------
#	Sub-seccion MAPA
	gmt set MAP_FRAME_AXES WesN
	gmt set MAP_SCALE_HEIGHT 0.1618
	gmt set MAP_TICK_LENGTH_PRIMARY 0.1

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png
	
#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n

#	Crear Grilla para Sombreado (Hill-shaded). Definir azimuth del sol (-A)
	gmt grdgradient $DEM -G$SHADOW -R$REGION -A270 -Ne0.8 

#	Crear grilla de FAA de mas detalle que Shadow y guardarlo como CUT
	gmt grdsample $FAA -G$CUT -R$SHADOW 

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Crear Paleta de Colores. Paleta Maestra (-C), Definir rango (-Tmin/max/intervalo), CPT continuo (-Z)
	gmt grd2cpt $CUT -Z -L-100/100 -D

#	Crear Imagen a partir de grilla con  paleta de colores y sombreado
#	gmt grdimage $CUT
#	gmt grdimage $CUT -I
	gmt grdimage $CUT -I$SHADOW

#	Agrega escala de colores. (-E triangles). Posicion (-D) (horizontal = h)
	gmt colorbar -DJRM+o0.4/0+w10/0.618c+e -Ba20+l"Anomal\355as Aire Libre (mGal)" -I

#	-----------------------------------------------------------------------------------------------------------
#	Dibujar Bordes Administrativos. N1: paises. N2: Provincias, Estados, etc. N3: limites maritimos (Nborder[/pen])
	gmt coast -Df -N1/thinner
	gmt coast -Df -N2/thinnest,-

#	Dibujar Linea de Costa (W1)
	gmt coast -Df -W1/thinner

#	Dibujar frame
	gmt basemap -Bxaf -Byaf

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo de salida (ps)
gmt end

	rm tmp_* gmt.*
