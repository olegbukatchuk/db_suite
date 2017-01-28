#!/bin/bash

# Скрипт установки и настройки сервера PostgreSQL
# Автор:  Олег Букатчук
# Версия: 0.2 alpha
# e-mail: oleg@bukatchuk.com

# Подключаем файл c настройками DB Suite
. ./db_suite.conf

# Подключаем FTP и монтируем его в директорию $FTP
curlftpfs -v -o iocharset=UTF-8 ftp://user:password@ftp.domain.ru/ /mnt/ftp

# Информируем пользователя
echo "Проверка текущей конфигурации..."

# Проверяем наличие конфигурационных файлов, если файлов нет 
# выводим сообщение в консоль и останавливаем выполнение скрипта.
if [ ! -d $CONFIG_POSTGRESQL ];
    then
        # Информируем пользователя
        echo "В системе нет конфигурационных файлов сервера PostgreSQL!"\n
        echo "$CONFIG_POSTGRESQL"
        # Остановка скрипта
        exit 1
    else
        # Информируем пользователя
        echo "OK"
fi

# Проверяем наличие эталонных файлов, если файлов нет 
# выводим сообщение в консоль и останавливаем выполнение скрипта.
if [ ! -d $FTP ]; 
    then
        # Информируем пользователя
        echo "В системе нет эталонных конфигурационных файлов!"\n
        echo "$FTP"
        # Остановка скрипта
        exit 1
    else
        # Информируем пользователя
        echo "OK"
fi

# Информируем пользователя
echo "Применение эталонной конфигурации сервера..."

# Перезагужаем сервер для применения новой конфигурации
sudo service postgresql restart

# Информируем пользователя
echo "OK"

# Выводим статус сервера
sudo service postgresql status

echo "Настройка сервера PostgreSQL выполнена успешно!"
