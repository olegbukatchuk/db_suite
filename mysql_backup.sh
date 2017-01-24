#!/bin/bash

# Скрипт экспорта БД из MySQL 5.x/6.x
# Автор:  Олег Букатчук
# Версия: 1.0
# e-mail: oleg@bukatchuk.com

# Объявляем переменные для авторизации в MySQL
export HOST_MYSQL=some_localhost
export USER_MYSQL=some_login
export PASS_MYSQL=some_password
export DB_MYSQL=some_database

# Создаём константу из абсолютного пути к скрипту.
export RUN_ME=/path/to/script/backup_mysql.sh

# Создаём константу для директории хранения бекапов.
export STORAGE=/path/to/backup/mysql

# Проверяем наличие директории для бекапов, если директории нет 
# выводим сообщение в консоль и останавливаем выполнение скрипта.
if [ ! -d $STORAGE ];
    then
        # Информируем пользователя
        echo "В системе нет требуемой директории!"\n
        echo "$STORAGE"
        exit 1
    else
        # Информируем пользователя
        echo "Идёт создание дампа БД..."
fi

# Создаём дамп базы данных, архивируем и называем бекап текущей датой.
mysqldump --host=$HOST_MYSQL --user=$USER_MYSQL --password=$PASS_MYSQL $DB_MYSQL | gzip > $STORAGE/$(date +%Y-%m-%d).gz

# Информируем пользователя
echo "OK"

# Информируем пользователя
echo "Идёт поиск и удаление старых дампов БД..."

# Находим файлы старше 7 дней в директории $STORAGE и удаляем их.
find $STORAGE -type f -mtime +7 -exec rm -f {} \;

# Информируем пользователя
echo "ОК"

# Информируем пользователя
echo "Проверка наличия задания в Cron'e..."

# Преверяем наличие записи в планировщике, если нет выводим сообщение и подсказку.
if crontab -l | grep "$RUN_ME"; 
    then
        echo "OK"
    else
        echo "Добавьте задание в Cron."
fi

# Возвращаем общий результат, иначе возвращается результат выполнения последней команды.
exit 0

# Ставим скрипт на выполнение (из консоли) в 1 час 00 минут после полуночи ежедневно:  
# 0 1 * * * /path/to/scripts/backup_mysql.sh

# Cron шпаргалка:
# * * * * * "/команда/которая/будет/выполнена"
# - - - - -
# | | | | |
# | | | | ----- День недели (0 - 7) (Воскресенье=0 или 7, 0-Вс,1-Пн,2-Вт,3-Ср,4-Чт,5-Пт,6-Сб,7-Вс)
# | | | ------- Месяц (1 - 12)
# | | --------- Число (1 - 31)
# | ----------- Часы (0 - 23)
# ------------- Минуты (0 - 59)