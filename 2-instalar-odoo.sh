#!/bin/sh
**Importante:** cuando se instala algo con sudo, dentro del un entorno virtual (con virtualenv por ejemplo) , la libreria o librerias se instalan en el SO global, no en el entorno virtual.
Ejecutar pip3 install son sudo. para asegurarse que se instale en el entorno virtual.



echo INSTALANDO DEPENDENCIAS CON APT
echo -----------------------
sudo apt update
sudo apt upgrade -y
sudo apt install -y python3 python3-pip
sudo apt install -y python3-dev libxml2-dev libxslt1-dev libldap2-dev libsasl2-dev \
    libtiff5-dev libjpeg8-dev libopenjp2-7-dev zlib1g-dev libfreetype6-dev \
    liblcms2-dev libwebp-dev libharfbuzz-dev libfribidi-dev libxcb1-dev libpq-dev

#echo INSTALLING NPM
#echo -----------------------
#sudo apt-get install -y npm
#sudo npm install -g rtlcss
#sudo npm install -g less less-plugin-clean-css
#sudo apt-get install -y node-less

echo INSTALANDO WKHTML2PDF
echo -----------------------
wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.focal_amd64.deb
sudo apt -y install ./wkhtmltox_0.12.5-1.focal_amd64.deb


ODOO_USER=odoo
echo CREANDO USUARIO $ODOO_USER
echo -----------------------
sudo adduser --system --quiet --shell=/bin/bash --home=/opt/$ODOO_USER --group ${ODOO_USER}
ls /opt/$ODOO_USER
echo
echo INSTALANDO POSTGRESQL
echo -----------------------
sudo apt install -y postgresql postgresql-server-dev-all
echo CREANDO DATABASE USER $ODOO_USER.
echo -----------------------
echo 
sudo su - postgres -c "createuser --superuser --createdb --login $ODOO_USER" 
#2> /dev/null || true
#sudo su postgres
#createuser --createdb --username postgres --no-createrole --no-superuser $ODOO_USER
#odoo psw
#psql
#ALTER USER odoo WITH SUPERUSER;
#\q
#exit
#echo USUARIO Odoo OK
echo ODOO
echo -----------------------



cd /opt/$ODOO_USER
sudo git clone https://github.com/odoo/odoo.git --depth 1 --branch 15.0 --single-branch 
sudo chown -R $ODOO_USER:$ODOO_USER /opt/$ODOO_USER
sudo su - odoo -c "cd /opt/$ODOO_USER/odoo && pip3 install -r requirements.txt"
echo 
echo POST-INSTALLATION
echo -----------------------
sudo mkdir -p /var/log/$ODOO_USER
sudo chown $ODOO_USER:root /var/log/$ODOO_USER
read -p "Nombre DB[$ODOO_USER]:" DB_NAME
DB_NAME=${DB_NAME:-$ODOO_USER}
echo "La base de datos será $DB_NAME"
CONFIG_FILE=/etc/$ODOO_USER.conf
if [ -f "$CONFIG_FILE" ]; then
	sudo rm -f $CONFIG_FILE
fi
sudo tee -a $CONFIG_FILE <<EOF > /dev/null
[options]
; This is the password that allows database operations:
; admin_passwd = admin
db_host = False
db_port = False
db_user = False
db_password = False
addons_path = /opt/$ODOO_USER/odoo/addons
logfile = /var/log/$ODOO_USER/odoo.log
unaccent = True
db_name = $DB_NAME
dbfilter = $DB_NAME
server_wide_modules = base,web
http_interface = 127.0.0.1
proxy_mode = True
EOF

sudo chown $ODOO_USER: /etc/$ODOO_USER.conf
sudo chmod 640 /etc/$ODOO_USER.conf

echo ODOO SERVICE
echo -----------------------
SERVICE_FILE=/etc/systemd/system/$ODOO_USER.service
if [ -f "$SERVICE_FILE" ]; then
	sudo rm -f $SERVICE_FILE
fi
sudo tee -a $SERVICE_FILE <<EOF > /dev/null 
[Unit]
  Description=Odoo ERP - Aliare SRL
  Documentation=http://www.odoo.com
  Requires=postgresql.service
  After=network.target postgresql.service
[Service]
  SyslogIdentifier=odoo15
  PermissionStartOnly=true
  User=$ODOO_USER
  Group=$ODOO_USER
  StandarOuput=journal+console
  Restart=always
  RestartSec=3
  Type=exec
  User=$ODOO_USER
  ExecStart=/usr/bin/env python3 /opt/$ODOO_USER/odoo/odoo-bin -c $CONFIG_FILE
[Install]
  WantedBy=default.target
EOF

sudo chmod 0644 /etc/systemd/system/odoo.service

sudo mkdir -p /var/opt/$ODOO_USER/data_dir #estaba con minuscula
#sudo chown -R $ODOO_USER:$ODOO_USER #me daba error chown: falta un operando después de «odoo:odoo»
sudo chown -R $ODOO_USER:$ODOO_USER /var/opt/$ODOO_USER

# en la ste linea me da este error
#  File "/opt/odoo/.local/lib/python3.8/site-packages/psycopg2/__init__.py", line 127, in connect
#    conn = _connect(dsn, connection_factory=connection_factory, **kwasync)
#psycopg2.OperationalError: FATAL:  role "odoo" does not exist

sudo su - odoo -c "/usr/bin/env python3 /opt/$ODOO_USER/odoo/odoo-bin -c $CONFIG_FILE --language es_AR --load-language es_AR --init base,web,point_of_sale --data-dir /var/opt/$ODOO_USER/data_dir --without-demo all --save --db-template template1 --no-database-list --stop-after-init"



sudo systemctl enable odoo.service # Habilita el servicio para iniciarse con el SO
echo "Para iniciar el servicio use: 'sudo systemctl start $ODOO_USER.service'"

#echo "Para probar desde el http://ip:8069 usuario admin password admin"
