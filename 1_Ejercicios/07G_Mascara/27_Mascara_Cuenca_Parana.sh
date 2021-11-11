#!/bin/bash
clear

#	Temas a ver
#	1. Recorte irregular de una grilla

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=27_Mascara_Cuenca_Parana
	echo $title

#	Region: Argentina
	REGION=-70/-42/-36/-12

#	Proyeccion Mercator (M)
	PROJ=M15c

#	Resolucion de la grilla
#	RES=15s
	RES=02m

#	Base de datos de GRILLAS
	DEM=@earth_relief_$RES

# 	Nombre archivo de salida
	CUT=tmp_$title.nc
	CUT1=tmp_$title-1.nc
	MASK=tmp_$title-2.nc
	CLIP=tmp_clip.txt

#	Parametros Generales
#	-----------------------------------------------------------------------------------------------------------
#	Sub-seccion FUENTE
	gmt set FONT_ANNOT_PRIMARY 8,Helvetica,black
	gmt set FONT_LABEL 8,Helvetica,black

#	Sub-seccion FORMATO
	gmt set FORMAT_GEO_MAP ddd:mm:ssF

#	Sub-seccion GMT
	gmt set GMT_VERBOSE w

#	Iniciar sesion y tipo de figura
#	-----------------------------------------------------------------------------------------------------------
#	Abrir archivo de salida (ps)
gmt begin $title png

#	Setear la region y proyeccion (y no se dibuja nada)
	gmt basemap -R$REGION -J$PROJ -B+n	

#	Crear grilla
#	-------------------------------------------------------------
#	Recortar la grilla (rectangular)
	gmt grdcut $DEM -G$CUT1 -R$REGION

#	Crear/Definir poligono irregular
	CLIP=Cuenca_Parana.txt
#	gmt coast -M > $CLIP -EPY
#	gmt coast -M > $CLIP -EAR.A,AR.Y
#	gmt grdcontour $CUT1  -C+3000 -D$CLIP

#	Crear Mascara con valores dentro del poligono (-Nfuera/borde/dentro)
	gmt grdmask -R$CUT1 $CLIP -G$MASK -NNaN/NaN/1
#	gmt grdmask -R$CUT1 $CLIP -G$MASK -N1/NaN/NaN

#	Recortar 
	gmt grdmath $CUT1 $MASK MUL = $CUT

#	Crear Mapa
#	-------------------------------------------------------------
#	Extraer informacion de la grilla recortada para determinar rango de CPT
	gmt grdinfo $CUT -T50
#	Max=$(gmt grdinfo $CUT -C -o7)
	Max=`gmt grdinfo $CUT -Cn -o5`

#	Crear Paleta de Colores. Paleta Maestra (-C), Definir rango (-Tmin/max/intervalo), CPT continuo (-Z)
#	gmt makecpt -Cdem4 -T0/5700
	gmt makecpt -Cdem4 -T0/$Max

#	Crear Imagen a partir de grilla con sombreado y cpt. -Q: Nodos sin datos sin color 
	gmt grdimage $CUT -C -Q -I

#	Agregar escala de colores a partir de CPT (-C). Posición (x,y) +wlargo/ancho. Anotaciones (-Ba). Leyenda (+l). 
	gmt colorbar -C -I -DJRM+o0.3c/0+w14/0.618c  -Ba+l"Alturas (km)" -W0.001

#	-----------------------------------------------------------------------------------------------------------
#	Dibujar frame
	gmt basemap -Baf

#	Dibujar Linea de Costa
	gmt coast -Df -W1/0.5

#	Dibujar Bordes Administrativos. N1: paises. N2: Provincias, Estados, etc. N3: limites marítimos (Nborder[/pen])
	gmt coast -Df -N1/0.30 
	gmt coast -Df -N2/0.25,-.

#	Dibujar CLIP
	gmt plot $CLIP -W0.5,red

#	Pintar areas húmedas: Oceanos (-S) y Lagos y Rios (-C).
	gmt coast -Sdodgerblue2 -C-

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar sesion y mostrar figura
gmt end # show

	rm tmp_* gmt.*

#	Ejercicios sugeridos
#	1. Probar otros poligonos.
#	2. Invertir la mascara. 