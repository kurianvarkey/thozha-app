#!/bin/sh
#Setup script written by K V P for Net4Ideas

version="1.0.0"

set -euo pipefail

# Checking for the another instance of the script
if [ -f /tmp/thozha_setup.pid ] && kill -0 $(cat /tmp/thozha_setup.pid) 2>/dev/null; then
  echo -e "\e[31mAnother instance of $0 is running. Stopping to avoid conflict.\e[0m"
  exit 1
fi
echo $$ > /tmp/thozha_setup.pid


echo -e "\e[33mScript powered by:\e[0m"
echo -e "\e[96m
    _   __     __  __ __  ____    __               
   / | / /__  / /_/ // / /  _/___/ /__  ____ ______
  /  |/ / _ \/ __/ // /_ / // __  / _ \/ __  / ___/
 / /|  /  __/ /_/__  __// // /_/ /  __/ /_/ (__  ) 
/_/ |_/\___/\__/  /_/ /___/\__,_/\___/\__,_/____/  

\e[0m"

echo -e "\e[33mRunning setup script - $version .....\e[0m"

echo -e "\e[34mConfiguring git hooksPath to .githooks folder for commit-msg and pre-push\e[0m"
git config core.hooksPath .githooks
chmod +x .githooks/commit-msg
chmod +x .githooks/pre-commit
chmod +x .githooks/post-commit
chmod +x .githooks/pre-push
chmod +x .githooks/post-merge

if command -v docker &> /dev/null; then
    echo "Docker installation is found"
else
    echo -e "\e[31mDocker installation not found. Please install docker.\e[0m"
    exit 1
fi

if ! docker info > /dev/null 2>&1; then
  echo -e "\e[31mThis script uses docker, and it isn't running - please start docker and try again!.\e[0m"
  exit 1
fi

if command -v mkcert &> /dev/null; then
    echo "mkcert installation is found"
else
  echo -e "\e[36mInstalling the mkcerts for the local https support\e[0m"
  sudo apt install libnss3-tools

  echo "Installing Homebrew..."
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo "Installing mkcert..."
  brew install mkcert
fi

mkcert -install
cd .docker/certs
mkcert thozha.local "*.thozha.local" localhost 127.0.0.1 ::1
cd ../../

echo -e "\e[36mMake sure the script file is having enough permissions is to execute in docker container\e[0m"
cd .docker
#chmod +x init-aws.sh
find . -type f -name "*.sh" -exec chmod +x {} \;
cd ../

echo -e "\e[36mCopying the .env file\e[0m"
cp -u .env.example .env

echo -e "\e[36mRemoving any existing docker container\e[0m"
docker-compose down

#docker network create traefik-public
docker network inspect traefik-public >/dev/null 2>&1 || \
    docker network create traefik-public

echo -e "\e[36mRunning the docker composer\e[0m"
docker run --rm -v $(pwd):/app composer install --ignore-platform-req=ext-mongodb --ignore-platform-req=ext-pcntl

echo -e "\e[36mBuilding the docker\e[0m"
docker-compose up -d --wait

echo "Running the artisan version"
docker-compose exec api php artisan --version

echo "Generating the application key"
docker-compose exec api php artisan key:generate

echo -e "\e[36mChecking for PgSQL instance ...\e[0m"
seconds=1
until docker container exec -it thozha_pgdb pg_isready -h localhost | grep "accepting connections" ; do
  >&2 echo "PgSQL is unavailable - waiting for it... 😴 ($seconds)"
  sleep 1
  seconds=$(expr $seconds + 1)

  if [ "$seconds" -gt 15 ]; then
        echo -e "\e[31mPgSQL did not start up in time, so please run migrate manually - docker-compose exec api php artisan migrate\e[0m"
        exit 1
        break
    fi
done

echo -e "\e[36mRunning the startup script\e[0m"
docker-compose exec api /bin/sh -c /usr/local/etc/php/startup.sh

echo "Clearing the pulse"
docker-compose exec api php artisan pulse:clear

echo "
........................................................................................
"

echo "If you see any script errors, it may due to database server not ready. Then please run:

docker-compose exec api php artisan migrate"

echo "
........................................................................................
"

echo "
Api endpoint will be ready on http://localhost:8000 or https://api.thozha.local
"

echo -e "\e[33mFor Wsl users:
- Please run following to enable https locally\e[0m"

echo -e "\e[36m
Step 1: Install mkcert (https://github.com/FiloSottile/mkcert?tab=readme-ov-file#installation)

--In Windows, use Chocolatey
To intstall Chocolatey in Windows using powershell

Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

Step 2: Run in windows with mkcert -install
Step 3: Then install in WSL mkcert -install
Step 4: Go to directory where mkcert created CA filed for windows (Run mkcert -CAROOT) and copy them to WSL location. So WSL now uses windows CA files.
Step 5: Run mkcert -install again on WSL
Step 6: Create a certs from WSL for your sites.
mkcert thozha.local \"*.thozha.local\" localhost 127.0.0.1 ::1 
Step 7: Add entries in the windows hosts file
Edit C:\Windows\System32\drivers\etc\hosts with following:
<ip address> api.thozha.local

Note: ip address is the one for wsl - type ipconfig to get
\e[0m"

echo -e "\e[33m--- Thanks for using setup script powered by Net4Ideas\e[0m
"