#!/usr/bin/env bash

#	Define map
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=41_Perfil2
	echo $title
	
#	Resolucion de la imagen/grilla del mapa base
	RES=02m
	
#	Dimensiones del Grafico (en cm): Ancho (L), Altura inferior (H1) y arriba (H2)
	L=15
	H1=5
	H2=2.5

#	Coordendas iniciales (1) y finales del perfil (2)
	Long1=-74
	Lat1=-29

	Long2=-64
	Lat2=-33

#	Distancia perpendicular al pefil (en km) y rango de profundidades del perfil (en km)
	Dist_Perfil=100
	DepthMin=0
	DepthMax=300

#	Base de datos de GRILLAS
	DEM=@earth_relief_$RES

#	Parametros Generales
#	-----------------------------------------------------------------------------------------------------------
	gmt set FONT_ANNOT_PRIMARY 8,Helvetica,black
	gmt set FONT_LABEL 8,Helvetica,black
	gmt set FONT_TITLE 10,4,Black
	gmt set FORMAT_GEO_MAP ddd:mm:ssF
	gmt set GMT_VERBOSE w
	gmt set MAP_FRAME_AXES WesN
	gmt set MAP_FRAME_TYPE fancy+
	gmt set MAP_FRAME_WIDTH 1c
	gmt set MAP_GRID_CROSS_SIZE_PRIMARY 0
	gmt set MAP_SCALE_HEIGHT 0.1618
	gmt set MAP_TICK_LENGTH_PRIMARY 0.1
	gmt set PROJ_LENGTH_UNIT cm

#	*********************************************************************************************************
#	GRAFICO INFERIOR
#	*********************************************************************************************************
gmt begin $title png

#	Calcular distancia del perfil
	KM=$(echo $Long1 $Lat1 | gmt mapproject -G$Long2/$Lat2+uk -o2)


#	Informacion: Ver datos del Archivo para crear el grafico. 3a Columna datos en KM. 4a Columna datos de Topografia.
#	echo N datos   LongMin/Max    LatMin/Max    Distancia Perfil      TopoMin/Max
#	gmt info "temp_data"

#	gmt mapproject "temp_perfil" -G
#	KM="gmt info 'gmt mapproject "temp_perfil" -G+uk'

#	Definir KM (longitud) y rango de alturas de los datos de terminal
#	KM=1052.32
	TopoMin=-7
	TopoMax=5
	
#	Grafico inferior (Longitud vs Profundidad) con sismos y mecanismos focales
#	-----------------------------------------------------------------------------------------------------------

#	Datos del perfil segun gmtinfo
	REGION=0/$KM/$DepthMin/$DepthMax

#	Crear Grafico
#	gmt psxy -JX$L/-$H1 -R$REGION -T -K -P > $OUT
	gmt basemap -R$REGION -JX$L/-$H1 -B+n # -Y$Y -X$X

#	Eje X (Sn) e Y
	gmt basemap -Bxaf+l"Distancia (km)" -Byaf+l"Profundidad (km)" -BwESn

#	Filtrar Sismos y Mecanismos Focales por Region2
#	********************************************************************

#	Crear paleta de colores para magnitud de sismos
	gmt makecpt -Crainbow -T0/300 -I

#	Combinar archivos con datos de sismicidad en un unico archivo.
	cat Datos/query_* > tmp_sismos.txt

#	Filtrar y Proyectar los Sismos al perfil/circulo m�ximo
#	gmt project "E:\Facultad\Datos_Geofisicos\Sismicidad\USGS\query_*.csv" -h1 -i2,1,3 -C$Long1/$Lat1 -E$Long2/$Lat2 -W-$Dist_Perfil/${Dist_Perfil}k -Lw -S -Q > "temp_sismos_project" -fg
	gmt project "Datos_Geofisicos/query_*.csv" -h1 -i2,1,3 -C$Long1/$Lat1 -E$Long2/$Lat2 -W-$Dist_Perfil/${Dist_Perfil}k -Lw -S -Q > "temp_sismos_project" 


#	Plotear Sismos en perfil distancia vs profundidad
	gmt plot "temp_sismos_project" -C -Sc0.05c -i3,2,2

#	Filtrar Mecanismos Focales
#	gmt select "Mecanismos_Focales\CMT_*.txt" > "temp_CMT" -L"temp_perfil"+d%Dist_Perfil%k+p -fg 

#	Plotear Mecanismos Focales
#	gmt pscoupe -R -J -O -K "temp_CMT" >> $OUT -Sd0.15/0 -Gred -M -Aa%Long1%/%Lat1%/%Long2%/%Lat2%/90/10000/%DepthMin%/%DepthMax%f -Q
	gmt coupe Mecanismos_Focales/CMT_* -Sd0.15/0 -Gred -M -Aa$Long1/$Lat1/$Long2/$Lat2/90/100/$DepthMin/$DepthMax+f -Q

#	*********************************************************************************************************
#	GRAFICO SUPERIOR
#	*********************************************************************************************************
#	Perfil: Crear archivo para dibujar perfil (Long Lat)
#	cat > tmp_line <<- END
#	$Long1 $Lat1
#	$Long2 $Lat2
#	END

#	Interpolar: agrega datos en el perfil cada 0.2 km (-I).
#	gmt sample1d tmp_line -I$RES > tmp_sample1d -fg

#	Crear variable con region geografica del perfil
#	REGION=$(gmt info tmp_sample1d -I+e0.1)
	
#	Distancia: Agrega columna (3a) con distancia del perfil en km (-G+uk)
#	gmt mapproject tmp_sample1d -G+uk > tmp_track

#	Agrega columna (4) con datos extraidos de la grilla -G (altura) sobre el perfil
#	gmt grdtrack tmp_track -G$DEM $REGION > tmp_data

#	Datos para el perfil:
#	-------------------------------------------------
#	Altura (m) minima y maxima:
	#Min=-6200
	#Max=5300
#	Min=$(gmt info "tmp_data" -C -o6)
#	Max=$(gmt info "tmp_data" -C -o7)
#	#Min=$(gmt info "tmp_data" -C -o6 | gmt math -+s0.001)
#	#Max=$(gmt info "tmp_data" -C -o7+s0.001)
	
#	Crear Grafico con desplazamiento en Y
#	gmt basemap -R0/$KM/$Min/$Max -JX$L/-$H2 -B+n -Y$H1

#	Dibujar Ejes XY
#	gmt basemap -Bxf -Byaf+l"Elevaciones (km)" -BwESn

#	Dibujar datos de Distancia y elevaciones (pasado de m a km) (columnas 3 y 4; -i2,3)
#	gmt plot "tmp_data" -W0.5,darkblue -i2,3 #+s0.001

#	Coordenadas Perfil (A, A')
#	echo A  | gmt text -F+cTL+f12p -Gwhite -W1
#	echo A\'| gmt text -F+cTR+f12p -Gwhite -W1

#   ----------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
gmt end

#	rm tmp_* gmt.*
