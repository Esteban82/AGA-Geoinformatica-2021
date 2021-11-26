#!/usr/bin/env bash

#	Definir variables del mapa
#	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=43_Arg_Bicont
	echo $title

#	Proyecciones acimutales requieren 3 parametros + 1 opcional (lon0/lat0[/horizon]/width
#	L(a)mbert Equal Area; (S)tereographic; Orto(g)rafica; (E)quidistante
	PROJ=A-60/-40/20c
#	PROJ=M-60/-40/15c

#	Calcular distancia proyectada al polos sur (0 -90)
	S=$(echo 0 -90 | gmt mapproject -Rg -J$PROJ -C -Fk -o1)

#	Region geografica del mapa (W/E/S/N) d=-180/180/-90/90 g=0/360/-90/90
	REGION=-2400/3100/${S}/2100+uk

#	Parametros por Defecto
#	-----------------------------------------------------------------------------------------------------------
#	Sub-seccion GMT
	gmt set GMT_VERBOSE w

#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png

#	Setear la region y proyeccion
	gmt basemap -R$REGION -J$PROJ -B+n

#	gmt coast -A+agS -Df -Sp62

#	Pintar areas secas (-G). Usar linea de costa para Antartida (-A+ag) en lugar de frente de hielo.
#	gmt coast -Df -G245/241/214 -S199/224/246 		# Antartida con costa segun frente de hielo.
	gmt coast -Df -G245/241/214 -S199/224/246 -A+ag		# Antartida con costa segun costa. 

#   	Plataforma Continental Antartica y Americana
	gmt plot "IGN/Plataforma_Antartida.txt" -G162/192/232

#	gmt plot IGN/Plataforma_Americana.txt  -G162/192/232			# Error. Tapa las islas
	gmt spatial IGN/Plataforma_Americana.txt -Sh | gmt plot -G162/192/232	# Spatial reformatea al archivo para respetarlas.

#	Pintar Pais
 	gmt plot "IGN/pais.shp" -Gwhite

#	Dibujar Linea de Costa 
	gmt coast -Df -A+ag -W1/faint,9/148/221

#	Capitales Provincias ARG
	gmt plot "IGN/Capitales_Provinciales_Argentina.txt" -Sc0.10c -Gwhite -Wfaint
	gmt plot "IGN/Capitales_Provinciales_Argentina.txt" -Sc0.05c -Gblack

#	Capitales Paises
	gmt plot "IGN/Capitales_Mundo.txt" -Sc0.15c -Gwhite -Wfaint
	gmt plot "IGN/Capitales_Mundo.txt" -Sc0.10c -Gwhite -Wfaint
	gmt plot "IGN/Capitales_Mundo.txt" -Sc0.05c -Gblack

#	ZEE: Zonas economicas exclusivas
	gmt plot "IGN/Limite_ZEE_Argentina.txt"           -Wfaint,dashed
	gmt plot "IGN/Limite_200M_AntartidaArgentina.txt" -Wfaint,dashed
    
#	Limites Argentina y de provincias
	gmt plot "IGN/linea_de_limite_FA004.shp" -Wfaint,dashed
	gmt plot "IGN/linea_de_limite_070111.shp" -Wfaint

#	Limites Maritimos
#	Limite Aguas Interiores
	gmt plot "IGN/Limites_Aguas_Interiores.shp" -Wfaint,70/83/173,dashed

#	Limite exterior del mar territorial argentino
	gmt plot "IGN/Limite_Mar_Territorial_Argentino.shp" -Wfaint,70/83/173,dashed

#	Dibujar limite de hielos de la Antartida
	gmt coast -A+aiS -Df -W1/faint,9/148/221


#	Dibujar cuadricula del mapa
	gmt basemap -Bg10 --MAP_GRID_PEN=18/151/221

#	Dibujar triangulo del sector antartico
	gmt plot -L -Am -Wthinner  <<- EOF
	-74 -60
	-74 -90
	-25 -60
	EOF

#	Cerrar la sesion y mostrar archivo
gmt end #show

#	Borrar archivos tempostales
	rm gmt.*
