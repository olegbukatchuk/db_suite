# DB Suite v.1.7 [![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)
Скрипты для управления и резервного копирования MySQL/PostgreSQL 

### Возможности скриптов
- Создание дампов баз данных (по расписанию). 
- Ротация бекапов (поиск и удаление старых дампов).
- Отправка e-mail уведомлений (через SMTP-сервер).
- Режим отладки (запись выполнения любой команды в скриптах).
- Общий файл конфигарации (определение констант).

### В разработке
- Установка и настройка сервера MySQL (деплой нового сервера). 
- Установка и настройка сервера PostgreSQL (деплой нового сервера).
- Отправка сообщений в Telegram (любому пользователю мессенджера).

## Установка
Клонируем репозиторий:
```markdown
git clone https://github.com/olegbukatchuk/db_suite
```
и прописываем значения переменных и констант в конфиге db_suite.conf. 

### Пример работы скрипта
```markdown
user@host:~$ /path/to/db_suite/postgresql/postgresql_backup.sh 
Проверка наличия директории для хранения бекапов...
OK
Идёт создание дампа БД...
Загружено:  623MiB 0:00:20 [30.5MiB/s] [                        <=>                                ]
OK
Идёт поиск и удаление старых дампов БД...
ОК
Проверка наличия задания в Cron'e...
0 1 * * * /path/to/db_suite/postgresql/postgresql_backup.sh
OK
```
Все скрипты умеют работать, как с локальным, так и с сетевым сокетом, поэтому задание можно запускать не только на сервере, где находиться база данных, но и на удалённом хосте.

Не забудьте при необходимости повторения процедуры поставить задание в планировщик у себя на сервере.

Ставим скрипт на выполнение (из консоли) в 1 час 00 минут после полуночи ежедневно:

```markdown
crontab -e

# Добавляем в конец файла наше задание

0 1 * * * /path/to/db_suite/postgresql/postgresql_backup.sh
```
Сохраняем и перезапускаем Cron:

```markdown
sudo service cron restart
```
ВАЖНО! Для того, чтобы оправлялись e-mail уведомления о выполнении скрипта убедитесь, что в системе стоит утилита sendemail. Установить её можно с помощью данной команды:

```markdown
sudo apt-get install sendemail
```

Готово!

## Поддержка и контакты

Есть вопрос или предложение? Свяжитесь со мной любым удобным вам способом из представленных у меня на сайте [bukatchuk.com](https://bukatchuk.com/contacts/).
