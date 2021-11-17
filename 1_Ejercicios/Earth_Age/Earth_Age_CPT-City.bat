ECHO OFF
cls

REM	Definir variables del mapa
REM	-----------------------------------------------------------------------------------------------------------

REM	Titulo del mapa
	SET	title=Earth_Age_CPT-City_Epochs
	echo %title%

REM	Region: Argentina
	SET	REGION=d
	
REM	Proyeccion Mercator (M)
	SET	PROJ=W15c
rem	SET	PROJ=G0/0/90/15c

REM 	Nombre archivo de salida
	SET	OUT=%title%.ps
rem	SET	CUT=temp_%title%.grd
	SET	color=temp_%title%.cpt
	SET	SHADOW=temp_%title%_shadow.nc

	gmtset MAP_FRAME_AXES WesN
	gmtset GMT_VERBOSE w
	gmtset FONT_ANNOT_PRIMARY 5p,Helvetica,black

REM	Dibujar mapa
REM	-----------------------------------------------------------------------------------------------------------
REM	Abrir archivo de salida (ps)
	gmt psxy -R%REGION% -J%PROJ% -T -K -P > %OUT%

REM	Descargar CPT de CPT-City
rem	gmt which -G > %color% "http://soliton.vm.bytemark.co.uk/pub/cpt-city/heine/GTS2012_eons.cpt"
rem	gmt which -G > %color% "http://soliton.vm.bytemark.co.uk/pub/cpt-city/heine/GTS2012_eras.cpt"
rem	gmt which -G > %color% "http://soliton.vm.bytemark.co.uk/pub/cpt-city/heine/GTS2012_periods.cpt"
rem	gmt which -G > %color% "http://soliton.vm.bytemark.co.uk/pub/cpt-city/heine/GTS2012_epochs.cpt"
	gmt which -G > %color% "http://soliton.vm.bytemark.co.uk/pub/cpt-city/heine/GTS2012_ages.cpt"
	set /p cpt=<%color%

REM	Calcular sombreado
	gmt grdgradient @earth_relief_05m_p -A270 -G%SHADOW% -Ne0.5


REM	Crear Imagen a partir de grilla con sombreado y cpt
	gmt grdimage -R -J -O -K @earth_age_05m_p >> %OUT% -C%cpt% -I%SHADOW%

REM	Agregar escala de colores a partir de CPT (-C). Posición (x,y) +wlargo/ancho. Anotaciones (-Ba). Leyenda (+l). 
	gmt psscale -R -J -O -K -DJRM+o0.3c/0+w-7/0.618c -C%cpt% -I >> %OUT% -G0/200 -L0 
rem	gmt psscale -R -J -O -K -DJRM+o0.3c/0+w-7/0.618c -C%cpt% -I >> %OUT% -G0/200 -B+l"Age (Ma)"  

REM	Dibujar frame
	gmt psbasemap -R -J -O -K >> %OUT% -B0

REM	Dibujar Linea de Costa (W1)
	gmt pscoast -R -J -O -K  >> %OUT% -Df -W1/faint

REM	-----------------------------------------------------------------------------------------------------------
REM	Cerrar el archivo de salida (ps)
	gmt psxy -R -J -T -O >> %OUT%

REM	Convertir ps en otros formatos: EPS (e), PDF (f), JPEG (j), PNG (g), TIFF (t)
	gmt psconvert %OUT% -Tg -A -Z

rem	pause
rem	del temp_* %OUT% gmt.*
