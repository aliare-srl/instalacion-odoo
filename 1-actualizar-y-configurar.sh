#como se ejecuta un sh? 
# 1ro darle permiso de ejecucion chmod +x /ruta/al/archivo.sh
# ejecutar ./archivo.sh  (desde la carpeta que corresponda)
#!/bin/bash

echo "Configurando Locale: es_AR.UTF-8"
# Cambia # es_AR.* por es_AR.UTF-8 UTF-8
sudo sed -i -e "s/# es_AR.*/es_AR.UTF-8 UTF-8/" /etc/locale.gen
# genera el locale para es_AR.UTF-8
sudo locale-gen es_AR.UTF-8
# configura el locale
sudo dpkg-reconfigure -f noninteractive locales
# actualiza locale. Al final de este script se reinicia el server para que tome los cambios.
sudo update-locale LANG=es_AR.utf8

# No le encuentor sentido a configurar un teclado pero si hace falta, descomantar el siguiente bloque
#sudo tee -a /etc/default/keyboard > /dev/null <<EOT
#XKBMODEL="pc105"
#XKBLAYOUT="es"
#XKBVARIANT=""
#XKBOPTIONS="lv3:ralt_stwich"
#BACKSPACE="guess"
# EOT
#sudo dpkg-reconfigure keyboard-configuration -f noninteractive

echo "Configurando Zona Horaria: America/Argentina/Buenos Aires"
sudo timedatectl set-timezone America/Argentina/Buenos_Aires 

read -p "Presione enter para reiniciar el servidor y aplicar los cambios."
sudo reboot
