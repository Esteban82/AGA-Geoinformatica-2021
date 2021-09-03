# Tarea 1

**Objetivo**: Instalar GMT y comprobar que todo está correctamente configurado en su PC.

Mira el siguiente video con las indicaciones para la instalación de los programas necesarios
y la comprobación de su correcto funcionamiento.

Siga los siguientes pasos para ejecutar algunos scripts de GMT y comprobar
que obtiene el mapa y la animación correctos.


## Tarea

1. Siga las [instrucciones de instalación](../INSTALL.md).
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

7. Tell us if you were able to complete homework 1 (and give us some feedback so we can better prepare for the course) by filling out
   the following short [survey](https://forms.gle/FnEeTK9CLgYHBMzD9) by end of Saturday.
