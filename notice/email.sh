#!/bin/bash

# Скрипт отправки e-mail уведомлений
# Автор:  Олег Букатчук
# Версия: 0.4
# e-mail: oleg@bukatchuk.com

# Подключаем файл c настройками DB Suite
. ../db_suite.conf

# Отправляем письмо
/usr/bin/sendEmail -f $FROM -t $MAILTO -u $NAME -m $BODY -s $SMTP_SERVER \
                   -o message-charset=utf-8 -o tls=no $MAILTO -xu $SMTP_LOGIN -xp $SMTP_PASS