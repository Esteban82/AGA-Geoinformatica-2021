#!/usr/bin/env bash
clear

#	Temas a ver: 
#	1. Vista en perspectiva.
#	2. Usar otros paletas de colores maestras (CPT).
#	3. Crear grilla para sombreado.
#	4. Curvas de nivel.

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=09_Topografico_02
	echo $title

#	Region: Argentina
	REGION=-72/-64/-35/-30
	REGION=AR,BR,CO
	REGION=AR,GS
#	REGION==SA

#	Proyeccion Mercator (M)
	PROJ=M15c

#	Vista perspectiva (acimut/elevacion)
#	p=140/30
	p=180/90

# 	Archivos temporales
	CUT=tmp_$title.nc
	SHADOW=tmp_$title-shadow.nc

#	Grilla
	GRD=@earth_relief_05m

	gmt set GMT_VERBOSE w

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png
	
#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n -p$p

#	Crear Imagen a partir de grilla con sombreado y diferentes cpt maestros
	gmt grdimage -p $GRD
#	gmt grdimage -p $GRD -I -Cglobe
#	gmt grdimage -p $GRD -I -Cetopo1
#	gmt grdimage -p $GRD -I -Coleron
#	gmt grdimage -p $GRD -I -Crelief

#	Crear image a partir de grilla con sombreado personalizado
#	----------------------------------------------------------
#	Recortar Grilla
#	gmt grdcut $GRD -G$CUT -R$REGION

#	Crear Grilla de Pendientes para Sombreado (Hill-shaded). Definir azimuth rm sol (-A)
#	gmt grdgradient $CUT -A270 -G$shadow -Nt0.8
#	gmt grdgradient $CUT -A270/45 -G$shadow -Nt0.8

#	gmt grdimage -p $GRD -I+a270+nt1
#	gmt grdimage -p $CUT -I$shadow
#	----------------------------------------------------------

#	Agregar escala de colores a partir de CPT (-C). Posición (x,y) +wlargo/ancho. Anotaciones (-Ba). Leyenda (+l). 
	gmt colorbar -DJRM+o0.3c/0+w11/0.618c -C -p -Ba1+l"Elevaciones (km)" -I -W0.001 #-Bx+l"m"

#	Lineas de Contorno. Equidistancia (-C), Anotaciones (-A), Numero de Corte (-Q), Limitar rango (-Llow/high), 
#	gmt grdcontour $GRD -p -W0.5,black    -C500
#	gmt grdcontour $GRD -p -W0.5,black    -C1000
#	gmt grdcontour $GRD -p -W0.5,black    -C1000 -L-7000/0
#	gmt grdcontour $GRD -p -W0.5,black    -C1000 -L-7000/2000
#	gmt grdcontour $GRD -p -W0.5,black    -C1000 -Ln
#	gmt grdcontour $GRD -p -W0.5,black    -C1000 -Lp
#	gmt grdcontour $GRD -p -W0.5,black    -C1000 -Ln -Q100k
#	gmt grdcontour $GRD -p -W0.35,black,- -C2000     -Q100k
	gmt grdcontour $GRD -p -W0.5,black    -C1000 -Ln -A2000+gwhite+u" m"

#	-----------------------------------------------------------------------------------------------------------
#	Dibujar frame
	gmt basemap -p -Bxaf -Byaf -BWesN

#	Dibujar Linea de Costa (W1)
#	gmt coast -p -Da -W1/faint

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo de salida (ps)
	gmt end

	rm tmp_* gmt.*

#	-----------------------------------------------------------------------------------------------------------
#
#	Ejercicios Sugeridos:
#	1. Utilizar otros cpt maestros (probar lineas 64-67). Ver en documentacion otros.
#	2. Modificar el acimut del sol para el efecto de sombreado y agregar otro (59-60).
#	3. Probar los distintos comandos para crear curvas de nivel (lineas 70 a 78)	
#	4. Definir curvas de nivel con un intervalo diferente (lineas 76-84).
#	5. Hacer el mapa con la perspectiva de la línea 26. Probar con otras.