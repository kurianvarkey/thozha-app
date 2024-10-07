#!/bin/sh

php artisan test --profile --coverage --min=80 --coverage-html=tests/report/coverage
#php artisan test --parallel --recreate-databases
#php artisan test --testsuite=Feature --filter=AppsTest --stop-on-failure