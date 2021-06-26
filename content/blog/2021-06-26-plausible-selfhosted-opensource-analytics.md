---
title: "Plausible - How to setup self hosted analytics"
description: ""
date: 2021-06-26T19:03:00+05:30
lastmod: 2021-06-26T19:03:00+05:30
draft: true
images: []
---

Install docker

```
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

 curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
 echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

 sudo apt-get install docker-ce docker-ce-cli containerd.io
```

Install docker compose
```
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```


```
git clone https://github.com/plausible/hosting
mv hosting/ plausible
cd plausbile

```


edit the file `plausible-conf.env` and update it with relevant information
use `openssl rand -base64 64` to generate random string


ADMIN_USER_EMAIL=you@email.com
ADMIN_USER_NAME=username
ADMIN_USER_PWD=xxxxxx
BASE_URL=https://stats.esc.sh
SECRET_KEY_BASE=xxxxxxxxxxxxxxx==



### Change network interface for listening

```
plausible:
    image: plausible/analytics:latest
    command: sh -c "sleep 10 && /entrypoint.sh db createdb && /entrypoint.sh db migrate && /entrypoint.sh db init-admin && /entrypoint.sh run"
    depends_on:
      - plausible_db
      - plausible_events_db
      - mail
    ports:
      - 127.0.0.1:8000:8000
```

bring it up

```
sudo docker-compose up -d
```

Creates a Postgres database for user data
Creates a Clickhouse database for stats
Runs migrations on both databases to prepare the schema
Creates an admin account (which is just a normal account with a generous 100 years of free trial)
Starts the server on port 8000


At first run, the plausible container will fail. Just restart it once and it should work fine
```
sudo docker-compose restart plausible
```




### Point the domain to the server

stats.esc.sh -> server ip


### Setup Nginx reverse proxy

```
sudo apt install nginx
```

Setup let's encrypt configs

```
sudo apt install certbot python3-certbot-nginx
```

Create `/etc/nginx/snippets/letsencrypt.conf with the following content
```
location ^~ /.well-known/acme-challenge/ {
    default_type "text/plain";
    root /var/www/letsencrypt;
}
```
Create the directory
```
sudo mkdir /var/www/letsencrypt
```


Create nginx config `/etc/nginx/sites-enabled/stats.esc.sh`

```
server {
    listen 80;

    include /etc/nginx/snippets/letsencrypt.conf;

    server_name stats.esc.sh;
}
```

```
sudo nginx -t
sudo systemctl restart nginx
```

### Fetch the certificates

```
sudo certbot --nginx -d stats.esc.sh
```

- enter email to get notifications of expiry
- `A` for agree
- Choose Y/N
- 1 - No redirection


At this point certbot would have updated the nginx configuration.. should look like this

```
server {
    listen 80;

    include /etc/nginx/snippets/letsencrypt.conf;

    server_name stats.esc.sh;

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/stats.esc.sh/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/stats.esc.sh/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}
```

Now, we need to enable http -> https redirection. Also, we need to add the proxy config for plausible
Make changes to look like this

```
server {
    listen 80;

    include /etc/nginx/snippets/letsencrypt.conf;

    server_name stats.esc.sh;


    location / {
       return 301 https://$host$request_uri;
    }

}

server {
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/stats.esc.sh/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/stats.esc.sh/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot


    server_name stats.esc.sh;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

The only thing to change here is the domain name


### Setup Plausible

Login at https://your.domain.com with the username and password from the config

It will ask to activate the account, we can do this manually.

```
sudo docker exec plausible_plausible_db_1 psql -U postgres -d plausible_db -c "UPDATE users SET email_verified = true;"
```