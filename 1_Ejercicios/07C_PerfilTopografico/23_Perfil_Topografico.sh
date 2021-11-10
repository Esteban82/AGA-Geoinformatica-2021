#!/bin/bash
clear

#	Define map
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=21_Perfil_Topografico
	echo $title
	
#	Dimensiones del Grafico: Longitud (L), Altura (H).
	L=15
	H=5

#	Resolucion de la grilla (y del perfil)
	RES=15s

#	Base de datos de GRILLAS
	DEM=@earth_relief_$RES

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
	gmt grdtrack tmp_track -G$DEM $REGION > tmp_data

	#gmt sample1d tmp_line -I$RES | gmt mapproject -G+uk | gmt grdtrack -G$DEM $REGION > tmp_data2


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
	#Min=-6200
	#Max=5300
	Min=$(gmt info "tmp_data" -C -o6)
	Max=$(gmt info "tmp_data" -C -o7)

#	Dominio datos del perfil
	gmt info tmp_data -i2,3 -I+R0/0
	gmt info tmp_data -i2,3 -I+R0/100
	gmt info tmp_data -i2,3 -I+R0/500
	gmt info tmp_data -i2,3 -I+r500
	gmt info tmp_data -i2,3 -I+e500

	DOMINIO=$(gmt info tmp_data -i2,3 -I+R0/500)

#	Crear Grafico
#	gmt basemap -JX$L/$H -R0/$KM/$Min/$Max -B+n
	gmt basemap -JX$L/$H $DOMINIO -B+n

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

#   ----------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
gmt end

#	Borrar archivos temporales
#	-----------------------------------------------------------------------------------------------------------
#	rm tmp_* gmt.*

#	Ejercicios sugeridos
#	1. Cambiar las coordenas del perfil.
#	2. Agregar tercer par de coordenadas.
