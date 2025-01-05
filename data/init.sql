-- init.sql: This script will change the authentication method to mysql_native_password

ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'rootpassword';
FLUSH PRIVILEGES;
