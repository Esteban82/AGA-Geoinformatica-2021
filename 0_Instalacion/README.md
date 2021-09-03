# Tarea 1

**Objetivo**: Instalar GMT y comprobar que todo está correctamente configurado en su PC.


Sigue los siguientes pasos para ejecutar algunos scripts de GMT y comprobar
que obtienes la salida correcta.


## Tarea

1. Sigue las [instrucciones de instalación](../INSTALL.md).
2. Abre una terminal (Mac: abre el app "Terminal"; Windows: abre "Git Bash").
   Los siguientes pasos deben hacerse en la terminal.
   Para correr un comando, escirbile y luego presiona *Enter*.
3. Corre este comando para descargar el material del curso usando [git](https://en.wikipedia.org/wiki/Git):

   ```
   git clone https://github.com/Esteban82/AGA-Geoinformatica-2021.git
   ```

   Esto creará una carpeta llamada `AGA-Geoinformatica-2021` en su computadora.
4. Run this command to navigate to the `hw1` folder in `2021-unavco-course` and figure
   out where it is placed on your computer (each line is a command):

   ```
   cd 2021-unavco-course/hw1
   pwd
   ```

5. Run the [`test_1.sh`](test_1.sh) script:

   ```
   ./test_1.sh
   ```

   A window should pop up with a colored relief map of northern Africa. It should look
   like this (on a Mac, Preview may make it look a bit smoother):

   ![`2021-unavco-course/hw1/output/test1.pdf`](salida/prueba1.png)
6. Run the [`test_2.sh`](test_2.sh) script:

   ```
   ./test_2.sh
   ```

   This should produce 2 files called `count.mp4` and `count.webm` in the
   `2021-unavco-course/hw1` folder. To open the mp4 movie (replace with `.webm`
   if the mp4 doesn't work on your system):

   * Mac: run `open count.mp4`
   * Linux: run `xdg-open count.mp4`
   * Windows: run `explorer count.mp4`

   The result should be an animation with numbers counting from 0 to 24 that looks like
   this:

   ![`2021-unavco-course/hw1/output/count.mp4`](salida/contar.gif)
7. Tell us if you were able to complete homework 1 (and give us some feedback so we can better prepare for the course) by filling out
   the following short [survey](https://forms.gle/FnEeTK9CLgYHBMzD9) by end of Saturday.
