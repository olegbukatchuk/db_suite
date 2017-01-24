#!/bin/bash

# Скрипт настройки сервера PostgreSQL 9.x
# Автор:  Олег Букатчук
# Версия: 0.1
# e-mail: oleg@bukatchuk.com

# Создаём константу для подключеня к базе данных.
export CONNECT_DB=postgresql://password:login@127.0.0.1:5432/database

# Создаём константу из абсолютного пути к скрипту.
export RUN_ME=/path/to/script/postgresql_tunning.sh

# Создаём константу для директории хранения конфигов.
export FILES=/path/to/backup/dir

# Информируем пользователя
echo "Чтение эталонной конфигурации сервера..."

# Проверяем наличие конфигурационных файлов, если файлов нет 
# выводим сообщение в консоль и останавливаем выполнение скрипта.
if [ ! -f $FILES ]; 
    then
        echo "В системе нет эталонных конфигурационных файлов!"\n
        echo "$FILES"
        exit 1
    else 
        echo "OK"
fi

# Информируем пользователя
echo "Применение эталонной конфигурации сервера..."

echo "OK"

# Перезагужаем сервер для применения новой конфигурации
sudo service postgresql restart

# Выводим статус сервера
sudo service postgresql status

echo "Настройка сервера PostgreSQL выполнена успешно!"
