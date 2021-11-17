ECHO OFF
cls

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=Earth_Age_CPT-City_Epochs
	echo $title

#	Region y Proyeccion
	REGION=d
	PROJ=W15c

# 	Nombre archivo de salida
#	SET	CUT=temp_%title%.grd
#	SET	color=temp_%title%.cpt
#	SET	SHADOW=temp_%title%_shadow.nc

	gmt set MAP_FRAME_AXES WesN
	gmt set GMT_VERBOSE w
	gmt set FONT_ANNOT_PRIMARY 5p,Helvetica,black

#	Dibujar mapa
#	-----------------------------------------------------------------------------------------------------------
#	Abrir archivo de salida (ps)
gmt begin

	gmt basemap -R$REGION -J$PROJ -B+n

#	Descargar CPT de CPT-City
#	gmt which -G > $color "http://soliton.vm.bytemark.co.uk/pub/cpt-city/heine/GTS2012_eons.cpt"
#	gmt which -G > $color "http://soliton.vm.bytemark.co.uk/pub/cpt-city/heine/GTS2012_eras.cpt"
#	gmt which -G > $color "http://soliton.vm.bytemark.co.uk/pub/cpt-city/heine/GTS2012_periods.cpt"
#	gmt which -G > $color "http://soliton.vm.bytemark.co.uk/pub/cpt-city/heine/GTS2012_epochs.cpt"
	gmt which -G > $color "http://soliton.vm.bytemark.co.uk/pub/cpt-city/heine/GTS2012_ages.cpt"
	set /p cpt=<$color

#	Calcular sombreado
#	gmt grdgradient @earth_relief_05m_p -A270 -G$SHADOW -Ne0.5

#	Crear Imagen a partir de grilla con sombreado y cpt
	gmt grdimage @earth_age_05m_p -C$cpt -I

#	Agregar escala de colores a partir de CPT (-C). Posición (x,y) +wlargo/ancho. Anotaciones (-Ba). Leyenda (+l). 
	gmt colorbar -DJRM+o0.3c/0+w-7/0.618c -C$cpt -I -G0/200 -L0 
#	gmt colorbar -DJRM+o0.3c/0+w-7/0.618c -C$cpt -I -G0/200 -B+l"Age (Ma)"  

#	Dibujar frame
	gmt basemap -B0

#	Dibujar Linea de Costa (W1)
	gmt coast -Df -W1/faint

#	-----------------------------------------------------------------------------------------------------------
#	Cerrar el archivo de salida (ps)
	gmt end

#	rm temp_*
