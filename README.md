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
<details><summary>Docker контейнеры. Docker под капотом</summary><p>

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

</p></details>


## HW14
<details><summary> Docker-образы Микросервисы</summary><p>


#### Научился описывать и собирать Docker-образы для сервисного приложения
- Используется Visual Code и встроеный форматер для Докер файлов
- Лучшие практики докера ```https://docs.docker.com/develop/develop-images/dockerfile_best-practices/```
- Скачан архив с приложением
- Описаны Докер файлы 
- Создал bridge-сеть для приложения с сетевивы алисасами (могут быть использованы ,как доменные имена) ```docker network create reddit```
- Пакеты альпайна ```https://pkgs.alpinelinux.org/packages``` 
- Создан volume ```docker create volume reddir_db``` и подключен к монге ```-v reddit_db:/data/db```
#### Научился оптимизировать работу с Docker-образами
- Образы уменьшены до 36-106 МБ с ~700
#### Запускал приложения на основе Docker-образов, оценены удобства запуска контейнеров при помощи docker run
- Контейнер для БД ```docker run -d --network=reddit --network-alias =post_db --network-alias=comment_db mongo:latest```
- Контейнер ```docker run -d --network=reddit --network-alias=post <hub_login>/rep```
- Крнтейнер ```docker run -d --network=reddit --network-alias=comment <hub_login>/rep```
- Контейнер ```docker run -d --network=reddit -p 9292:9292 <hub_login>/rep```
#### Разбил приложение на несколько компонентов
#### Запустил микросервисное приложение

</p></details>

## HW15
<details><summary> Сетевое взаимодействие Docker контейнеров.</summary><p>

#### Разобрался с работой сети в Docker
#### none 
- Контейнер без сетевого доступа наружу ```docker run -ti --rm --network none joffotron/docker-net-tools -c ifconfig```. joffotron/docker-net-tools контейнер с сетевыми тулзами. --network none запуск без внешней сети
- При многократном запуске контенейры не будут конфликтовать ,т.к. у каждого свой ИП неймспейс 
#### host 
- Контейнер в сетевом пространстве хоста ```docker run -ti --rm --network host joffotron/docker-net-tools -c ifconfig```  , вывод такой же как и в ```docker-machine ssh docker-host ifconfig``` 
- При многократном запуске ```docker run --network host -d nginx``` ,спустя несколько секунд старый контейнер будет остановлен , т.к. они используют один ИП неймспейс
#### bridge
- ```docker network create reddit --driver bridge``` создаем свой бридж и подымаем контейнеры с сервисами в нем , т.к. сервисы ссылаются друг на друга по днс именам ,прописаным в Докерфалах ,то в новой инсталяции нужно добавить алиасы
 - ```docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest```
 - ```docker run -d --network=reddit --network-alias=post <your-login>/post:1.0```
 - ```docker run -d --network=reddit --network-alias=comment  <your-login>/comment:1.0```
 - ```docker run -d --network=reddit -p 9292:9292 <your-login>/ui:1.0```
```--name <name> (можнозадатьтолько 1 имя) --network-alias <alias-name> (можнозадатьмножествоалиасов)```
#### double bridge
- Создал две подсети ```docker network create back_net --subnet=10.0.2.0/24``` и ```docker network create front_net --subnet=10.0.1.0/24```
- ```docker run -d --network=front_net -p 9292:9292 --name ui  <your-login>/ui:1.0```
- ```docker run -d --network=back_net --name comment  <your-login>/comment:1.0```
- ```docker run -d --network=back_net --name post  <your-login>/post:1.0```
- ```docker run -d --network=back_net --name mongo_db --network-alias=post_db --network-alias=comment_db mongo:latest```
- При инициализации контейнера ,докер может подключить к нему только одну сеть ,```docker network connect <network> <container>``` подключение доп сетей.
- ```docker network connect front_net post``` и ```docker network connect front_net comment```

### Docker-compose 

#### Установить docker-compose на локальную машину
- Установлен из apt
- Для корректной работы ямля нужно добавить в имя пользователя в переменные окружения
#### Собрать образы приложения reddit с помощью docker-compose
- В директории с docker-compose файлом выполнить ```sudo docker-compose up -d``` для поднятия описаной инфраструктуры , если есть переменные окружения ,они будут искаться по дэфолту в ```.env``` файле
#### Запустить приложение reddit с помощью docker-compose
- Имя проекта генерится от расположения compose.yml можно поменять с помощью переменной окружения COMPOSE_PROJECT_NAME

</p></details>


<details><summary>HW 16 Устройство Gitlab CI. Построение процесса непрерывной поставки</summary><p>

#### Подготовить инсталляцию Gitlab CI
- С помощью тераформа поднят инстанс, установлен докер и скинут кофиг компоса для гитлаба
- Создана группа и проект
<details><summary>Добавлен раннер из консоли хоста гитлаба</summary><p>

docker run -d --name gitlab-runner --restart always -v /srv/gitlab-runner/config:/etc/gitlab-runner -v /var/run/docker.sock:/var/run/docker.sock gitlab/gitlab-runner:latest
</p></details>

- Потом раннер зарегестрирован ```docker exec -it gitlab-runner gitlab-runner register --run-untagged --locked=false```

<details><summary>Вывод</summary><p>

Runtime platform                                    arch=amd64 os=linux pid=12 revision=4745a6f3 version=11.8.0
Running in system-mode.                            
                              
Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com/):
http://35.198.143.87
Please enter the gitlab-ci token for this runner:
-YsdSsh14vVyFLkCFLe3
Please enter the gitlab-ci description for this runner:
[9c921c64a898]: my-runner
Please enter the gitlab-ci tags for this runner (comma separated):
linux,xenial,ubuntu,docker
Registering runner... succeeded                     runner=-YsdSsh1
Please enter the executor: docker+machine, kubernetes, docker, shell, ssh, virtualbox, docker-ssh, parallels, docker-ssh+machine:
docker
Please enter the default Docker image (e.g. ruby:2.1):
alpine:latest
Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded!

</p></details>

#### Подготовить репозиторий с кодом приложения
- Добавлено реддит приложение ```git clone https://github.com/express42/reddit.git && rm -rf ./reddit/.git``` и закомичено
#### Описать для приложения этапы пайплайна
- Дописаны тесты для пайплайна
#### Определить окружения
- Добавлены два окружения ,которые включаются только с тегами ```git tag 1.0.0``` , ```git push gitlab gitlab-ci-1 --tags``` и по мануальной кнопке 

</p></details>

<details><summary> HW17 Введение в мониторинг. Системы мониторинга.</summary><p>

#### Prometheus: запуск, конфигурация, знакомствосWeb UI 
- Создано правило фаервола для Prometheus и Puma: ```gcloud compute firewall-rules create prometheus-default --allow tcp:9090``` и ```gcloud compute firewall-rules create puma-default --allow tcp:9292 ```
 
<details><summary> Создадан Docker хост в GCE и настроено локальное окружение на работу с ним</summary><p>

```

gcloud compute firewall-rules create prometheus-default --allow tcp:9090

gcloud compute firewall-rules create puma-default --allow tcp:9292

export GOOGLE_PROJECT=_proj_

docker-machine create --driver google \
    --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
    --google-machine-type n1-standard-1 \
    --google-zone europe-west1-b \
    docker-host

eval $(docker-machine env docker-host)

docker run --rm -p 9090:9090 -d --name prometheus  prom/prometheus

docker-machine ip docker-host

docker stop prometheus

```

</p></details>

- Установлен готовый образ из докер хаба ```docker run --rm -p 9090:9090 -d --name prometheus  prom/prometheus:v2.1.0```
- Для удобства структура директорий изменена ,изменения сверены с содержимым гитигнора
- Описан докер файл для прометеуса ,который копирует .yml конфиг в контейнер 
- Образы сервисов собраны по скриптам для хелсчеков
- compose.yml отредактирован под новые требования ,добавлен подьем прометеуса со своим волюмом и ограничением хранения данных в один день и добавлен во внутреннюю сеть. Так же ,для сервисы определены образы ,а не билды
#### Мониторинг состояния микросервисов
- Проведены эксперементы с реакцией прометеуса, при отключении одного из сервисов 
#### Сбор метрик хоста с использованием экспортера
- В compose.yml добавлено описание node-exporter для сбора метрик с хоста , так же добавлен во внутреннюю сеть
- В конфиг прометеуса добавлен джоб для node-exporter , потом прометеус пересобран с новыми изменениями ,перезапущен compose.yml 
- Проверено как прометеус отображает график нагрузки цп хоста 
- Образы запушены на докер хаб
- VM docker-host удален :с 
Ссылка на докер хаб с образами - https://hub.docker.com/u/marbax
#### Заданиясо *
- Не сделаны ,нужно догонять

</p></details>

<details><summary> HW18 Мониторингприложенияиинфраструктуры</summary><p>

#### Мониторинг Docker контейнеров
- compose файлы разделены - один для приложения , другой для мониторинга 
- Добавлено описание сервиса cAdvisor , в ямле прометеуса создан джоб для cAdvisor также 
- Прометеус пересобран
#### Визуализация метрик
- Добавлен сервис Grafana, логин и пароль задается при в compose файле 
- json дашборда скачан с сайта Grafana и импортирован
#### Сбор метрик работы приложения и бизнес метрик
- В ямль Prometheus добавлен джоб для пост сервиса 
- Пересобран контейнер прометеуса и весь compose 
- Построены два простых графика в Grafana 
- Добавления третьего графика с ограничением по 95му перцентилю
- Конфиг сохранен и экспортирован
- Для сбора бизнес метрик построены 2 графика : по росту кол-ва постов и комментариев  , они так же сохранены в отдельный файл и экспортированы
#### Настройка и проверка алертинга
- Используется Alertmanager Prometheus'а ,т.к. он еффективнее
- Описан Dockerfile для Alertmanager
- Добавлен конфиг для Alertmanager с указанием урла Апи и каналом ,куда слать
- Описан новый сервис для Alertmanager
- Создан ямль для алерта и добавлен в Докерфайл для копирования в контейнер
- Ссылка на докер хаб с образами - https://hub.docker.com/u/marbax
#### Много заданий со * (необязательных)

</p></details>


<details><summary> HW19 Логирование и распределенная трассировка</summary><p>

#### Сбор неструктурированных логов
- Обновлен код микросервисов и пересобраны контейнеры
- Создан compose файл описания контейнеров для мониторинга : fluentd , elasticsearch , kibana
- Создан и описан докерфайл fluentd
- Описан файл конфигурации fluentd 
- В compose файле сервисов приложения определен драйвер логирования
- Для парсинга неструктурированых логов приходится использовать регулярные выражения , вместо них лучше использоватоь grok-шаблоны

#### Визуализация логов
- В Kibana добавлен индекс паттерн fluentd 

#### Сбор структурированных логов
- В конфиг dkuentd добавлен фильтр для парсинга логов приходящих от микросервиса post (работает для структурированых логов (которые уже в формате json))

#### Распределенная трасировка
- Добавлен Zipkin в сервисы логирования 

#### Задание со здвездочкой 
- Микросервис post отвечает стабильно по  3 секунды 
Настроен слип на 3 сек в post_app.py
```max_resp_time = 3 
        median_time = time.sleep(max_resp_time)
```
</p></details>


<details><summary> HW20  Введение в Kubernetes</summary><p>

#### Разобрать на практике все компоненты Kubernetes, развернуть их вручную используя The Hard Way
- Развернут Kubernetes по мануалу the hard way 
#### Ознакомиться с описанием основных примитивов нашего приложения и его дальнейшим запуском в Kubernetes.

</p></details>

<details><summary> HW21 Kubernetes.Запуск кластера и приложения. Модель безопасности.</summary><p>

#### Развернуть локальное окружение для работы с Kubernetes
- Установлен minikube ```curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.27.0/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/```
- Kubectl и VirtualBox уже были установлены
- ```minikube start``` запущен кластер в виртуалке
- Описаны компоненты и сервисы приложения в ямль манифестах ,находятся в ./kubernetes/reddir/
- Создан отдельный неймспейс  (после этого машина странно перегружаться начала ,а миникюб  залипает)
#### Развернуть Kubernetes в GKE
- В GKE развернут мини кластер кубера из нод 
- В фаерволе открыты порты под кубер 3000-3267
- В GKE ГУИ добавлен дэшборд , ```kubectl proxy``` вход на дэшборд через проксю(выдаваемый адрес неполный ,насколько я понял(http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/login))
#### Запустить reddit в Kubernetes
- [Ссылка на приложение в GKE](35.204.210.153:32451)

#### Доп задания
- Поднятие кластера кубера с помощью тераформа и описание в ямле добавление дэшборда не сделано из-за нехватки времени 

</p></details>


### HW22 Kubernetes.Networks ,Storages

#### Ingress Controller
- Протестирован облачный балансировщик
#### Ingress
- Создан Ingress для ui 
- Убран облачный балансировщик
- Ingress описан как класический веб 
#### Secret
- Сгенерирован самоподписаный сертификат и загружен в кубер 
#### TLS
- Отключен http 
#### LoadBalancer Service
#### Network Policies
- Установлен бета функционал gcloud  и включен Network Policies
- Запрещен доступ со всех направлений к БД,кроме сервиса comment и post
#### PersistentVolumes
- Использовано хранилище типа emptyDir, которое очищается при каждом обновлении Пода
- Создан и добавлен гугл клауд диск ,который сохраняется
#### PersistentVolumeClaims
- Создан PersistentVolumeClaim с медленным диском 
- Для монги создан запрос диска с помощью persistentVolumeClaim
- Создан PersistentVolumeClaim с ССД диском 
- Создан запрос для монги на быстрый диск 






