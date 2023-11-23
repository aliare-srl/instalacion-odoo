echo "habilitar el firewall el puerto 8069 que es el por defecto de odoo"
echo "Ahora que ya hemos instalado Odoo correctamente, instalaremos NGINX para poder acceder a través de un dominio"
echo "(o subdominio) y con HTTPS, instalando un certificado SSL Let’s Encrypt."

sudo apt install nginx

echo "desde el navegador colocando el ip de la maquina ya debería aparecer la binvenida de nginx si esta bien instalado"

echo "Ahora crearemos un vHost de Nginx para el dominio (o subdominio en nuestro caso) y lo configuraremos "
echo "con la modalidad de proxy reverso."

echo "Deberás reemplazar el nombre del archivo y el valor de server_name con tu propio dominio (o subdominio)."

cd /etc/nginx/sites-available

sudo nano odoo.aliare.com.ar

#copiar este contenido en el archivo, reemplazar el ip por el dominio, o por otro IP publico.

server {
        listen 80 default_server;
        server_name 200.58.103.232;
        

        location / {
                proxy_pass http://127.0.0.1:8069/;
        }
}


#generar el enlace entre el archivo de enabled al archivo en available.

cd /etc/nginx/sites-enabled

#borro el servidor por defecto

rm default

sudo ln -s /etc/nginx/sites-available/odooaliare.com.ar odoo.aliare.com.ar

#si la ste linea no da error esta todo ok

sudo nginx -t 

#se reinicia el nginx 
systemctl restart nginx.service 

#ya se podria acceder desde el ip publico al odoo.

#Instalar certificado SSL certificado SSL Let’s Encrypt instalando en primer lugar el programa Certbot.
sudo apt install certbot python3-certbot-nginx

#Una vez instalado Certbot, generaremos e instalaremos el certificado SSL para nuestro dominio (o subdominio
certbot --nginx -d odoo.aliare.com.ar

