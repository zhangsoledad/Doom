## Api Monitor System
A api monitor system build by [phoenix](http://www.phoenixframework.org/)

[![Build Status](https://travis-ci.org/zhangsoledad/Doom.svg?branch=master)](https://travis-ci.org/zhangsoledad/Doom)
[![Coverage Status](https://coveralls.io/repos/github/zhangsoledad/Doom/badge.svg?branch=master)](https://coveralls.io/github/zhangsoledad/Doom?branch=master)

## Requirements

* Erlang 18.0 +
* Elixir 1.2.0 +
* PostgreSQL 9.4 +

## Install in development

### Vagrant

Install VirtualBox:

https://www.virtualbox.org/

Install Vagrant:

https://www.vagrantup.com/

Then:

```bash
$ vagrant up
$ vagrant ssh
$ cd /vagrant
/vagrant $ mix ecto.reset
/vagrant $ mix phoenix.server
```

## Testing

```bash
mix test
```

## Release

### Generating the Release

```bash
brunch build --production #npm install -g brunch(reuqire brunch)
MIX_ENV=prod mix phoenix.digest
MIX_ENV=prod mix compile
MIX_ENV=prod mix release
```

### run
```
cd rel/doom
bin/doom escript bin/release_tasks.escript migrate
bin/doom start
```

## License
Released under the MIT license:

* [www.opensource.org/licenses/MIT](http://www.opensource.org/licenses/MIT)
