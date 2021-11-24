#!/bin/bash
clear

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------

#	Titulo del mapa
	title=EJ6.3_Mapa_Pendiente+Aspecto_porcentaje
	echo $title

#	Region: Argentina
	REGION=-72/-64/-35/-30

#	Proyeccion Mercator (M)
	PROJ=M15c

#	DEM
	DEM="GMRTv3_1.grd"

# 	Nombre archivo de salida
	OUT=$title.ps
	CUT=temp_$title.nc
	CUT2=temp_$title2.nc
	color=temp_$title.cpt
	SHADOW=temp_$title-schadow.grd

	gmtset MAP_FRAME_AXES WesN

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Abrir archivo de salida (ps)
	gmt psxy -R$REGION -J$PROJ -T -K -P > $OUT

#	Calcular Grillas con modulo del pendiente y aspecto
	gmt grdgradient $DEM -D  -S$CUT  -R -fg
	gmt grdgradient $DEM -Da -G$CUT2 -R -fg

#	Convertir modulo del gradiente a inclinacion (porcentaje)
	gmt grdmath $CUT 100 MUL = $CUT

#	Reclasificar grillas de pendiente en 4 clases
	gmt grdclip $CUT -G$CUT -Sb5/10 -Si5/20/20 -Si20/40/30 -Sa40/40 -V

#	Reclasificar grilla de Aspecto en 8 clases
	gmt grdclip $CUT2 -G$CUT2 -Sb22.5/1 -Si22.5/67.5/2 -Si67.5/112.5/3 -Si112.5/157.5/4 -Si157.5/202.5/5 -Si202.5/247.5/6 -Si247.5/292.5/7 -Si292.5/337.5/8 -Sa337.5/1 -V

#	-------------------------------------------------------------------------------
#	Sumar Grillas
	gmt grdmath $CUT $CUT2 ADD = $CUT

#	Crear Imagen a partir de grilla con sombreado (-I%SHADOW%)
	gmt grdimage -R -J -O -K $CUT -C"Brewer_Aspect-Slope.cpt" >> $OUT -nn

#	Agregar escala vertical a partir de CPT (-C). Posición (x,y) +wlargo/ancho. Anotaciones (-Ba). Leyenda (+l). 
#	gmt psscale -R -J -O -K -C"Brewer_Aspect-Slope.cpt" >> $OUT -DJRM+o0.3c/0+w11/0.618c -L0.1

#	Datos Instituto Geografico Nacional (IGN)
#	-----------------------------------------------------------------------------------------------------------
#	limites administrativos
	gmt psxy -R -J -O -K "E:\Facultad\Datos_Geofisicos\IGN\1_GMT\limites_politico_administrativos.gmt" -Wthin >> $OUT 

#	Dibujar red ferroviaria
	gmt psxy -R -J -O -K "E:\Facultad\Datos_Geofisicos\IGN\1_GMT\003_Red_Ferroviaria.gmt" -Wthin,white -Am >> $OUT

#	Pueblos y Ejidos Urbanos
	gmt psxy -R -J -O -K "E:\Facultad\Datos_Geofisicos\IGN\1_GMT\005_Centros_Poblados.gmt" -Sc0.04 -Gblack >> $OUT
	gmt psxy -R -J -O -K "E:\Facultad\Datos_Geofisicos\IGN\1_GMT\010_Ejidos_Urbanos.gmt" -Wfaint -Ggreen >> $OUT  

#	-----------------------------------------------------------------------------------------------------------
#	Dibujar frame
	gmt psbasemap -R -J -O -K -Baf >> $OUT

#	Pintar areas húmedas: Oceanos (-S) y Lagos (-Cl/)f
	gmt pscoast -R -J -O -K -Df -Sdodgerblue2 >> $OUT

#	Dibujar Linea de Costa (W1)
	gmt pscoast -R -J -O -K -Df -W1/faint >> $OUT

#	Dibujar Escala en el mapa centrado en -Lg Lon0/Lat0, calculado en meridiano (+c), ancho (+w), elegante(+f), unidad arriba de escala (+l), unidad con los valores (+u). n: Centrado en el 88% del eje X y 7.5% del eje Y.
	gmt psbasemap -R -J -O -K -Ln0.88/0.075+c-32:00+w100k+f+l >> $OUT

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo de salida (ps)
	gmt psxy -R -J -T -O >> $OUT

#	Convertir ps en otros formatos: EPS (e), PDF (f), JPEG (j), PNG (g), TIFF (t)
	gmt psconvert $OUT -Tg -A -Z

	rm temp_* gmt.*
#	pause