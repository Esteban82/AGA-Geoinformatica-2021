#!/bin/bash
clear

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------

#	Titulo del mapa
	title=Mapa_Perfil
	echo $title

#	Region: Mar Argentino
	REGION=-78/-44/-37/-27

#	Proyeccion Mercator (M)
	PROJ=M15c

#	Base de datos de GRILLAS
#	GRA="E:\Facultad\Datos_Geofisicos\Gravimetria\Sandwell-Smith\Datos\grav_29.1.img"
	DEM=@earth_relief_02m

# 	Nombre archivo de salida
	CUT=tmp_$title.nc
	SHADOW=tmp_$title-shadow.nc

	gmt set MAP_FRAME_AXES WesN
	gmt set FORMAT_GEO_MAP ddd:mm:ssF

#	Resolucion de la grilla (y del perfil)
	RES=15s

#	Base de datos de GRILLAS
	DEM=@earth_relief_$RES

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png

#	Abrir archivo de salida (ps)
	gmt basemap -R$REGION -J$PROJ -B+n

#	Mapa Base
#	********************************************************************
#	Recortar Grilla Topografica
	gmt grdcut $DEM -G$CUT -R$REGION

#	Crear Imagen a partir de grilla con sombreado
	gmt grdimage $CUT -Cgeo -I

#	Agregar escala vertical a partir de CPT (-C). Posicion (x,y) +wlargo/ancho. Anotaciones (-Ba). Leyenda (+l). 
	gmt colorbar -Dx15.5/0+w5/0.618c -C -Ba+l"Elevaciones (km)" -I -W0.001

#	Dibujar frame
	gmt basemap -Bxaf -Byaf

#	********************************************************************
#	Perfil 
#	-----------------------------------------------------------------------------------------------------------
#	Perfil: Crear archivo para dibujar perfil (Long Lat)
	cat > tmp_line <<- END
	-76 -32
	-46 -32
	END

#	Crear datos de perfil (Interpolar, agregar distancia y alturas)
#	gmt sample1d tmp_line -I$RES -fg | gmt mapproject -G+uk | gmt grdtrack -G$CUT > tmp_data
	gmt sample1d tmp_line -I$RES -fg | gmt grdtrack -G$CUT > tmp_data

#	Dibujar Perfil
#	gmt plot tmp_line -W0.5,black

#	Dibujar Perfil en el mapa
	gmt wiggle tmp_data -Gred+p -Gblue+n -Z3000 -DjRB+o0.1/0.1+w500+lm -t50 -T -W

#	********************************************************************

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo de salida (ps)
gmt end

#	rm tmp_* gmt.*
