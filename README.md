# Webnotes

Веб сайт для создания заметок

## Технологии
Все собирем из сходников

- Tarantool 2.6 - [Cсылка на инструкция по сборке](https://www.tarantool.io/ru/doc/latest/dev_guide/building_from_source/) !ВАЖНО в git clone поменять версию таранута
- nginx_upstream

## Nginx upstream

Собираем Nginx из исходников 
```bash
$ mkdir nginx/logs/
$ git clone https://github.com/tarantool/nginx_upstream_module.git
$ cd nginx_upstream_module
$ git submodule update --init --recursive
$ git clone https://github.com/nginx/nginx.git
$ sudo apt install libpcre++0 gcc unzip libpcre3-dev zlib1g-dev libssl-dev libxslt-dev
$ sudo apt install cmake
$ sudo apt update && sudo apt-get install build-essential
$ make build-all
$ cd ..
```

## Запуск всего

Запуск тарантула
```bash
./tarantool/src/tarantool tarantool_app/app.lua
```

Запускаем nginx
```bash
./nginx_upstream_module/nginx/objs/nginx -p nginx_app/
```

## Vsсode
Настройка окружения для разработки с js
- [Расширения VSCode, которые облегчат разработку на JavaScript и Vue](https://habr.com/ru/post/440066/)
- [Отладка VueJs в VS Code](https://ru.vuejs.org/v2/cookbook/debugging-in-vscode.html)