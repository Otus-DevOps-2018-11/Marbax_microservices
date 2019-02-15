# Marbax_microservices
Marbax microservices repository

## HW12
<details><summary>Технология контейнеризации. Введение в Docker.</summary><p>

#### Установлен докер ,по мануалу с офф сайта 
#### Исследованы команды и возможности докера (в спойлере)

<details><summary>Работа с Docker:</summary><p>

Для работы нужны права рута(наверное)
- ```docker version``` вывести версию клиента и сервера докера
- ```docker info``` вывести информацию о докере и хосте
- ```docker ps```  вывести информацию о запущенных контейнерах. ```docker ps -a``` инфа о всех контейнерах. ```docker images``` инфа о сохраненных контейнерах
- ```docker run -it ubuntu:16.04 /bin/bash ``` создать и запустить контейнер ,который после выхода останется запущенным(не остается), ключ ```--rm``` то контейнер не останется после выхода из него
- ```docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.CreatedAt}}\t{{.Names}}" ``` инфа о контейнерах с временем создания 
- ```docker start <container_id>``` запускает уже созданый (остановленный) контейнер
- ```docker atach <container_id>``` подсоединяет терминал к созданному контейнеру
- ```docker run -i``` = docker create + docker start + docker attach*
  - -i  – запускаетконтейнерв foreground режиме (docker attach) 
  - -d – запускаетконтейнерв background режиме
  - -t создает TTY 
  - docker run -it ubuntu:16.04 bash 
  - docker run -dt nginx:latest
- ```docker exec``` запускает новый процесс внутри контейнера
- ```docker commit <containet_id> <your_name>/<repo>``` создает image из контейнера, контейнер остается запущенным (наверное) ,можно делать из не запущенных контейнеров
- ```docker inspect <container_id>``` инфа об контейнере , точное описание параметров контенера 
- ```docker inspect <image_id>``` инфа об образе , описание того ,кто сделал когда и тд , количество уровней и базовая инфа о том что в нем 
- ```docker kill <container_id>``` убивает сразу 
- ```docker stop <container_id>``` останавливает и через 10 сек убивает
- ```docker system df``` отображает инфу о размере контейнеров
- ```docker rm <container_id>``` удаляет контейнер , ключ ```-f``` удаляет запущенный контейнер
- ```docker rmi <image_id>``` удаляет образ ,если от него не зависят запущенные контейнеры
- ```docker rm $(docker ps -a -q)``` удалить все контейнеры . ```docker rmi $(docker images -q)``` удалить все образы 

</p></details>

</p></details>

## HW13
### Docker контейнеры. Docker под капотом

- Для gcloud выбран другой проект docker 
- Установлен docker-machine ```https://docs.docker.com/machine/install-machine/```

#### Создание docker host
- ```export GOOGLE_PROJECT=docker-231712``` - добавление проекта в переменную окружения для текущего сеанса
- ```docker-machine create --driver google --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts --google-machine-type n1-standard-1 --google-zone europe-west1-b docker-host``` - создание виртуалки (экранировка перехода на новую строку не сработала чего то )
- Включен API ```https://console.developers.google.com/apis/api/compute.googleapis.com/overview?project=542682605071``` ( а может подождать просто нужно было)
- ```docker-machine ls``` - посмотреть docker-хосты
- ```eval $(docker-machine env docker-host)``` переключение на удаленный Docker-хост

#### Создание своего образа
- ```docker run --rm -ti tehbilly/htop``` - пид немспейсы изолированы 
- ```docker run --rm --pid host -ti tehbilly/htop``` - контейнер видит процессы хоста
- Создан Dockerfile в котором описано обновление кеша репозитория ,установка нужных пакетов ,скачиваетсяприложение с гита , копируются подготовленые файлы в контейнер ,установлены зависимости ,добавил старт сервиса при старте контейнера .
- Собран образ ```docker build -t reddit:latest .``` - точка в конце указывает путь до до Docker-контекста ,флаг -t задает тег для собраного образа
- ```docker run --name reddit -d --network=host reddit:latest``` - запустил контейнер на удаленном хосте
- ```gcloud compute firewall-rules create reddit-app --allow tcp:9292 --target-tags=docker-machine --description="Allow PUMA connections" --direction=INGRESS``` - создаем правило фаервола для открытия порта 

#### Работа с Docker Hub
- https://hub.docker.com/ зарегестрировался на DockerHub , ```docker login``` залогинился из докера
- ```docker tag reddit:latest <your-login>/<repo> ``` добавлен образ , ```docker push <your-login>/<repo>``` закинут в ДокерХаб
- Т.к. образ лежит теперь в ДокерХабе ,можно запустить его в любом месте ```docker run --name reddit -d -p 9292:9292 <your-login>/<repo>```
- ```docker run --name reddit -d -p 9292:9292 <your-login>/<repo>``` запустить в другом месте (скачается с хаба) с дэбагом (-d)


<details><summary>docker-machine :</summary><p>

 - docker-machine - встроенный в докер инструмент для создания хостов и установки на них docker engine. Имеет поддержку облаков и систем виртуализации   (Virtualbox, GCP и др.)
 -  Команда создания - ```docker-machine create <имя>```. Имен может быть много, переключение между ними через ```eval $(docker-machine env <имя>)```. Переключение на локальный докер - ```eval $(docker-machine env --unset)```. Удаление -```docker-machine rm <имя>```.
 - docker-machine создает хост для докер демона со указываемым образом в --googlemachine-image, в ДЗ используется ubuntu-16.04. Образы которые используются для построения докер контейнеров к этому никак не относятся.
 - Все докер команды, которые запускаются в той же консоли после eval ```$(docker-machine env <имя>)``` работают с удаленным докер демоном в GCP.

</p></details>

- ```docker logs reddit -f``` посмотреть логи контейнера
- ```docker exec -it reddit bash``` подключится к контейнеру ,в баше ```killall5 1``` убить основной процесс ,умрет и контейнер
- ```docker start reddit``` запустить остановленый контейнер по дэфолту(сразу останавливает почему то )
- ```docker stop reddit && docker rm reddit``` остановить и удалить контейнер
- ```docker run --name reddit --rm -it <your-login>/otus-reddit:1.0 bash ``` создать и запустить контейнер и подключиться к нему ,при выходе он остановится
- ```docker inspect <your-login>/<repo>``` рассмотреть образ 
- ```docker inspect <your-login>/<repo> -f '{{.ContainerConfig.Cmd}}' ``` посмотреть как запускается контейнер (исследовать конретный параметр )
- ```docker diff <container_name>``` посмотреть изменения в контейнере

### Задание с *
Не выполнено ,т.к. еще тянет три доп задания из прошлых дз ,которые тоже не сделаны




