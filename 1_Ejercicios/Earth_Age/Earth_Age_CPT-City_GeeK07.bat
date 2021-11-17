ECHO OFF
cls

REM	Definir variables del mapa
REM	-----------------------------------------------------------------------------------------------------------
REM	Titulo del mapa
	SET	title=Earth_Age_CPT-City_Geek07
	echo %title%

REM	Region: Argentina
	SET	REGION=d
	
REM	Proyeccion Mercator (M)
	SET	PROJ=W15c

REM 	Nombre archivo de salida
	SET	OUT=%title%.ps
rem	SET	CUT=temp_%title%.grd
	SET	color=temp_%title%.cpt

	gmtset MAP_FRAME_AXES WesN
	gmtset GMT_VERBOSE w
	gmtset FONT_ANNOT_PRIMARY 5p,Helvetica,black

REM	Dibujar mapa
REM	-----------------------------------------------------------------------------------------------------------
REM	Abrir archivo de salida (ps)
	gmt psxy -R%REGION% -J%PROJ% -T -K -P > %OUT%

REM	Descargar CPT de CPT-City
	gmt which -G > %color% "http://soliton.vm.bytemark.co.uk/pub/cpt-city/heine/GeeK07.cpt"
	set /p cpt=<%color%

REM	Crear Imagen a partir de grilla con sombreado y cpt
	gmt grdimage -R -J -O -K @earth_age_05m_p >> %OUT% -C%cpt%

REM	Agregar escala de colores a partir de CPT (-C). Posición (x,y) +wlargo/ancho. Anotaciones (-Ba). Leyenda (+l). 
rem	gmt psscale -R -J -O -K -DJRM+o0.3c/0+w-7/0.618c -C%cpt% >> %OUT% -L0 -G0/10
rem	gmt psscale -R -J -O -K -DJRM+o0.3c/0+w-7/0.618c -C%cpt% >> %OUT% -Ba+l"Age (Ma)"
	gmt psscale -R -J -O -K -DJRM+o0.3c/0+w-7/0.618c -C%cpt% >> %OUT% -B+l"Age (Ma)" -G0/5

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
	del temp_* gmt.*
