# ludndev/laravel-octane-docker

## note

add database to the `lod_network` or use docker compose

## instruction

```bash
git clone git@github.com:ludndev/laravel-octane-docker.git

cd laravel-octane-docker

docker build -t lod . 

cp .env.example .env

docker network create lod_network

docker run -d --name lod_demo --network lod_network -p 8000:8000 -v $(pwd)/.env:/var/www/.env lod
```
