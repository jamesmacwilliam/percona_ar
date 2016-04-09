# PerconaAr

[![Build
Status](https://travis-ci.org/jamesmacwilliam/percona_ar.svg?branch=master)](https://travis-ci.org/jamesmacwilliam/percona_ar)

[![Code
Climate](https://codeclimate.com/github/jamesmacwilliam/percona_ar/badges/gpa.svg)](https://codeclimate.com/github/jamesmacwilliam/percona_ar)

[![Test
Coverage](https://codeclimate.com/github/jamesmacwilliam/percona_ar/badges/coverage.svg)](https://codeclimate.com/github/jamesmacwilliam/percona_ar/coverage)

This gem adds another tool in your belt for rails migrations.  You can
stil generate migrations, and they will function just as they always
have, but there is also the option of generating percona_ar migrations,
which use the percona tool for ALTER statements.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'percona_ar'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install percona_ar

## Dependencies

this tool relies on `pt-online-schema-change` being available from where
the migration is run.

https://www.percona.com/doc/percona-toolkit/2.1/pt-online-schema-change.html

## Usage

- to get started, run: `rails generate percona_ar SomeMigrationName`

- open the file in the db/migrate directory and use it just like you would
  a normal rails migration

- The ALTER commands will get run by pt-online-schema-change, and all
  other commands get run by ActiveRecord just like they normally would

- All the usual rails migration things still apply, your schema updates
  still get kept track of wherever you usually have that done,
  version gets added to schema_migrations, and rails yells at you if you
  haven't yet migrated.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jamesmacwilliam/percona_ar. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](CODE_OF_CONDUCT.md) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

