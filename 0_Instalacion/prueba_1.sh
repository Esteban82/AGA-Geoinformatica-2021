#!/usr/bin/env bash
# Probar prueba_1: Asegurar que la instalación de GMT es correcta.
gmt begin prueba1 png
	gmt grdimage @earth_relief_20m -R-85/-20/-56/15 -JM15c -I+d
	gmt coast -W -N1 -B
gmt end # show
