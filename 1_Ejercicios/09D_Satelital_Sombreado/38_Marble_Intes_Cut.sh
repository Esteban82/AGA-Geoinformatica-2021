#!/usr/bin/env bash
clear

#	Temas a ver
#	1. Agregar efecto de sombreado a una imagen satelital. 

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=38_Satelital_Sombreado_3
	echo $title

#	Proyeccion y Region
	PROJ=M15c
#	REGION=-85/-54/9/26
#	REGION=BR
	REGION=-73/-65/-35/-30

#	Datos
	DEM=@earth_relief_03s
	SAT=@earth_day_30s	

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png

#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n

#	Sombreado a partir del DEM
	gmt grdgradient $DEM -Nt0.8 -A45 -Gtmp_intes -R$REGION

#	Graficar Imagen Satelital
	gmt grdimage $SAT -Itmp_intes

#	Dibujar Paises (1 paises, 2 estados/provincias en America, 3 limite maritimo)
	gmt coast -N1/0.2,- 

#	Dibujar Linea de Costae
	gmt coast -W1/ 

#	Dibujar marco del mapa 
	gmt basemap -Bxaf -Byaf

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar la sesion y mostrar archivo
gmt end #show

	rm tmp_*
