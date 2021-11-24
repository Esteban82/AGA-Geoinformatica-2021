ECHO OFF
cls

REM	Definir variables del mapa
REM	-----------------------------------------------------------------------------------------------------------

REM	Titulo del mapa
	SET	title=EJ6.3_Mapa_Pendiente+Aspecto_Esteban
	echo %title%

rem	Region: Argentina
	SET	REGION=-72/-64/-35/-30
rem	SET	REGION=-68.5/-67.5/-32/-31

REM	Proyeccion Mercator (M)
	SET	PROJ=M15c

REM	DEM
	SET	DEM="GMRTv3_1.grd"

REM 	Nombre archivo de salida
	SET	OUT=%title%.ps
	SET	CUT=temp_%title%.nc
	SET	CUT2=temp_%title%2.nc
	SET	color=temp_%title%.cpt
	SET	SHADOW=temp_%title%_shadow.grd

	gmtset MAP_FRAME_AXES WesN

REM	Dibujar mapa
REM	-----------------------------------------------------------------------------------------------------------
REM	Abrir archivo de salida (ps)
	gmt psxy -R%REGION% -J%PROJ% -T -K -P > %OUT%

REM	Calcular Grillas con modulo del pendiente y aspecto
	gmt grdgradient %DEM% -D  -S%CUT%  -R -fg
	gmt grdgradient %DEM% -Da -G%CUT2% -R -fg

REM	Convertir modulo del gradiente a inclinacion (pendiente) en radianes (ATAN), y luego a grados (R2D)
	gmt grdmath %CUT% ATAN R2D = %CUT%

REM	Reclasificar grillas de pendiente en 4 clases
	gmt grdclip %CUT% -G%CUT% -Sb3/10 -Si3/12/20 -Si12/22/30 -Sa22/40 -Vi
rem	gmt grdclip %CUT% -G%CUT% -Sb1/10 -Si1/10/20 -Si10/20/30 -Sa20/40 -V
rem	gmt grdclip %CUT% -G%CUT% -Sb1/10 -Si1/5/20  -Si5/10/30  -Sa10/40 -V
pause

REM	Reclasificar grilla de Aspecto en 8 clases
	gmt grdclip %CUT2% -G%CUT2% -Sb22.5/1 -Si22.5/67.5/2 -Si67.5/112.5/3 -Si112.5/157.5/4 -Si157.5/202.5/5 -Si202.5/247.5/6 -Si247.5/292.5/7 -Si292.5/337.5/8 -Sa337.5/1 -V

	pause

REM	-------------------------------------------------------------------------------
REM	Sumar Grillas
	gmt grdmath %CUT% %CUT2% ADD = %CUT%

REM	Crear Imagen a partir de grilla con sombreado (-I%SHADOW%)
rem	gmt grdimage -R -J -O -K %CUT% -C"Brewer_Aspect-Slope.cpt" >> %OUT% -n+c
	gmt grdimage -R -J -O -K %CUT% -C"Aspect-Slope_Esteban.cpt" >> %OUT% -nn
rem	pause

REM	Agregar escala vertical a partir de CPT (-C). Posición (x,y) +wlargo/ancho. Anotaciones (-Ba). Leyenda (+l). 
rem	gmt psscale -R -J -O -K -C"Brewer_Aspect-Slope.cpt" >> %OUT% -DJRM+o0.3c/0+w11/0.618c -L0.1

REM	Datos Instituto Geografico Nacional (IGN)
REM	-----------------------------------------------------------------------------------------------------------
rem	limites administrativos
	gmt psxy -R -J -O -K "E:\Facultad\Datos_Geofisicos\IGN\1_GMT\limites_politico_administrativos.gmt" -Wthin >> %OUT% 

rem	Dibujar red ferroviaria
	gmt psxy -R -J -O -K "E:\Facultad\Datos_Geofisicos\IGN\1_GMT\003_Red_Ferroviaria.gmt" -Wthin,white -Am >> %OUT%

rem	Pueblos y Ejidos Urbanos
	gmt psxy -R -J -O -K "E:\Facultad\Datos_Geofisicos\IGN\1_GMT\005_Centros_Poblados.gmt" -Sc0.04 -Gblack >> %OUT%
	gmt psxy -R -J -O -K "E:\Facultad\Datos_Geofisicos\IGN\1_GMT\010_Ejidos_Urbanos.gmt" -Wfaint -Ggreen >> %OUT%  

REM	-----------------------------------------------------------------------------------------------------------
REM	Dibujar frame
	gmt psbasemap -R -J -O -K -Baf >> %OUT%

rem	Pintar areas húmedas: Oceanos (-S) y Lagos (-Cl/)f
	gmt pscoast -R -J -O -K -Df -Sdodgerblue2  >> %OUT%

REM	Dibujar Linea de Costa (W1)
	gmt pscoast -R -J -O -K -Df -W1/faint >> %OUT%

REM	Dibujar Escala en el mapa centrado en -Lg Lon0/Lat0, calculado en meridiano (+c), ancho (+w), elegante(+f), unidad arriba de escala (+l), unidad con los valores (+u). n: Centrado en el 88% del eje X y 7.5% del eje Y.
	gmt psbasemap -R -J -O -K -Ln0.88/0.075+c-32:00+w100k+f+l   >> %OUT%

REM	-----------------------------------------------------------------------------------------------------------
REM	Cerrar el archivo de salida (ps)
	gmt psxy -R -J -T -O >> %OUT%

REM	Convertir ps en otros formatos: EPS (e), PDF (f), JPEG (j), PNG (g), TIFF (t)
	gmt psconvert %OUT% -Tg -A

srem	del temp_* gmt.* %OUT%
	pause
