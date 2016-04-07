#!/usr/bin/env bash

sudo update-locale LC_ALL="en_US.utf8"

# Add PG sources
echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" | sudo tee -a /etc/apt/sources.list.d/pgdb.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Add Node sources
curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -

# erlang depend on libwxgtk3
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y\
             git\
             libpq-dev\
             build-essential\
             libwxgtk3.0-dev\
             imagemagick \
             postgresql-9.5\
             nodejs\


# Add Erlang sources
wget --quiet "https://packages.erlang-solutions.com/erlang/esl-erlang/FLAVOUR_1_general/esl-erlang_18.3-1~ubuntu~trusty_amd64.deb"
sudo dpkg -i esl-erlang_18.3-1~ubuntu~trusty_amd64.deb

wget --quiet "https://packages.erlang-solutions.com/erlang/elixir/FLAVOUR_2_download/elixir_1.2.3-1~ubuntu~trusty_amd64.deb"
sudo dpkg -i elixir_1.2.3-1~ubuntu~trusty_amd64.deb

sudo su postgres -c "createuser -d -R -S $USER"



