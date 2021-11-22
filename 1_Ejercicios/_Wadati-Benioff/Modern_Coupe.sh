#!/usr/bin/env bash

#	Define map
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=Modern_Coupe
	echo $title
	
#	Resolucion de la imagen/grilla del mapa base
	RES=02m
	
#	Dimensiones del Grafico (en cm): Ancho (L), Altura inferior (H1) y arriba (H2)
	L=15
	H1=5
	H2=2.5

#	Coordendas iniciales (1) y finales del perfil (2)
	Long1=-74
	Long2=-64
	Lat1=-29
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


#	Perfil: Crear archivo para dibujar perfil (Long Lat)
#	Definir Perfil
	echo $Long1 $Lat1 >  "temp_perfil"
	echo $Long2 $Lat2 >> "temp_perfil"

#	Interpolar: #uestrear perfil con datos de posicion geogr�fica cada 200 m (-I). Lineas siguen circulo m�ximo.
	gmt sample1d "temp_perfil" -I0.2k > "temp_sample1d"

#	Distancia: Agregar columna (3a) con distancia del perfil en km (-G+a+uk) calculadas en base al elipsoide (-je)
	gmt mapproject "temp_sample1d" -G+a+uk -je > "temp_track"

#	Muestrear grilla (-G) en las posiciones geograficas del perfil. Datos en 4a columna.
	gmt grdtrack "temp_track" -G$DEM > "temp_data"

#	Informacion: Ver datos del Archivo para crear el grafico. 3a Columna datos en KM. 4a Columna datos de Topografia.
	echo N datos   LongMin/Max    LatMin/Max    Distancia Perfil      TopoMin/Max
	gmt info "temp_data"

	gmt mapproject "temp_perfil" -G
#	KM="gmt info 'gmt mapproject "temp_perfil" -G+uk'

#	Definir KM (longitud) y rango de alturas de los datos de terminal
	KM=1052.32
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

#	Filtrar y Proyectar los Sismos al perfil/circulo m�ximo
	gmt project "E:\Facultad\Datos_Geofisicos\Sismicidad\USGS\query_*.csv" -h1 -i2,1,3 -C$Long1/$Lat1 -E$Long2/$Lat2 -W-$Dist_Perfil/${Dist_Perfil}k -Lw -S -Q > "temp_sismos_project" -fg

#	Plotear Sismos en perfil distancia vs profundidad
	gmt plot "temp_sismos_project" -C -Sc0.05c -i3,2,2

#	Filtrar Mecanismos Focales
#	gmt select "Mecanismos_Focales\CMT_*.txt" > "temp_CMT" -L"temp_perfil"+d%Dist_Perfil%k+p -fg 

#	Plotear Mecanismos Focales
#	gmt pscoupe -R -J -O -K "temp_CMT" >> $OUT -Sd0.15/0 -Gred -M -Aa%Long1%/%Lat1%/%Long2%/%Lat2%/90/10000/%DepthMin%/%DepthMax%f -Q
	gmt coupe Mecanismos_Focales/CMT_* -Sd0.15/0 -Gred -M -Aa$Long1/$Lat1/$Long2/$Lat2/90/100/$DepthMin/$DepthMax+f -Q

#	*****************************************************************************************************************
#	Calcular Exageracion Vertical
#	--------------------------------------------------------------
#	Factor escala para eje Horizontal(FH) y Vertical (FV) para convertir entre unidades del gr�fico (cm) y reales (m, km). 
#	km-cm=100000, m-cm=100
	FH=100000
	FV=100000

# 	Guardar Variables para calculos
	echo $DepthMax > "temp_Max"
	echo $DepthMin > "temp_Min"
	echo $H1  > "temp_H"
	echo $KM  > "temp_KM"
	echo $L   > "temp_L"

#	Calcular Exageracion Vertical y Graficar en el perfil
	gmt math "temp_KM" "temp_L" DIV $FH MUL = "temp_Esc_Hz"
	gmt math "temp_Max" "temp_Min" SUB "temp_H" DIV $FV MUL = "temp_Esc_Ve"
	echo Exageracion Vertical =
	gmt math "temp_Esc_Hz" "temp_Esc_Ve" DIV =
#	pause

#	AGREGAR Datos de la terminal
#	echo Ex.Vert. = 1.17           | gmt text -F+cBR+f9p -Gwhite -W1

#	*********************************************************************************************************
#	GRAFICO SUPERIOR
#	*********************************************************************************************************
	
#	Hacer Grafico (psbasemap) y dibujar variables (psxy)
#	-----------------------------------------------------------------------------------------------------------
	REGION=0/$KM/$TopoMin/$TopoMax

#	Crear Grafico
#	gmt psxy -JX$L/$H2 -R$REGION -T -K -O >> $OUT -Y$H1
	gmt basemap -R$REGION -JX$L/-$H2 -B+n -Y$H1

#	Dibujar Ejes XY
	gmt basemap -Bxf -Byaf+l"Elevaciones (km)" --MAP_FRAME_AXES=wESn

#	Dibujar datos de Distancia y elevaciones (pasado de m a km) (columnas 3 y 4; -i2,3)
	gmt plot "temp_data" -W0.5,darkblue -i2,3+s0.001

#	*****************************************************************************************************************
#	Calcular Exageracion Vertical
#	--------------------------------------------------------------
#	Factor escala para eje Horizontal(FH) y Vertical (FV) para convertir entre unidades del gr�fico (cm) y reales (m, km). 
#	km-cm=100000, m-cm=100
	FH=100000
	FV=100000

# 	Guardar Variables para calculos
	echo $TopoMax > "temp_Max"
	echo $TopoMin > "temp_Min"
	echo $H2  > "temp_H"
	echo $KM  > "temp_KM"
	echo $L   > "temp_L"

#	Mostrar en Terminal
	gmt math "temp_KM" "temp_L" DIV $FH MUL = "temp_Esc_Hz"
	gmt math "temp_Max" "temp_Min" SUB "temp_H" DIV $FV MUL = "temp_Esc_Ve"
	echo Exageracion Vertical =
	gmt math "temp_Esc_Hz" "temp_Esc_Ve" DIV =
#	pause

#	Datos terminal
	echo Ex.Vert. = 14.6  | gmt text -F+cBR+f9p -Gwhite -W1

#	*******************************************************************

#	Coordenadas Perfil (A, A')
	echo A  | gmt text -F+cTL+f12p -Gwhite -W1
	echo A\'| gmt text -F+cTR+f12p -Gwhite -W1

#	Convert PostScript (PS) into another format: EPS (e), PDF (f), JPEG (j), PNG (g), TIFF (t)
#	-----------------------------------------------------------------------------------------------------------
#	gmt psxy -J -R -O -T >> $OUT
#	gmt psconvert $OUT -A -Tg -Z
gmt end

#	Borrar archivos temporales
#	-----------------------------------------------------------------------------------------------------------
	rm gmt.* temp_*
