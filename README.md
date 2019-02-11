# Marbax_microservices
Marbax microservices repository

## HW12

### Установлен докер ,по мануалу с офф сайта 
### Исследованы команды и возможности докера (в спойлере)

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
