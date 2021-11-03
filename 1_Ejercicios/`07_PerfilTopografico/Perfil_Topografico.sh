#!/bin/bash
clear

#	Define map
#	-----------------------------------------------------------------------------------------------------------

#	Titulo del mapa
	title=Perfil_Topografico
	echo $title
	
#	Dimensiones del Grafico: Longitud (L), Altura (H).
	L=15
	H=5

#	Base de datos de GRILLAS
	DEM="@earth_relief_30s"

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
	gmt sample1d temp_line -I0.2k > tmp_sample1d -fg

#	Distancia: Agrega columna (3a) con distancia del perfil en km (-G+uk)
	gmt mapproject tmp_sample1d -G+uk > tmp_track

#	Agrega columna (4) con datos extraidos de la grilla -G (altura) sobre el perfil
	gmt grdtrack tmp_track -G$dem > tmp_data -fg

#	Informacion: Ver datos del Archivo para crear el grafico. 3a Columna datos en km. 4a Columna datos de Topografia.
	echo Distancia del Perfil (km):
	gmt info "temp_data" -C -o5
	echo Altura (m) minima y maxima:
	gmt info "temp_data" -C -o6,7
#	pause

#	Hacer Grafico (psbasemap) y dibujar variables (psxy)
#	-----------------------------------------------------------------------------------------------------------
#	Datos del perfil segun gmtinfo
	KM=2825.5
	Min=-6200
	Max=5300

#	Crear Grafico
	gmt psxy -JX$L/$H -R0/$KM/$Min/$Max -T

#	Dibujar Eje X (Sn)
	gmt basemap -Bxaf+l"Distancia (km)" -BSn

#	Dibujar Eje Y y datos de columnas 3a y 4a (-i2,3)
	gmt plot tmp_data -W0.5,blue -Byafg+l"Altura (m)" -i2,3 -BwE

#	Coordenadas Perfil (E, O)
	echo O | gmt text -F+cTL+f14p -Gwhite -W1
	echo E | gmt text -F+cTR+f14p -Gwhite -W1

#	Agregar Escala (grafica) Horizontal y Vertical (+v) -LjCB+w40+lkm+o0/0.5i
	gmt basemap -LjCB+w1000+lm+o1.2/0.67+v -Vi
	gmt basemap -LjCB+w200+lkm+o0/0.5

#	*****************************************************************************************************************
#	Calcular Escala (numerica) Vertical y Horizontal, y Exageracion Vertical
#	--------------------------------------------------------------
#	Factor escala para eje Horizontal(FH) y Vertical (FV) para convertir entre unidades del gr�fico (cm) y reales (m, km). 
#	km-cm=100000, m-cm=100
	FH=100000
	FV=100

# 	Guardar Variables para calculos
	echo $Max > "temp_Max"
	echo $Min > "temp_Min"
	echo $H   > "temp_H"
	echo $KM  > "temp_KM"
	echo $L   > "temp_L"

#	Mostrar en Terminal
#	--------------------------------------------------------------
	echo Escala Horizontal =
	gmt math "temp_KM" "temp_L" DIV $FH MUL = 
	gmt math "temp_KM" "temp_L" DIV $FH MUL = "temp_Esc_Hz"

	echo Escala Vertical =  
	gmt math "temp_Max" "temp_Min" SUB "temp_H" DIV $FV MUL =
	gmt math "temp_Max" "temp_Min" SUB "temp_H" DIV $FV MUL = "temp_Esc_Ve"

	echo Exageracion Vertical =
	gmt math "temp_Esc_Hz" "temp_Esc_Ve" DIV =

#	Agregar a figura
#	-------------------------------------------------------------

#	Datos terminal
	echo Esc. Hz. = 1:37.797.333 | gmt pstext -R -J -O -K -F+cBL+f9p -Gwhite -W1 >> $OUT
	echo Esc. Ve. = 1:460.000    | gmt pstext -R -J -O -K -F+cBC+f9p -Gwhite -W1 >> $OUT
	echo Ex. Vert. = 82          | gmt pstext -R -J -O -K -F+cBR+f9p -Gwhite -W1 >> $OUT

#	*****************************************************************************************************************

#   ----------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
gmt end

#	Borrar archivos temporales
#	-----------------------------------------------------------------------------------------------------------
	rm temp_* gmt.*

#	