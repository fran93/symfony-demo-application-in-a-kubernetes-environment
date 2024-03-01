#!/bin/sh
set -e

if [ "$1" = 'frankenphp' ] || [ "$1" = 'php' ] || [ "$1" = 'bin/console' ]; then
	# Install the project the first time PHP is started

	if [ ! -f composer.json ]; then
		rm -Rf tmp/
		composer create-project "symfony/symfony-demo $SYMFONY_VERSION" tmp --stability=$STABILITY --prefer-dist --no-interaction --no-install

		cd tmp
		cp -Rp . ..
		cd -
		rm -Rf tmp/

    composer config platform.php $PHP_VERSION
		composer require runtime/frankenphp-symfony -v
		composer config --json extra.symfony.docker 'true'
	fi

	if [ -z "$(ls -A 'vendor/' 2>/dev/null)" ]; then
		composer install --prefer-dist --no-progress --no-interaction
	fi

	setfacl -R -m u:www-data:rwX -m u:"$(whoami)":rwX var
	setfacl -dR -m u:www-data:rwX -m u:"$(whoami)":rwX var
fi

number_of_tables=$(php bin/console doctrine:query:sql "SELECT count(*) FROM pg_catalog.pg_tables WHERE schemaname='public'" | tr -d -c 0-9)
if [ $number_of_tables -lt 3 ]; then
  php bin/console doctrine:schema:update --force # This isn't recommended for production
fi

# For saving time with the testing, the migration is done using a flag in this file.
if [ $MIGRATION = "ON" ]; then
  mv migration.php migrations/Version20230401.php
  new_migrations=$(php bin/console doctrine:migrations:status | grep New | tr -d -c 0-9)
  if [ $new_migrations -gt 0 ]; then
    php bin/console doctrine:migrations:migrate --no-interaction
  fi
fi

# Rudimentary readiness check
touch dummy

exec docker-php-entrypoint "$@"
