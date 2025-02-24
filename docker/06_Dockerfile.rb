puts '                                             Dockerfile'

# Dockerfile (можно без расширений или добавить кастомные) - фаил содержит инструкцию как именно нужно упаковать наше приложение в наш новый образ. Содержит описание подключаемых образов и различные настройки для образов и подключаемых технологий, чтобы создать наш образ на их основе.

# Готовое срдержание для Dockerfile есть на странице каждого образа в Docker Hub, можно скопировать оттуда, чтобы создать точно такой же образ самому или добавить его в свой составной образ



puts '                                     Содерание и команды Dockerfile'

# https://docs.docker.com/reference/dockerfile/

# Dockerfile состоит из разных команд, они запускаются послеовательно сверху вниз по расположению в Dockerfile, нужно это учитывать при их записи. Каждая команда при сборке образа будет "слоем" в "слоеном пироге" образа, который изначально состоит из "слоев" из которых собран образ из команды FROM (тк например для работы питона нужен какой-то фунеционал от ОС, настройки итд)

# Можно задавать несколько одинаковых команд в одном Dockerfile, пример Dockerfile(python+app), где 2 команды RUN


# 1. FROM – указывает какой образ будет использован(скачает из Докер Хаба если его у нас нет локально) как базовый, с которого мы начнем сборку (например openjdk). Например если у нас приложение скрипт на Питоне, то нам нуен Питон. Можно дополнительно указать через двоеточие "тег", тут версию Джавы (например :11), по умолчанию будет последняя версия. Можно после версии указать еще и сервер(например -apache).
# FROM php:7.2-apache                  - образ php версии 7.2, сервер apache
# FROM python:3.6                      - образ python версии 3.6

# 2. WORKDIR – указывает рабочую директорию в образе. Все команды в контейнере будут выполняться относительно этого каталога. Это папка по умолчанию, в которой вы запускаете среду разработки. Моно назвать её как угодно.
# WORKDIR /usr/src/myapp                - устанавливаем директорию /usr/src/myapp в контейнере рабочей
# WORKDIR /home/app

# 3. COPY – указывает какие файлы (по их местоположению относительно расположения Dockerfile) из нашего проекта будут скопированы на хост машину(в контейнере/образе). Принимает 2 параметра: путь к фаилам (относительно расположения Dockerfile), которые хотим скопировать, на нашем ПК (откуда копируем); путь контейнере (куда копируем)
# COPY .	/usr/src/myapp               - копируем (?все?) из "." (текущей диретории) в директорию контейнера "/usr/src/myapp"
# COPY requirements.txt ./             - помещаем фаил requirements.txt в ./ рабочую директорию, если мы ее уже установили в WORKDIR, иначе нужно былоб прописать полный путь, например /usr/src/app

# 4. EXPOSE – указывает/декларирует(сам проброс не выполняется) порт для проекта, который будем пробрачывать наружу(из контейнера). Нужен, если в образе есть локальный сервер(локалхост)
# EXPOSE 80                   - декларируем что будем пробрасывать порт контейнера 80 наружу для локального компьютера
# EXPOSE 8001                 - декларируем что будем пробрасывать наружу порт 8001
# EXPOSE $PORT                - пробросим порт 3000 (который мы настроили через ENV PORT 3000)

# 5. RUN – команда, что выполнится один раз при создании образа (?? если что-то запускаем нужно указать фаилы из WORKDIR рабочей директории образа ??). Это инструкции по настройке, которые нужно выполнить в терминале перед его использованием, ещё до того, как начали использовать среду разработки, чтобы всё было готово к использованию. Любая команда технологий приложения, которое будет запакованно в образ, так же можно создавать новые директории и выполнять другие команды терминалов.
# RUN	javac Main.java                  - запускаем компилятор Джавы javac и компилируем исполняемый фаил Main.java
# RUN mkdir -p /usr/src/app/           - создаем директорию /usr/src/app/
# RUN pip install -r requirements.txt  - берем библиотеки из фаила requirements.txt и устанавливаем их (pip бандлер Питона)
# RUN cmod a+x ./run.sh                - установим права на запуск фаила run.sh (там например длинная команда запуска веб сервера)
# RUN gem install rails                - установим Ruby on Rails
# RUN apt-get update -qq && apt-get install -y nodejs   - установим Node.js

# 6.a. CMD – эта команда сообщает Docker, какую команду нужно выполнять при каждом запуске контейнера (docker start / docker run) (?? нужно указать фаилы из WORKDIR рабочей директории образа ??). Выполняет команды через Shell, тоесть запускается оболочка /bin/sh (тоже что в верхней строке шелл скриптов)
# (??? Может быть только 1 такая команда, тк несколько не работли у меня, работала только последняя)
# CMD ["python", "app.py"]             - будет выполнять команду "python app.py", тоесть запустит скрипт на Питоне
# CMD ["java", "Main"]                 - будет выполнять команду "java Main.java", тоесть запустит скомпилированный при помощи "RUN javac Main.java" фаил

# 6.b. ENTRYPOINT - команда, делает все тоже самое что и CMD, только выполняет команды без использования Shell(/bin/sh)
# ENTRYPOINT ["python", "app.py"]
# ENTRYPOINT ["./run.sh"]              - запустим скрипт run.sh (там например длинная команда запуска веб сервера)
# ENTRYPOINT ["/bin/bash"]             - запустим терминал bash, чтобы получить доступ к Rails

# 7. ENV - команда указывающая переменные окружения, например временную зону, какието айдишники, какието адреса на внешние сервисы итд. Команда принимает переменную окружения и через пробел ее значение. Если переменные окружения меняются, то лучше из задать в опциях команды run, а не в Dockerfile
# ENV TZ Europe/Moscow                 - добавляем переменную окружения с именем "TZ", в которой задаем временную зону Москвы
# ENV PORT 3000                        - установит переменную с именем $PORT в вашем терминале bash на значение «3000»



puts '                                         build (Сборка образа)'

# build - команда позволяет построить наш образ по инструкции из Dockerfile. Нужно прописать путь к созданному Dockerfile и опционально можно задать имя образу. Потом если выполнить 'docker images' мы увидим новый созданный образ в списке, у которого есть айди и можем даллее запустить его при помощи "run" если нужно.
# id образа(есть так же у каждого слоя) это хэш-сумма SHA-256

# -t   - флаг задает название образа. Нельзя чтоб название образа содержало спец символы и символы в верхнем регистре

# > docker build ./php                   - собираем образ по Dockerfile, который находится по пути "./php"
# > docker build -t my-php-app ./php     - собираем образ и даем ему название "my-php-app"
# $ docker build -t hello-world .        - собираем образ с названием hello-world, из текущей директории "."

# (Если при вводе команды "docker build" выдает ошибку "failed to solve: the Dockerfile cannot be empty" -  это значит что не был сохранен сам файл проекта)


# > docker run -p 8001:80 -d my-php-app        - запуск созданного по имени с указанием портов

# Порт который работает на нашем компе (8001) можно указывать каким угодно именно го указываем после локалхосст в адресе. А связываться мы будем с портом который прописали в строке EXPOSE














#
