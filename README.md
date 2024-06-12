Estos script de instalación deberán ejecutarse en órden.

Dentro de cada script existen variables que pueden personalizarse, deberían tener valores coherentes entre los distintos scripts.

El script 1, configura ubuntu en es_AR y timezone America/Argentina/Buenos_Aires
Debe reinciar el servidor para que impacten los cambios.

El script 2, actualiza ubuntu e instala las dependencias necesarias para odoo.
También crea el usuario de odoo en el sistema operativo, este usuario será utilizado para ejecutar el servicio y para la instalación de dependencias con pip.
Además habilita odoo como servicio pero no lo inicia debido a que habría que ejecutar los demás scripts con el servicio detenido.
Finalmente, este script también instala postgresql y configura el usuario utilizado para la conexión de odoo. Pide el nombre para la base de datos que será utilizada.

El script 3, instala y habilita los módulos de regaby.

Por último, el script 4 instala los módulo utilizados por aliare. Este script necesita el archivo de módulos comprimidos y los instalar en la carpeta de módulos de aliare.

El servicio de odoo se puede detener e iniciar utilizando el comando systemctl:
  $ sudo systemctl start odoo.service


NOTA: Para quitar la versión de docker, se debería bajar los contenedores de docker, según el video el comando sería con los comandos:
sd rmall para eliminar las imágenes de mermori
  $ sd rmall 
Mientras que con los siguientes comandos se puede iniciar nuevamente:
  $ oe -R 
  $ oe -r

> ### Importante
> Hay que modificar la configuración de openssl según indica [este](https://github.com/codize-app/odoo-argentina?tab=readme-ov-file#ubuntu-2004) documento de codize.
> 
> Editar el archivo de configuración:
> 
> `sudo nano /etc/ssl/openssl.cnf`
> 
> Agregar al inicio:
> 
> `openssl_conf = default_conf`
> 
> Agregar al final:
> 
> ```text
>  [ default_conf ]
>  ssl_conf = ssl_sect
>  [ssl_sect]
> system_default = system_default_sect
> [system_default_sect]
> MinProtocol = TLSv1.2
> CipherString = DEFAULT:@SECLEVEL=1
> ```
> 
> Guardar y reiniciar Odoo con el comando `sudo systemctl restart odoo.service`
