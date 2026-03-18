**COMMIT: CREACIÓN DE PROYECTO E IMAGENES NECESARIAS**

En el primer commit simplemente se ha creado el proyecto en Flutter siguiendo los isguientes pasos:

1. Te ubicas en la carpeta donde quieres crear el proyecto y haces cd nombre_carpeta en tu cmd. 
2. Ejecutas flutter create nombre_de_tu_app.
3. Ahora haces cd en tu app (cd nombre_de_tu_app). 
4. Entro a la carpeta desde Android Studio para su configuración.

El siguiente paso es crear una carpeta "assets" donde meto todas las imágenes que mi app va a necesitar. 

Por último configuro el pubspec.yaml. 

****

**COMMIT: BARRA INFERIOR CREADA**

En este commit la app empieza a coger forma. Se crea el menú inferior, importante para la navegación entre las diferentes opciones de la app (inicio, novedades y perfil). 

Para ello, en el main.dart empiezo dando forma a la configuración visual de la app y elijo cuál es la primera pantalla que se debe mostrar. 

Declaro el listado de pestañas que va a tener la barra inferior de la app con un List<> y creo una función para saber qué mostrar depende de qué apartado esté abierto.

****

**COMMIT: CREACIÓN PANTALLA LOGIN Y REGISTRO**

Dentro de la carpeta lib creo la clase auth_pages.dart, donde va a estar el código de las páginas de login. 

Lo primero que pongo es la animación que se verá entre páginas, que en mi caso dura 0 segundos para que no se note el cambio (como en las redes sociales). 

Esta clase tiene diversos métodos para ser usados tanto como en la pantalla de inicio de sesión como en la de registro:

1. Método para la cabecera, que pone el logo y luego el texto encima (ambos siendo una imagen).
2. Método para crear el fondo de la app (imagen) ocupando todo el espacio sin deformarse. 
3. Método para la creación del botón de rol (artista u oyente). 

Y también la creación de widgets auxiliares como:

1. Un contenedor oscuro para los formularios. 
2. Los campos de texto grises redondeados. 
3. Botones grandes y azules. 

****

**COMMIT: PANTALLA ELECCIÓN AVATAR**

En este commit he creado la pantalla de elección de avatar que aparece al pulsar el botón de siguiente en el registro.

En la pantalla se reutiliza el header que creamos antes cambiando la imagen del título por la de registro, tiene un circulo que contiene las imagenes y flechas a ambos lados 
para avanzar o retroceder entre los avatares. Unas vez se pulse el botón se vuelve a la ventana de inicio de sesión.

En un futuro se enlazará para que se guarden los registros y sólo esos son los que pueden iniciar sesión.