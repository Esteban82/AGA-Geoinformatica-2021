#!/usr/bin/env bash

#	Define map
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=41_Perfil_2
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
	gmt set GMT_VERBOSE w

#	*********************************************************************************************************
#	GRAFICO INFERIOR
#	*********************************************************************************************************
gmt begin $title png

#	Calcular largo (en km) del perfil y crear variable
	KM=$(echo $Long1 $Lat1 | gmt mapproject -G$Long2/$Lat2+uk -o2)

#	Grafico inferior (Longitud vs Profundidad) con sismos y mecanismos focales
#	-----------------------------------------------------------------------------------------------------------
#	Crear Grafico
	gmt basemap -R0/$KM/$DepthMin/$DepthMax -JX$L/-$H1 -B+n

#	Eje X (Sn) e Y
	gmt basemap -Bxaf+l"Distancia (km)" -Byaf+l"Profundidad (km)" -BwESn

#	Filtrar Sismos y Mecanismos Focales por Region2
#	********************************************************************
#	Filtrar y Proyectar los Sismos al perfil/circulo maximo
	gmt project Datos/query_*.csv -h1 -i2,1,3 -C$Long1/$Lat1 -E$Long2/$Lat2 -W-$Dist_Perfil/${Dist_Perfil}k -Lw -S -Q > "tmp_sismos_project" 

#	Crear paleta de colores para magnitud de sismos
	gmt makecpt -Crainbow -T$DepthMin/$DepthMax -I

#	Plotear Sismos en perfil distancia vs profundidad
	gmt plot "tmp_sismos_project" -C -Sc0.05c -i3,2,2

#	Filtrar Mecanismos Focales
#	gmt select "Mecanismos_Focales\CMT_*.txt" > "temp_CMT" -L"temp_perfil"+d%Dist_Perfil%k+p -fg 

#	Plotear Mecanismos Focales
	gmt coupe Mecanismos_Focales/CMT_* -Sd0.15/0 -Gred -M -Aa$Long1/$Lat1/$Long2/$Lat2/90/100/$DepthMin/$DepthMax+f -Q

#	*********************************************************************************************************
#	GRAFICO SUPERIOR
#	*********************************************************************************************************
#	Perfil: Crear archivo para dibujar perfil (Long Lat)
	cat > tmp_line <<- END
	$Long1 $Lat1
	$Long2 $Lat2
	END

#	Interpolar: agrega datos en el perfil cada 0.2 km (-I).
	gmt sample1d tmp_line -I$RES > tmp_sample1d -fg

#	Crear variable con region geografica del perfil
	REGION=$(gmt info tmp_sample1d -I+e0.1)
	
#	Distancia: Agrega columna (3a) con distancia del perfil en km (-G+uk)
	gmt mapproject tmp_sample1d -G+uk > tmp_track

#	Agrega columna (4) con datos extraidos de la grilla -G (altura) sobre el perfil
	gmt grdtrack tmp_track -G$DEM $REGION > tmp_data

#	Datos para el perfil:
#	-------------------------------------------------
#	Altura (m) minima y maxima:
	#Min=-6200
	#Max=5300

#	gmt info tmp_data -C -o6
#	gmt info tmp_data -C -i3 -o0
#	gmt info tmp_data -C -i3+d1000 -o0

	Min=$(gmt info tmp_data -C -i3+d1000 -o0)
	Max=$(gmt info tmp_data -C -i3+d1000 -o1)
	
#	Crear Grafico con desplazamiento en Y
	gmt basemap -R0/$KM/$Min/$Max -JX$L/-$H2 -B+n -Y$H1

#	Dibujar Ejes XY
	gmt basemap -Bxf -Byaf+l"Elevaciones (km)" -BwESn

#	Dibujar datos de Distancia y elevaciones (pasado de m a km) (columnas 3 y 4; -i2,3)
	gmt plot "tmp_data" -W0.5,darkblue -i2,3+d1000

#	Coordenadas Perfil (A, A')
	echo A  | gmt text -F+cTL+f12p -Gwhite -W1
	echo A\'| gmt text -F+cTR+f12p -Gwhite -W1

#   ----------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
gmt end

	rm tmp_* gmt.*
