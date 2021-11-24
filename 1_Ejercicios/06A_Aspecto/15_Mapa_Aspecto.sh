#!/bin/bash
clear

#	Temas a ver
#   1. Paleta circular
#	2. Paleta con intervalos

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=15_Mapa_Aspecto
	echo $title

#	Region: Argentina
	REGION=-72/-64/-35/-30

#	Proyeccion Mercator (M)
	PROJ=M15c

#	Grilla 
	GRD=@earth_relief_30s

# 	Archivos temporales
	CUT=tmp_$title.nc
	SHADOW=tmp_$title-shadow.nc

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
	gmt begin $title png
	
#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n

#	Calcular grilla de aspecto (orientacion de la pendiente)
#	---------------------------------------------
#	Recortar Grilla
	gmt grdcut $GRD -G$CUT -R$REGION

#	Calcular grilla de  (aspecto). -D(a): direccion con pendiente-arriba (abajo).
	gmt grdgradient $CUT -Da -G$CUT -fg
#	---------------------------------------------

#	Ver informacion de la grilla
	gmt grdinfo $CUT

#	Crear Paleta de Colores. Paleta Maestra (-C), Definir rango (-Tmin/max/intervalo), CPT continuo (-Z)
	gmt makecpt -Ccyclic -T0/360
#	gmt makecpt -Ccyclic -T0/360/25
#	gmt makecpt -Ccyclic  -T0/360/45
#	gmt makecpt -Ccyclic  -T0/360/90
#	gmt makecpt -CromaO  -T0/360

#	Crear Grilla de Pendientes para Sombreado (Hill-shaded). Definir azimuth del sol (-A)
	#gmt grdgradient $GRD -A135 -G$SHADOW -Nt1 -R$REGION

#	Crear Imagen a partir de grilla con sombreado
	gmt grdimage $CUT
#	gmt grdimage $CUT -I$SHADOW

#	Agregar escala vertical a partir de CPT (-C). Posición (x,y) +wlargo/ancho. Anotaciones (-Ba). Leyenda (+l). 
	gmt colorbar -DJBC+o0/0.3c+w14/0.618c+h -C -Ba30f15+l"Orientaci\363n pendiente(\232)"

#	-----------------------------------------------------------------------------------------------------------
#	Dibujar frame
	gmt basemap -Bxaf -Byaf -BWesN

#	Pintar areas húmedas: Oceanos (-S) y Lagos (-Cl/)f
	gmt coast -Da -Sdodgerblue2

#	Dibujar Linea de Costa (W1)
	gmt coast -Da -W1/faint

#	Dibujar Escala en el mapa centrado en -Lg Lon0/Lat0, calculado en meridiano (+c), 
	gmt basemap -Ln0.88/0.075+c-32:00+w100k+f+l

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo de salida (ps)
	gmt end

	rm tmp_* gmt.*

#	Ejercicios sugeridos
#	1. Cambiar la CPT ciclica a usar.
#	2. Cambiar el intervalo de las CPT