# yocto:LAMP FOR PHP-7

## 配置yocto的runqemu,添加端口映射

### 特殊情况

    本机配置低，通过ssh到服务器上，在配置很好的服务器上编译linux，并且运行qemu
    现在要用本机上的浏览器访问运行在服务器上的qemu中的linux

### 解决方法

    端口映射：启动qemu时，给启动参数添加一个端口映射
              hostfwd=tcp::2525-:80

    其中2525表示服务器的端口，80表示运行在qemu中的httpd服务端口，这样我们可以通过
    访问服务器的2525端口，达到访问qemu中httpd的目的。

## Start apache2

1. systemctl start apache2-service

## Start mysql and create example databases

1. mysqld_safe --user=mysql &
2. mysqladmin -u root password root
3. $mysql -uroot -p
4. mysql> show databases;
5. mysql> create database mysql_test;
6. mysql> use mysql_test;

## Create a table and the conditions

1. mysql> CREATE TABLE shop (article  INT(4) UNSIGNED ZEROFILL DEFAULT '0000' NOT NULL, \
                             dealer CHAR(20) DEFAULT '' NOT NULL, \
                             price DOUBLE(16,2) DEFAULT '0.00' NOT NULL, \
                             PRIMARY KEY(article, dealer));
2. mysql> INSERT INTO shop VALUES \
          (1,'A',3.45),(1,'B',3.99),\
          (2,'A',10.99),(3,'B',1.45),(3,'C',1.69),\
          (3,'D',1.25),(4,'D',19.95);
3. mysql> select * from shop

## Exit

   mysql> \q

## 添加一个配置文件使php7可以配合apache2工作

### 教程

   http://php.net/manual/en/install.unix.apache2.php

### 编写一个php7的配置文件

   LoadModule php7_module path_to_libphp*.so

   <FilesMatch \.php$>
       SetHandler application/x-httpd-php
   </FilesMatch>

   <FilesMatch "\.phps$">
       SetHandler application/x-httpd-php-source
   </FilesMatch>

### 配置apache2,如果出错，显示出来

    change in in /etc/php/apache2-php5/php.ini:
    display_errors = On
    display_startup_errors = On
    track_errors = On
    error_log = /var/log/apache2/logs/php_errors.log


## 编写php测试脚本

### 第一个

    phpinfo.php

   <?php
     phpinfo();
   ?>

### 第二个

    php-mysqli.php

   <?php
     echo "<br>php mysqli testing:<br>\n";
     // Connecting, selecting database
     $link = mysqli_connect('localhost', 'root', 'root')
     echo "Connected successfully<br><br>\n";
     mysqli_select_db($link, 'mysql_test') or die('Could not select database');

     // Performing SQL query
     $query = 'SELECT * FROM shop';
     $result = mysqli_query($link, $query) or die('Query failed: ' . mysqli_error());

     // Printing results in HTML
     echo "<table>\n";
     echo "\t<tr>\n";
     echo "\t\t<td>article</td>\n";
     echo "\t\t<td>dealer</td>\n";
     echo "\t</tr>\n";

     while ($line = mysqli_fetch_array($result, MYSQLI_ASSOC)) {
         echo "\t<tr>\n";
         foreach ($line as $col_value) {
             echo "\t\t<td>$col_value</td>\n";
         }
         echo "\t</tr>\n";
     }
     echo "</table>\n";

     // Free resultset
     mysqli_free_result($result);

     // Closing connection
     mysqli_close($link);

   ?>

## 测试

   http://server_ip:port/phpinfo.php
   http://server_ip:port/php-mysqli.php

### 如果安装了phpmyadmin
   http://server_ip:port/phpmyadmin
