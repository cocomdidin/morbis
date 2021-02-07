# Docker For Morbis Apps Development

Docker Running with Debian , Apache , Php 5, Oracle Database , Oracle Interface.

Support with : 
- Oracle XE 10g
- Instantclient 12
- Php 5.6
- Apache Server
- Linux Debian
- Django 3


# Installation
How to install Apps with docker

## Install Docker

	Download docker in https://docs.docker.com/get-docker/
	Run and install it.

## First Time Use
	1. This Docker must running in Linux Container
	2. Replace your app in to public/ and you can code your project in public/
	3. Replace your database in to database/
	4. Repalce Django app in backend/
	4. Finish and keep read README.md

## Install OracleXE 10g
Aplikasi ini sudah terinstall Oracle XE 10g secara otomatis, silakan akses http://localhost:1003/apex. (Apabila belum bisa akses, silakan tunggu 2 - 5 menit)
Buat User baru di http://localhost:1003/apex
Default root user -> ( system / oracle )

## Import DB
Folder untuk database ada di => /database/
Silakan paste / replace database dmp anda di folder database/ dengan format database.dmp lalu jalankan build docker kembali.

	$ ssh root@localhost -p 10000
	$ Input password : admin
	$ cd /home/database
	$ imp	

	Input username dan password database anda
	Ikuti Langkah - langkah
	Input username ketika export database

## Setup Application DB connection
	1. setting database anda seperti contoh # Sample Database
	2. replace db username dan password
		Username: usernamedb anda
		Password: passworddb anda
	3. replace db hostname 'oracledb'

## Sample Database For Web Morbis
	define('DB_NAME', 'xe'); 
	define('DB_USER', 'database_user');
	define('DB_PASSWORD', 'database_password');
	define('DB_HOST', 'host'); // => If Docker Database use : oracledb , If external database use : localhost , if from ip public use : your ip public
	define('DB_PORT','1521');
	define('DB_DRIVER', 'oci8'); 
	define('PAGINATE_LIMIT', 20);

## Sample Database For Backend Morbis
	'default': {
        'ENGINE': 'django.db.backends.oracle',
        'SID': 'xe',
        'USER': 'test1234',
        'PASSWORD': 'test1234',
        'HOST': 'oracledb',
        'PORT': '1521',
    }

## Default Usage
- Start Container
	$ docker-compose up -d

- Stop container
    $ docker-compose down

## Open Port
Port Usage

	:80 => 80 / application 
	:1000 => 22 ( root / admin )
	:1002 => 1521
	:1003 => 8080
	:443  => 443
	:8000 => 8000

## Test your deployment :
* Open [http://localhost](http://localhost) in your browser for run application
* Open [http://localhost:8000](http://localhost:8000) in your browser for run backend
* Open [http://localhost:1003/apex](http://localhost:1003/apex) in your browser for run oracle apex

## Run Docker with Instantly [recommended]
Open Run Docker Folder : 

    Run with shell script :
	
	1. build-docker.sh 
	2. start-docker.sh
	3. stop-docker.sh
	4. update-docker.sh
	5. restart-docker.sh

## Your application root in /public/
## Your backend root in /backend/