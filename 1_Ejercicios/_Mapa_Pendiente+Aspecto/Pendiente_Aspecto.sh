#!/usr/bin/env bash

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=Pendiente_Aspecto
	echo $title

#	Proyeccion y Region
	PROJ=M15c
	REGION=-72/-64/-35/-30
#	REGION=-68.5/-67.5/-32/-31
	
#	Grilla	
	DEM=@earth_relief_30s

# 	Nombre archivo de salida
	CUT=tmp_$title.nc
	CUT2=tmp_$title-2.nc

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png
	
#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n

#	Calcular Grillas con modulo del pendiente y aspecto
	gmt grdgradient $DEM -D  -S$CUT  -R$REGION -fg
	gmt grdgradient $DEM -Da -G$CUT2 -R$REGION -fg -Vi

#	Convertir modulo del gradiente a inclinacion (pendiente) en radianes (ATAN), y luego a grados (R2D)
	gmt grdmath $CUT ATAN R2D = $CUT

#	Reclasificar grillas de pendiente en 4 clases 
#	gmt grdclip $CUT -G$CUT -Sb3/10 -Si3/12/20 -Si12/22/30 -Sa22/40
#	gmt grdclip $CUT -G$CUT -Sb1/10 -Si1/10/20 -Si10/20/30 -Sa20/40
	gmt grdclip $CUT -G$CUT -Sb1/10 -Si1/5/20  -Si5/10/30  -Sa10/40 

#	Reclasificar grilla de Aspecto en 8 clases (rangos de 45º en cada direccion N, NE, E, SE, S, SO, O, NO)
	gmt grdclip $CUT2 -G$CUT2 -Sb22.5/1 -Si22.5/67.5/2 -Si67.5/112.5/3 -Si112.5/157.5/4 -Si157.5/202.5/5 \
	-Si202.5/247.5/6 -Si247.5/292.5/7 -Si292.5/337.5/8 -Sa337.5/1

#	-------------------------------------------------------------------------------
#	Sumar Grillas
	gmt grdmath $CUT $CUT2 ADD = $CUT

#	Crear Imagen
#	gmt grdimage $CUT -CBrewer_Aspect-Slope.cpt -nn+c
#	gmt grdimage $CUT -CBrewer_Aspect-Slope.cpt
	gmt grdimage $CUT -CAspect-Slope_Esteban.cpt

#	gmt colorbar -C
#	-----------------------------------------------------------------------------------------------------------
#	Dibujar frame
	gmt basemap -Bxaf -Byaf 

#	Pintar areas húmedas: Oceanos (-S) y Lagos (-Cl/)f
	gmt coast -Sdodgerblue2

#	Dibujar Linea de Costa (W1)
#	gmt coast -W1/faint
	gmt coast -N1/faint
	
#	Dibujar Escala en el mapa.
	gmt basemap -Ln0.88/0.075+c-32:00+w100k+f+l   

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo de salida (ps)
	gmt end

#	rm tmp_* gmt.*
