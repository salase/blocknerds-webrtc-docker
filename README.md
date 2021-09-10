# blocknerds-webrtc-docker

## Set up hosts file
Edit /etc/hosts file to add
```bash
127.0.0.1  frontend.test
127.0.0.1  backend.test
```

## Set up Certs
In the cert folder run
```bash
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout domain-selfsigned.key -out domain-selfsigned.crt
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout local-selfsigned.key -out local-selfsigned.crt
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout public-selfsigned.key -out public-selfsigned.crt
```

## Set up .env file with your local paths

```bash
cp .env.example .env
```

Edit your Yii project path as needed

## Composer and Yii init
```bash
docker-compose run php composer update
docker-compose run php php init --env=Development --overwrite=All --delete=All
```

## Run
```bash
./start.sh
```
