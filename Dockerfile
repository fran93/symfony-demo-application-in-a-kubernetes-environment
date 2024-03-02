FROM dunglas/frankenphp:1-bookworm

WORKDIR /app

RUN apt-get update && \
	apt-get -y --no-install-recommends install \
		mailcap \
		libcap2-bin \
        git \
        unzip \
        libpq-dev \
        acl && \
    docker-php-ext-install pdo pdo_pgsql && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
COPY --link frankenphp/conf.d/app.ini $PHP_INI_DIR/conf.d/
COPY --link --chmod=755 frankenphp/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
COPY --link frankenphp/Caddyfile /etc/caddy/Caddyfile
COPY --link frankenphp/migration.php /app/migration.php

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["docker-entrypoint"]

CMD [ "frankenphp", "run", "--config", "/etc/caddy/Caddyfile" ]
