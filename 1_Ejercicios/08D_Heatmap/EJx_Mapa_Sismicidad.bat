ECHO OFF
cls

REM	Definir variables del mapa
REM	-----------------------------------------------------------------------------------------------------------

REM	Titulo del mapa
	SET	title=EJx_Mapa_Sismicidad
	echo %title%
 
REM	Region Geografica
	SET	REGION=-34/-20/-62/-54
	SET	REGION=-79/-20/-63/-20

REM	Proyeccion Cilindrica: (M)ercator
	SET	PROJ=M15c

REM 	Nombre archivo de salida
	SET	OUT=%title%.ps
	SET	CUT=temp_%title%.grd
	SET	color=temp_%title%.cpt
	SET	SHADOW=temp_%title%_shadow.grd

REM	Parametros GMT
REM	-----------------------------------------------------------------------------------------------------------
REM	Parametros de Fuentes: Titulo del grafico, del eje (label) y unidades del eje (ANNOT_PRIMARY)
	gmtset	FONT_TITLE 16,4,Black
	gmtset	FONT_LABEL 10p,19,Black
	gmtset	FONT_ANNOT_PRIMARY 8p,Helvetica,Black
	gmtset	MAP_FRAME_AXES WesN

REM	-----------------------------------------------------------------------------------------------------------
REM	Abrir archivo de salida (ps)
	gmt psxy -R%REGION% -J%PROJ% -T -K -P > %OUT%

REM	Recortar Grilla
	gmt grdcut "GMRTv3_3_Arg.grd" -G%CUT% -R -fg

	grdinfo %CUT% -T100
rem	pause

REM	Color constante (blanco).
rem	echo	-8200 	white	6200 	white	> %color%

REM	Color 2. 
	echo	-8200 	dodgerblue2	0 	dodgerblue2	> %color%
	echo	0 	white	6200 	white	>> %color%

REM	Crear Grilla de Pendientes para Sombreado (Hill-shaded). Definir azimuth del sol (-A)
	gmt grdgradient %CUT% -A270 -G%SHADOW% -Ne0.5

REM	Crear Imagen a partir de grilla con sombreado
	gmt grdimage -R -J -O -K %CUT% -C%color% -I%SHADOW% >> %OUT%

REM	Dibujar Bordes Administrativos. N1: paises. N2: Provincias, Estados, etc. N3: limites marítimos (Nborder[/pen])
	gmt pscoast -R -J -O -K >> %OUT% -Df -N1/0.30 
	gmt pscoast -R -J -O -K >> %OUT% -Df -N2/0.25,-.

	gmt info "E:\Facultad\Datos_Geofisicos\Sismicidad\USGS\query_*.csv" -h1 -i2,1     -I1
	gmt info "E:\Facultad\Datos_Geofisicos\Sismicidad\USGS\query_*.csv" -h1 -i2,1,3,4
rem	pause

REM	Sismos
REM	-----------------------------------------------------------------------------------------------------------
REM	Crear cpt para sismos someros (<100 km), intermedios (100 - 300 km) y profundos (> 300 km)
	echo 0		red	100	red   >  "temp_seis.cpt"
	echo 100	green	300	green >> "temp_seis.cpt"
	echo 300	blue	1000	blue  >> "temp_seis.cpt"
	
	gmt makecpt > "temp_seis.cpt" -Crainbow -T0/700 -Z -I 	

REM	---------------------------------------------------------
REM	Mapear sismos. 3 opciones: 

REM	Dibujar. Tamaño y color fijo
	gmt psxy -R -J -O -K "E:\Facultad\Datos_Geofisicos\Sismicidad\USGS\query_*.csv" -h1 -i2,1     >> %OUT% -Sc0.05 -Ggray

REM	Dibujar. Tamaño fijo. Color según profundidad
	gmt psxy -R -J -O -K "E:\Facultad\Datos_Geofisicos\Sismicidad\USGS\query_*.csv" -h1 -i2,1,3   >> %OUT% -Sc0.05 -C"temp_seis"

REM	Dibujar. Tamaño según magnitud. Color según profundidad
rem	gmt psxy -R -J -O -K "E:\Facultad\Datos_Geofisicos\Sismicidad\USGS\query_*.csv" -h1 -i2,1,3,4 >> %OUT% -Scp    -C"temp_seis" -W0.1

REM	Datos INPRES. 
rem	gmt psxy -R -J -O -K "E:\Facultad\Datos_Geofisicos\Sismicidad\Inpres\*.csv" -i3,2,4,5 >> %OUT% -Scp    -C"temp_seis" -W0.1

REM	-----------------------------------------------------------------------------------------------------------
REM	Dibujar Escala en el mapa centrado en -Lg Lon0/Lat0, calculado en meridiano (+c), ancho (+w), elegante(+f), unidad arriba de escala (+l), unidad con los valores (+u)
	gmt psbasemap -J -R -Ln0.1/0.05+c-43+w800k+l+f -O -K >> %OUT%

REM	Dibujar frame (-B): Anotaciones (a), frame (f), grilla (g)
	gmt psbasemap -J -R -Ba8f4/a4f2 -O -K >> %OUT%

REM	-----------------------------------------------------------------------------------------------------------
REM	Cerrar el archivo de salida (ps)
	gmt psxy -R -J -T -O >> %OUT%

REM	Convertir ps en otros formatos: EPS (e), PDF (f), JPEG (j), PNG (g), TIFF (t)
	gmt psconvert %OUT% -A -Tg
rem	pause
	del temp*
