#!/bin/bash
clear

#	Temas a ver:
#	1. Graficar varios perfiles

#	Define map
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=46_Perfiles_2
	echo $title

#	Dimensiones del Grafico: Longitud (L), Altura (H).
	L=15
	H=5

#	Resolucion de la grilla (y del perfil)
	RES=01m

#	Base de datos de GRILLAS
	DEM=@earth_relief_$RES
	URL="https://topex.ucsd.edu/pub/global_grav_1min/grav_31.1.nc"
	FAA=$(gmt which -G $URL) #Descarga el archivo y lo guarda con el nombre original

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png

#	Calcular Distancia a lo largo de la linea y agregar datos geofisicos
#	-----------------------------------------------------------------------------------------------------------
#	Perfil: Crear archivo para dibujar perfil (Long Lat)
	cat > tmp_line <<- END
	-76 -32
	-46 -32
	END

#	Interpolar: agrega datos en el perfil cada 0.2 km (-I).
	gmt sample1d tmp_line -I$RES > tmp_sample1d -fg

#	Crear variable con region geografica del perfil
	REGION=$(gmt info tmp_sample1d -I+e0.1)
	echo $REGION

#	Distancia: Agrega columna (3a) con distancia del perfil en km (-G+uk)
	gmt mapproject tmp_sample1d -G+uk > tmp_track

#	Agrega columna (4) con datos extraidos de la grilla -G (altura) sobre el perfil
#	gmt grdtrack tmp_track -G$DEM $REGION > tmp_data
	gmt grdtrack tmp_track -G$DEM -G$FAA $REGION > tmp_data
		
#	Hacer Grafico y dibujar perfil
#	-----------------------------------------------------------------------------------------------------------
#	Informacion para crear el grafico. 3a Columna datos en km. 4a Columna datos de Topografia.
	gmt info tmp_data

#	Datos para el perfil:
#	-------------------------------------------------
#	Distancia del Perfil (km):
#	KM=2825.5
	KM=$(gmt info tmp_data -C -o5)

#	Altura (m) minima y maxima:
#	Topo_Min=$(gmt info "tmp_data" -C -i2 -o0)
#	Topo_Max=$(gmt info "tmp_data" -C -i2 -o1)
#	Grav_Min=$(gmt info "tmp_data" -C -i3 -o0)
#	Grav_Max=$(gmt info "tmp_data" -C -i3 -o1)

#	Datos del perfil. Min y Max de altura/gravedad
	Topo=$(gmt info "tmp_data" -C -i3 -o0)/$(gmt info "tmp_data" -C -i3 -o1)
	Grav=$(gmt info "tmp_data" -C -i4 -o0)/$(gmt info "tmp_data" -C -i4 -o1)

#	Crear Grafico
	gmt basemap -JX$L/$H -R0/$KM/$Topo -B+n

#	Dibujar Eje X (Sn)
	gmt basemap -Bxaf+l"Distancia (km)" -BSn

#	Dibujar Eje Y y datos de columnas 3a y 4a (-i2,3)
	gmt plot -R0/$KM/$Topo tmp_data -W0.5,blue -i2,3 
	gmt plot -R0/$KM/$Grav tmp_data -W0.5,red  -i2,4 

#	Dibujar Ejes de datos
	gmt basemap -R0/$KM/$Topo -Byag+l"Elevaciones (m)"              -BW --FONT_ANNOT_PRIMARY=8,Helvetica,blue
	gmt basemap -R0/$KM/$Grav -Bya+l"Anomal\355a Aire Libre (mGal)" -BE --FONT_ANNOT_PRIMARY=8,Helvetica,red
	
#	Coordenadas Perfil (E, O)
	echo O | gmt text -F+cTL+f14p -Gwhite -W1
	echo E | gmt text -F+cTR+f14p -Gwhite -W1

#   ----------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
gmt end

	rm tmp_*
