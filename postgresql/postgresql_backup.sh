#!/bin/bash

# Скрипт экспорта БД из PostgreSQL
# Автор:  Олег Букатчук
# Версия: 1.9
# e-mail: oleg@bukatchuk.com

# Подключаем файл c настройками DB Suite
source "../db_suite.sh"

# Информируем пользователя
echo "Проверка наличия директории для хранения бекапов..."

# Проверяем наличие директории для бекапов, если директории нет 
# выводим сообщение в консоль и останавливаем выполнение скрипта.
if [ ! -d $STORAGE ]; 
    then
        echo "В системе нет требуемой директории!"\n
        echo "$STORAGE"
        exit 1
    else 
        echo "OK"
fi

# Информируем пользователя
echo "Идёт проверка зависимостей скрипта..."

# Проверяем наличие утилиты pv, если нет ставим её.
if [ "" == "$PV_OK" ]; 
then
    # Ставим пакет pv (для отрисовки прогресс-бара).
    echo "Установка зависимостей скрипта..."
    sudo apt-get --force-yes --yes install pv
fi

# Проверяем наличие утилиты sendemail, если нет ставим её.
if [ "" == "$SENDEMAIL_OK" ]; 
then
    # Ставим пакет sendemail (для отправки писем).
    sudo apt-get --force-yes --yes install sendemail
fi

# Информируем пользователя
echo "OK"

# Информируем пользователя
echo "Идёт создание дампа БД..."

# Создаём дамп базы данных, рисуем прогресс бар, называем бекап текущей датой и архивируем его.
pg_dump --dbname=$CONNECT_DB | pv -N "Загружено" \
                             > $STORAGE/$(date +%Y-%m-%d).sql \
                             | gzip > $STORAGE/$(date +%Y-%m-%d).sql.gz

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
if crontab -l | grep "$RUN_POSTGRESQL_BACKUP";
    then
        echo "OK"
    else
        echo "Добавьте задание в Cron."
fi

# Информируем пользователя
echo "Отправка отчёта на e-mail..."

# Отправляем письмо с указанием имени сервера на котором выполнился скрипт.
source "$NOTICE/email.sh" "$SERVER_NAME: backup $(date +%Y-%m-%d) готов!" "$SPACE_USED"

# Информируем пользователя
echo "OK"

# Возвращаем общий результат, иначе возвращается результат выполнения последней команды.
exit 0

# Cron шпаргалка:
# Например, так: 0 1 * * * $RUN_ME (ежедневно в 1 час 00 минут после полуночи).

# * * * * * "/команда/которая/будет/выполнена"
# - - - - -
# | | | | |
# | | | | ----- День недели (0 - 7) (Воскресенье=0 или 7, 0-Вс,1-Пн,2-Вт,3-Ср,4-Чт,5-Пт,6-Сб,7-Вс)
# | | | ------- Месяц (1 - 12)
# | | --------- Число (1 - 31)
# | ----------- Часы (0 - 23)
# ------------- Минуты (0 - 59)
