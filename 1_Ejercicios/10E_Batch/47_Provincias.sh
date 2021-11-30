Title=47_Provincias

# 1. Crear lista de paises, territorios, provincias
cat << EOF > pre.sh
gmt begin
#    gmt coast -E=SA+l > $Title
    gmt coast -EAR+L  > $Title
gmt end
EOF
# 2. Crear cada imagen
cat << EOF > main.sh
gmt begin \${BATCH_NAME} pdf #,png
    gmt coast -R\${BATCH_WORD0}+e0.5 -JM10c -Glightgray -Slightblue -B -B+t"\${BATCH_WORD1}" -E\${BATCH_WORD0}+gred+p0.5p
    gmt coast -EAR+p 
    echo \${BATCH_WORD0} | gmt text -F+f16p+jTL+cTL -Gwhite -W1p
gmt end
EOF
# 3. Combinar todos los pdf en un unico archivo.
cat << EOF > post.sh
gs -dQUIET -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=\${BATCH_PREFIX}.pdf -dBATCH \${BATCH_PREFIX}_*.pdf
rm -f \${BATCH_PREFIX}_*.pdf
EOF

# 4. Ejecutar tarea
gmt batch main.sh -Sbpre.sh -Sfpost.sh -T$Title+w"\t" -N$Title -W -V -Z

