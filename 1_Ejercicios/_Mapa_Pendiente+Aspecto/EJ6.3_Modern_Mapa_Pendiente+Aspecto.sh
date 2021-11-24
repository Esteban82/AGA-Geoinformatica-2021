#!/usr/bin/env bash

#	Definir variables rm mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=EJ6.3_Modern_Mapa_Pendiente_Aspecto
	echo $title

#	Region: Argentina
	REGION=-72/-64/-35/-30
#	REGION=-68.5/-67.5/-32/-31

#	Proyeccion Mercator (M)
	PROJ=M15c

	DEM="GMRTv3_1.grd"

# 	Nombre archivo de salida
	CUT=temp_$title.nc
	CUT2=temp_$title-2.nc
	color=temp_$title.cpt
	SHADOW=temp_$title-shadow.grd

	gmt set MAP_FRAME_AXES WesN

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
	gmt begin $title png
	
#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n

#	Calcular Grillas con modulo del pendiente y aspecto
	gmt grdgradient $DEM -D  -S$CUT  -R$REGION -fg
	gmt grdgradient $DEM -Da -G$CUT2 -R$REGION -fg

#	Convertir modulo del gradiente a inclinacion (pendiente) en radianes (ATAN), y luego a grados (R2D)
	gmt grdmath $CUT ATAN R2D = $CUT

#	Reclasificar grillas de pendiente en 4 clases
	gmt grdclip $CUT -G$CUT -Sb3/10 -Si3/12/20 -Si12/22/30 -Sa22/40
#	gmt grdclip $CUT -G$CUT -Sb1/10 -Si1/10/20 -Si10/20/30 -Sa20/40 -V
#	gmt grdclip $CUT -G$CUT -Sb1/10 -Si1/5/20  -Si5/10/30  -Sa10/40 -V

#	gmt grdclip "ingrid" -G"outgrid" -C10,20,30,40 -T-,3,12,22,-

#	Reclasificar grilla de Aspecto en 8 clases
	gmt grdclip $CUT2 -G$CUT2 -Sb22.5/1 -Si22.5/67.5/2 -Si67.5/112.5/3 -Si112.5/157.5/4 -Si157.5/202.5/5 -Si202.5/247.5/6 -Si247.5/292.5/7 -Si292.5/337.5/8 -Sa337.5/1 -V

#	gmt grdclip "ingrid" -G"outgrid" -C1,2,3,4,5,6,7,8 -T-,22.5,67.5,112.5,157.5,202.5,247.5,292.5,337.5,-
#	gmt grdclip "ingrid" -G"outgrid" -C1-8             -T-,22.5,67.5,112.5,157.5,202.5,247.5,292.5,337.5,-

#	-------------------------------------------------------------------------------
#	Sumar Grillas
	gmt grdmath $CUT $CUT2 ADD = $CUT

#	Crear Imagen a partir de grilla con sombreado (-I%SHADOW%)
#	gmt grdimage $CUT -C"Brewer_Aspect-Slope.cpt" -n+c
	gmt grdimage $CUT -C"Brewer_Aspect-Slope.cpt" -nn

#	Agregar escala vertical a partir de CPT (-C). Posición (x,y) +wlargo/ancho. Anotaciones (-Ba). Leyenda (+l). 
#	gmt colorbar -C"Brewer_Aspect-Slope.cpt" -DJRM+o0.3c/0+w11/0.618c -L0.1

#	Datos Instituto Geografico Nacional (IGN)
#	-----------------------------------------------------------------------------------------------------------
#	limites administrativos
	gmt plot "E:\Facultad\Datos_Geofisicos\IGN\1_GMT\limites_politico_administrativos.gmt" -Wthin

#	Dibujar red ferroviaria
	gmt plot "E:\Facultad\Datos_Geofisicos\IGN\1_GMT\003_Red_Ferroviaria.gmt" -Wthin,white

#	Pueblos y Ejidos Urbanos
	gmt plot "E:\Facultad\Datos_Geofisicos\IGN\1_GMT\005_Centros_Poblados.gmt" -Sc0.04 -Gblack 
	gmt plot "E:\Facultad\Datos_Geofisicos\IGN\1_GMT\010_Ejidos_Urbanos.gmt" -Wfaint -Ggreen 

#	-----------------------------------------------------------------------------------------------------------
#	Dibujar frame
	gmt basemap -Baf

#	Pintar areas húmedas: Oceanos (-S) y Lagos (-Cl/)f
	gmt coast -Df -Sdodgerblue2

#	Dibujar Linea de Costa (W1)
	gmt coast -Df -W1/faint

#	Dibujar Escala en el mapa.
	gmt basemap -Ln0.88/0.075+c-32:00+w100k+f+l   

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo de salida (ps)
	gmt end

	rm temp_* gmt.*
