# Tarea 1

**Objetivo**: Instalar GMT y comprobar que todo está correctamente configurado en su PC.

Mira el siguiente video con las indicaciones para la instalación de los programas necesarios
y la comprobación de su correcto funcionamiento.

Siga los siguientes pasos para ejecutar algunos scripts de GMT y comprobar
que obtiene el mapa y la animación correctos.


## Instalar los programas

1. Siga las [instrucciones de instalación](../INSTALL.md).


## Descargar repositorio

1. Seleccione la carpeta de su computadora donde quiere descargar el material de este repositorio. 
2. Abra una terminal (Mac: abre el app "Terminal"; Windows: abre "Git Bash").
   Los siguientes pasos deben hacerse en la terminal.
   Para correr un comando, escribelo y luego presiona *Enter*.
3. Corra este comando para descargar el material del curso usando [git](https://en.wikipedia.org/wiki/Git):

   ```
   git clone https://github.com/Esteban82/AGA-Geoinformatica-2021.git
   ```

   Esto creará una carpeta llamada `AGA-Geoinformatica-2021` en su computadora.

4. Corra el siguiente comando para ingresar a la carpeta con los scripts:

   ```
   cd AGA-Geoinformatica-2021/0_Instalacion
   
   ```

5. Ejecute el script [`prueba_1.sh`](prueba_1.sh):

   ```
   bash prueba_1.sh
   ```

   Al finalilzar, una ventana con el siguiente mapa de sudamérica debería abrirse (en Mac puede verse mas suave):

   ![`AGA-Geoinformatica-2021/0_Instalacion/salida/prueba1.png`](salida/prueba1.png)

6. Ejecute el script [`prueba_2.sh`](prueba_2.sh):

   ```
   bash prueba_2.sh
   ```

   Esto debe producir un archivo llamado `contar.mp4` en la carpeta
   `AGA-Geoinformatica-2021/0_Instalacion`. Para abrirlo ejecute:

   * macOS: `open contar.mp4`
   * Linux: `xdg-open contar.mp4`
   * Windows: `explorer contar.mp4`

   El resultado es una animación con números contando de 0 a 24 que luce como:

   ![`AGA-Geoinformatica-2021/0_Instalacion/salida/contar.mp4`](salida/contar.gif)

7. Si tuvo algún problema para obtener los archivos, por favor avisenos a traves de slack.

## Actualizar repositorio

El material del curso (todo lo includio en este repositorio) se actualizará con el paso de las clases. 

Para actualizarlo en tu pc sigue los siguientes pasos:


1. Ve a la carperta `AGA-Geoinformatica-2021` previamente descargada en su computadora.

2. Abre una terminal (Mac: abre el app "Terminal"; Windows: abre "Git Bash").
   Los siguientes pasos deben hacerse en la terminal.
   Para correr un comando, escribelo y luego presiona *Enter*.

3. Finalmente corra el siguiente comando para actualizar su carpeta (repositorio local). Esto puede sobrescribir los scripts originales si los modificó. Se sugiere trabajar en otra carpeta fuera de la carpeta original.

   ```
   git pull
   
   ```
