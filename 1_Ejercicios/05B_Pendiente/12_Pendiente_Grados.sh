#!/usr/bin/env bash

#	Temas a ver
#	1. Procesar grillas (calcular mapa de pendientes)
#	2. Obtener informacion de la grilla y crear variables.

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=12_Pendiente
	echo $title

#	Region: Argentina
	REGION=-72/-64/-35/-30

#	Proyeccion Mercator (M)
	PROJ=M15c

#	Grilla 
	GRD=@earth_relief_30s

# 	Nombre archivo de salida
	CUT=tmp_$title.nc

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png
	
#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n 

#	Calcular grilla de pendientes (en grados)
#	---------------------------------------------
#	Recortar Grilla
	gmt grdcut $GRD -G$CUT -R$REGION

#	Calcular Grilla con modulo del gradiente (-D) para grilla con datos geograficos (-fg)
	gmt grdgradient $CUT -D -S$CUT -fg

#	Convertir modulo del gradiente a inclinacion (pendiente) en radianes (ATAN), y luego a grados (R2D)
	gmt grdmath $CUT ATAN R2D = $CUT
#	---------------------------------------------

#	Obterner Informacion de la grilla para crear paleta de colores (makecpt)
	gmt grdinfo $CUT
#	gmt grdinfo $CUT -T2
#	gmt grdinfo $CUT -T 
#	gmt grdinfo $CUT -T+a0.5
#	gmt grdinfo $CUT -T+a5
	
#	Crear variables con los valores minimo y maximo 
	T=$(gmt grdinfo $CUT -T)
	max=`gmt grdinfo $CUT -Cn -o5`
#	echo $T

#	Crear Paleta de Colores. Paleta Maestra (-C), Definir rango (-Tmin/max/intervalo).
#	gmt makecpt -Crainbow -I -T0/30/2 -D
	gmt makecpt -Crainbow -I $T
#	gmt makecpt -Crainbow -I -T0/$max
#	gmt makecpt -Crainbow -I -D -T0/$max
#	gmt makecpt -Crainbow -T6/30/2 -I

#	Crear Imagen a partir de grilla con sombreado
#	gmt grdimage $CUT -I+a270+nt1
	gmt grdimage $CUT 

#	Agregar escala de color. Posición (x,y) +wlargo/ancho. Anotaciones (-Ba). Leyenda (+l). 
	gmt colorbar -Dx15.5/0+w10.5/0.618c+ef -C -Ba+l"Inclinaci\363n pendiente (@.)"   # en grados

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

	rm tmp_*

#	Ejercicios sugeridos
#	1. Cambiar el valor máximo de la escala de colores.