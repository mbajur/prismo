# ▵ Prismo  [![codecov](https://codecov.io/gh/mbajur/prismo/graph/badge.svg?token=5DaxWR0utn)](https://codecov.io/gh/mbajur/prismo)

Federated link aggregation powered by ActivityPub.

<img width="1223" height="983" alt="image" src="https://github.com/user-attachments/assets/c5b2318c-580d-4431-82dd-7a242724c07e" />

***

# Important notice 🚨🚨🚨

**Prismo is not yet production ready so please don't try to host an instance yet!
I will not be able to provide you any support when 1.0.0 is out as the changes
will not be backward-compatible.**

***

## Getting started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

- ruby 3.4.5
- sqlite

### Installing

A step by step series of examples that help you get a development env running.

#### Setup / first run

If this is the first time that you are installing the app, start with installing dependencies:

    $ bundle install

Setup database

    $ bundle exec rails db:setup

#### Development

If the app has been set up already and you want to continue working on it:

    $ bin/dev

## Running the tests

Running unit specs:

    $ bundle exec rspec

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://gitlab.com/prismosuite/prismo/tags).

## Thanks

Prismo Team is extremely grateful to all the contributors and donors from Patreon and LiberaPay. Apart from that, it's fair to mention that
huge amount of Prismo code base is heavily based on Mastodon code and it would be impossible to implement this project without Mastodon source guidance.

Thank you ❤️

## Sponsors

- Application performance monitoring sponsored by [AppSignal](https://appsignal.com)

## License

Prismo
Copyright (C) 2026 mbajur

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
