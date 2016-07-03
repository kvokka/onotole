[![Code Climate](https://codeclimate.com/github/kvokka/onotole/badges/gpa.svg)](https://codeclimate.com/github/kvokka/onotole)

# Onotole & Rails 5

New Rails project wizard. Onotole will help!

[![Onotole](http://i.imgur.com/8VsFFvy.jpg?1)](https://www.youtube.com/watch?v=wAuqhLpV2DY)

Read more [ENG](https://en.wikipedia.org/wiki/Anatoly_Wasserman) | 
[RUS](https://ru.wikipedia.org/wiki/%D0%92%D0%B0%D1%81%D1%81%D0%B5%D1%80%D0%BC%D0%B0%D0%BD,_%D0%90%D0%BD%D0%B0%D1%82%D0%BE%D0%BB%D0%B8%D0%B9_%D0%90%D0%BB%D0%B5%D0%BA%D1%81%D0%B0%D0%BD%D0%B4%D1%80%D0%BE%D0%B2%D0%B8%D1%87) | [RUS lurk](http://lurkmore.to/%D0%92%D0%B0%D1%81%D1%81%D0%B5%D1%80%D0%BC%D0%B0%D0%BD)

## About

Fork from thoughtbot/suspenders(https://github.com/thoughtbot/suspenders)
implemented function of user choice gems installation with all their settings,
so you can use fully working application with everything needed installed and
configured from the box. Cut `Bitters` as default choice.

As default uses the latest Ruby version and Rails '~> 5.0.0' 

This user gem pack is available for custom installation (you will only choose 
what you need) all of this will be available in the customization menu with `-c` 
flag usage (no default selected gems will be installed), otherwise default gem 
list will be installed. Gems with `*` mark will be installed as addition like
default, if starting `onotole` without `-c` flag. You can provide automatic 
installation with options, like `--haml`. Default pack will not be installed 
with any gem option.

I begin collecting some [goodies](https://github.com/kvokka/onotole/goodies) 
where some patches and tweaks will be placed in, for easier getting into and
using it with already started projects.

At this monent, I found unworking this gems:
 * ActiveAdmin
 * WillPaginane

I hope Rails 5 support willl be added there soon, or you may easyly find monkey patches for fixes.
Feel free to edit this list.


### Flexible gem group

#### Frontend frameworks

 * [bootstrap3](https://github.com/seyhunak/twitter-bootstrap-rails) Bootstrap
 with asset pipeline support
 * [bootstrap3_sass](https://github.com/twbs/bootstrap-sass) Bootstrap sass
 * [materialize](https://github.com/mkhairi/materialize-sass) Materialize Sass 
 version for Rails Asset Pipeline http://materializecss.com/

#### Template engines

 * `*`[slim](https://github.com/slim-template/slim) Slim is a template language
 which goal to reduce the syntax to the essential parts without becoming
 cryptic. http://slim-lang.com
 * [html2slim](https://github.com/slim-template/html2slim) HTML2SLIM utility,
  installs with slim
 * [haml](https://github.com/haml/haml) HTML Abstraction Markup Language - A
 Markup Haiku http://haml.info

#### Authenticate engines

 * [devise](https://github.com/plataformatec/devise) Flexible authentication
 solution for Rails with Warden. http://blog.plataformatec.com.br/tag/devise/
 * [devise-bootstrap-views](https://github.com/hisea/devise-bootstrap-views)

#### CMS engines & DB viewers

 * [rails_admin](https://github.com/sferik/rails_admin) Rails engine that 
 provides an easy-to-use interface for managing your data
 * [activeadmin](https://github.com/activeadmin/activeadmin) Rails framework for 
creating elegant backends for website administration. 
 * [typus](https://github.com/typus/typus) Ruby on Rails control panel to allow 
 trusted users edit structured content. http://docs.typuscmf.com
 * [rails_db](https://github.com/igorkasyanchuk/rails_db) Rails Database Viewer
 and SQL Query Runner https://youtu.be/TYsRxXRFp1g

##### ActiveAdmin plug-ins

 * [ActiveAdminImport](https://github.com/activeadmin-plugins/active_admin_import) 
 Based on ActiveRecord-import gem - the most efficient way to import for ActiveAdmin
 * [ActiveAdminTheme](https://github.com/activeadmin-plugins/active_admin_theme) 
 Flat skin for ActiveAdmin
 * [Active_skin](https://github.com/rstgroup/active_skin) Flat skin for active admin.
 * [flattened_active_admin](https://github.com/Papercloud/flattened_active_admin) 
 Theme. Bring your Active Admin up-to-date with this customizable add on
 * [Face_of_active_admin](https://github.com/kvokka/face_of_active_admin) Theme 
 for ActiveAdmin with glyphicons and flattens
 * [active_admin_bootstrap](https://gist.github.com/ball-hayden/2fd4d40b150a39716dec) 
Very simple ActiveAdmin Bootstrap theme
 * [active_admin_simple_life](https://github.com/kvokka/active_admin_simple_life)
 Gem automatize routine with creation simple menus in ActiveAdmin with minimum 
 code duplication.

#### Pagination

 * [will_paginate](https://github.com/mislav/will_paginate) Pagination library
 for Rails, Sinatra, Merb, DataMapper
 * [will_paginate-bootstrap](https://github.com/bootstrap-ruby/will_paginate-bootstrap)
 Integrates the Twitter Bootstrap pagination component with will_paginate
 * [kaminari](https://github.com/amatsuda/kaminari) A Scope & Engine based, 
 clean, powerful, customizable and sophisticated paginator for Rails
 * [bootstrap-kaminari-views](https://github.com/matenia/bootstrap-kaminari-views)
Bootstrap kaminari plugin

#### WYSIWYG

 * [ckeditor](https://github.com/galetahub/ckeditor) CKEditor is a WYSIWYG text 
 editor designed to simplify web content creation.
 * [tinymce-rails](https://github.com/spohlenz/tinymce-rails) Integration of 
 TinyMCE with the Rails asset pipeline

 #### Memory DB
 * [redis](https://github.com/redis/redis-rb) A Ruby client library for Redis.
 * [redis-rails](https://github.com/redis-store/redis-rails) Provides a full set
  of stores (Cache, Session, HTTP Cache) for Ruby on Rails
 * [redis-namespace](https://github.com/resque/redis-namespace) Provides an 
 interface to a namespaced subset of your redis keyspace (e.g., keys with a 
 common beginning).

#### File storage
 * [carrierwave](https://github.com/carrierwaveuploader/carrierwave/tree/0.11-stable)
Classier solution for file uploads for Rails, Sinatra and other Ruby web 
frameworks https://github.com/carrierwaveuploader/carrierwave


#### Developer tools

 * [Airbrake](https://github.com/airbrake/airbrake) For exception notification
 * [bundler_audit](https://github.com/rubysec/bundler-audit) Patch-level
 verification for Bundler
 * `*`[faker](https://github.com/stympy/faker) A library for generating fake data
 such as names, addresses, and phone numbers.
 * `*`[guard](https://github.com/guard/guard) Guard is a command line tool to
 easily handle events on file system modifications. http://guardgem.org
 * [guard_rubocop](https://github.com/yujinakayama/guard-rubocop) Guard plugin
 for RuboCop
 * `*`[meta_request](https://github.com/dejan/rails_panel/tree/master/meta_request)
 Supporting gem for Rails Panel (Google Chrome extension for Rails development).
 * `*`[rubocop](https://github.com/bbatsov/rubocop) A Ruby static code analyzer,
 based on the community Ruby style guide.
 * `*`[annotate](https://github.com/ctran/annotate_models) Annotate Rails classes 
 with schema and routes info
 * `*`[overcommit](https://github.com/brigade/overcommit) A fully configurable 
 and extendable Git hook manager
 * `*`[rubycritic](https://github.com/whitesmith/rubycritic) A Ruby code quality 
 reporter
 * [railroady](https://github.com/preston/railroady) Model and controller UML 
 class diagram generator. Originally based on the "railroad" plugin
 * [hirb-unicode](https://github.com/miaout17/hirb-unicode) Unicode support
 for hirb
 * [dotenv-heroku](https://github.com/sideshowcoder/dotenv-heroku) Addition for
 quick variables export to heroku
 * [image_optim](https://github.com/toy/image_optim) Optimize (lossless compress, 
optionally lossy) images (jpeg, png, gif, svg) using external utilities
 * [mailcatcher](https://github.com/sj26/mailcatcher) Catches mail and serves 
it through a dream. http://mailcatcher.me
 * `*`[rack-mini-profiler](https://github.com/MiniProfiler/rack-mini-profiler)
 Middleware that displays speed badge for every html page. Designed to work both
  in production and in development.
 * [flamegraph](https://github.com/SamSaffron/flamegraph) Flamegraph profiling 
 support (awesome performance graphics)
 * [stackprof](https://github.com/tmm1/stackprof) A sampling call-stack profiler
for ruby 2.1+
 * [active_record_doctor](https://github.com/gregnavis/active_record_doctor) 
 Active Record Doctor helps to index unindexed foreign keys 
 * [git_up](https://github.com/aanand/git-up) Fetch and rebase all locally-tracked 
 remote branches


#### Misc

 * [activerecord_import](https://github.com/zdennis/activerecord-import) 
 Activerecord-import is a library for bulk inserting data using ActiveRecord.
 * `*`[responders](https://github.com/plataformatec/responders) A set of responders
 modules to dry up your Rails 4.2+ app.
 * [paper_trail](https://github.com/airblade/paper_trail) Track changes to your 
 models' data. Good for auditing or versioning.
 * [validates_timeliness](https://github.com/adzap/validates_timeliness) 
 Date and time validation plugin for ActiveModel and Rails. Supports multiple 
 ORMs and allows custom date/time formats.
 * [font-awesome-sass](https://github.com/FortAwesome/font-awesome-sass) 
 Font-Awesome Sass gem for use in Ruby/Rails projects
 * [cyrillizer](https://github.com/dalibor/cyrillizer) Character conversion from
  latin to cyrillic and vice versa
 * [fotoramajs](https://github.com/ai/fotoramajs) Fotorama JS gallery for Ruby 
 on Rails http://fotorama.io/
 * [rack-cors](https://github.com/cyu/rack-cors) Rack Middleware for handling 
 Cross-Origin Resource Sharing (CORS), which makes cross-origin AJAX possible.
 * [newrelic_rpm](https://github.com/newrelic/rpm) for monitoring performance 
 * [invisible_captcha](https://github.com/markets/invisible_captcha) Unobtrusive
  and flexible spam protection for RoR apps
 * [therubyracer](https://github.com/cowboyd/therubyracer) Embed the V8 
 Javascript Interpreter into Ruby

##### XLS & PDF

 * [axslx](https://github.com/randym/axlsx) Xlsx generation with charts, images, 
 automated column width, customizable styles and full schema validation.
 * [axlsx_rails](https://github.com/straydogstudio/axlsx_rails) A Rails plug-in 
 to provide templates for the axlsx gem for providing Excel files format support
 * [prawn](https://github.com/prawnpdf/prawn) Fast, Nimble PDF Writer for Ruby 
 http://prawnpdf.org 
 * [prawn-table](https://github.com/prawnpdf/prawn-table) Provides support for 
 tables in Prawn
 
##### Geolocation

 * [geocoder](https://github.com/alexreisner/geocoder) Complete Ruby geocoding 
 solution. http://www.rubygeocoder.com
 * [Gmaps4rails](https://github.com/apneadiving/Google-Maps-for-Rails) Enables 
 easy Google map + overlays creation in Ruby apps http://apneadiving.github.io/

Mandatory installation gem list you will find in `Gemfile` section of this readme

## Installation

First install the onotole gem add this in `Gemfile` and `bundle`

```
    group :development do
      gem 'onotole', require: false
    end
```

or

    gem install onotole

Then run:

    onotole projectname [ -c ] [ * rails_genetator_flags ]

There are 2 main ways of using:
1. `onotole projectname` will generate project with default mandatory gems and 
default flexible gems
2. `onotole projectname -c` will generate project with mandatory gems and will 
provide a menu for gem selection, where you will need to choose all options.

Of course you are free to add standard `rails new` flags, inasmuch as Onotole
based on standard rails generator

And command like this will add some magic

    onotole app  * github organization/project * heroku true

This will provide a dialog, where you can select needed gems, also you can add
it with gemname flag, after app_name, like `onotole projectname --slim`.
List of gems you always can get with `onotole --gems` command. Also, 
`onotole --help` can be useful.

*NB: if you install custom gems, default user gem pack will not be installed.

## Gemfile

To see the latest and greatest gems, look at Onotole'
[Gemfile](templates/Gemfile.erb), which will be appended to the default
generated projectname/Gemfile. This gem will be installed anyway.

### Mandatory gem group

* [Autoprefixer Rails](https://github.com/ai/autoprefixer-rails) for CSS vendor prefixes
* [Delayed Job](https://github.com/collectiveidea/delayed_job) for background
  processing
* [High Voltage](https://github.com/thoughtbot/high_voltage) for static pages
* [jQuery Rails](https://github.com/rails/jquery-rails) for jQuery
* [Normalize](https://necolas.github.io/normalize.css/) for resetting browser styles
* [Postgres](https://github.com/ged/ruby-pg) for access to the Postgres database
* [Rack Canonical Host](https://github.com/tylerhunt/rack-canonical-host) to
  ensure all requests are served from the same domain
* [Rack Timeout](https://github.com/heroku/rack-timeout) to abort requests that are
  taking too long
* [Recipient Interceptor](https://github.com/croaky/recipient_interceptor) to
  avoid accidentally sending emails to real people from staging
* [Simple Form](https://github.com/plataformatec/simple_form) for form markup
  and style
* [Title](https://github.com/calebthompson/title) for storing titles in
  translations
* [Puma](https://github.com/puma/puma) to serve HTTP requests

And development gems like:

* [Dotenv](https://github.com/bkeepers/dotenv) for loading environment variables
* [Pry Rails](https://github.com/rweng/pry-rails) for interactively exploring
  objects
* [Hirb](https://github.com/cldwalker/hirb) for pretty tables view in the console
* [Awesome_print](https://github.com/michaeldv/awesome_print) Pretty print your
  Ruby objects with style -- in full color and with proper indentation
* [ByeBug](https://github.com/deivid-rodriguez/byebug) for interactively
  debugging behavior
* [Bullet](https://github.com/flyerhzm/bullet) for help to kill N+1 queries and
  unused eager loading
* [Spring](https://github.com/rails/spring) for fast Rails actions via
  pre-loading
* [Web Console](https://github.com/rails/web-console) for better debugging via
  in-browser IRB consoles.
* [Quiet Assets](https://github.com/evrone/quiet_assets) for muting assets
  pipeline log messages
* [Better_errors](https://github.com/charliesome/better_errors) Better error 
  page for Rack apps
* [Binding_of_caller](https://github.com/banister/binding_of_caller) Retrieve 
  the binding of a method's caller in MRI 1.9.2+

And testing gems like:

* [Capybara](https://github.com/jnicklas/capybara) and
  [Capybara Webkit](https://github.com/thoughtbot/capybara-webkit) for
  integration testing
* [Factory Girl](https://github.com/thoughtbot/factory_girl) for test data
* [Formulaic](https://github.com/thoughtbot/formulaic) for integration testing
  HTML forms
* [RSpec](https://github.com/rspec/rspec) for unit testing
* [RSpec Mocks](https://github.com/rspec/rspec-mocks) for stubbing and spying
* [Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers) for common
  RSpec matchers
* [Timecop](https://github.com/ferndopolis/timecop-console) for testing time

## ENV Variables

All variables are stored in `.env` file and calls with project name prefix. It 
made for avoid name space problems with placing more than 1 of Onotole created 
app on 1 server. Onotole prefix all `env` variables with `#{app_name}` and now 
you will not have any problems with export variables in production. In 
production environment you can make `.env.production` file and put all consants
there. Also with this thick you can easy use ENV export tool or just put ENV 
variables in `.bashrc` without name space conflicts.

##NOSQL Memory based db

Now supported only Redis db, and Onotole do not install or config Redis itself,
it just setup support gems. For getting access to Redis you can use `$redis` 
variable, and `$ns_redis` for namespaced access wich is provided by 
`redis-namespace` gem. Feel free in changing settings in 
`config/initializers/redis.rb`

## Other goodies

Onotole also comes with:

* The [`./bin/setup`][setup] convention for new developer setup
* Rails' flashes set up and in application layout
* A few nice time formats set up for localization
* `Rack::Deflater` to [compress responses with Gzip][compress]
* A [low database connection pool limit][pool]
* [Safe binstubs][binstub]
* [t() and l() in specs without prefixing with I18n][i18n]
* An automatically-created `#{APP_NAME}_SECRET_KEY_BASE` environment variable in
 all environments
* The analytics adapter [Segment][segment] (and therefore config for Google
  Analytics, Intercom, Facebook Ads, Twitter Ads, etc.)
* Check existing of app DB and ask about continuation if base persisted 
* Added style flash messagaes for `bootstrap-sass` gem
* Auto add gem `devise_bootstrap_views` when `bootstrap-sass` and `devise` 
selected for pretty view from the box
* Added autoload js and scss from `vendor/assets/javascripts` and 
`vendor/assets/stylesheets`
* Added autoload fonts from `app/assets/fonts/**/*`
* Patch for no error work, if `Mailcatcher` is not loaded. In this case 
`delivery_method = :file`. It checks on the `rails server` starts.
* No need to add `rails_helper` or `spec_helper` in specs.
* In `.env` just switch on `#{app_name}_COVERAGE` to true and get your test 
coverage.
* Added `kaminari-i18n` installation with `ActiveAdmin` or `kaminari` gem
* Moved asset gems in assets group in Gemfile
* Disable logging and deferred garbage collecting gives up 20% test speed 
improvement
* Rake task for killing PostgreSQL conventions `db:kill_postgres_connections`
* Rake task `redis:flushall` 
* Made seeds organization for easy splitting data from scratch
* `Carrierwave` may be integrated with `mini_magick` and `ckeditor`, depend on 
user choice
* Ability to use `AbstractModel` for easy code extension
* Custom FormBuilder initial setup

## Heroku

You can optionally create Heroku staging and production apps:

    onotole app  * heroku true

This:

* Creates a staging and production Heroku app
* Sets them as `staging` and `production` Git remotes
* Configures staging with `RACK_ENV` environment variable set to `staging`
* Adds the [Rails Stdout Logging][logging-gem] gem
  to configure the app to log to standard out,
  which is how [Heroku's logging][heroku-logging] works.
* Creates a [Heroku Pipeline] for review apps

[logging-gem]: https://github.com/heroku/rails_stdout_logging
[heroku-logging]: https://devcenter.heroku.com/articles/logging#writing-to-your-log
[Heroku Pipeline]: https://devcenter.heroku.com/articles/pipelines

You can optionally specify alternate Heroku flags:

    onotole app \
       * heroku true \
       * heroku-flags " * region eu  * addons newrelic,sendgrid,ssl"

See all possible Heroku flags:

    heroku help create

## Git

This will initialize a new git repository for your Rails app. You can
bypass this with the ` * skip-git` option:

    onotole app  * skip-git true

## GitHub auto repository create

You can optionally create a GitHub repository for the suspended Rails app. It
requires that you have [Hub](https://github.com/github/hub) on your system:

    curl http://hub.github.com/standalone -sLo ~/bin/hub && chmod +x ~/bin/hub
    onotole app  * github organization/project

This has the same effect as running:

    hub create organization/project

## Spring

Onotole uses [spring](https://github.com/rails/spring) by default.
It makes Rails applications load faster, but it might introduce confusing issues
around stale code not being refreshed.
If you think your application is running old code, run `spring stop`.
And if you'd rather not use spring, add `DISABLE_SPRING=1` to your login file.

## Dependencies

Onotole requires the latest version of Ruby.

Some gems included in Onotole have native extensions. You should have GCC
installed on your machine before generating an app with Onotole.

Use [OS X GCC Installer](https://github.com/kennethreitz/osx-gcc-installer/) for
Snow Leopard (OS X 10.6).

Use [Command Line Tools for XCode](https://developer.apple.com/downloads/index.action)
for Lion (OS X 10.7) or Mountain Lion (OS X 10.8).

We use [Capybara Webkit](https://github.com/thoughtbot/capybara-webkit) for
full-stack JavaScript integration testing. It requires QT. Instructions for
installing QT are
[here](https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit).

PostgreSQL needs to be installed and running for the `db:create` rake task.
Also DB existing checking in `PostgreSQL` only.

## Contributing

If you want to get your gem in Onotole follow this steps

1. Clone this repository
2. If you need to add new question in menu add it in UserGemsMenu
3. Add your gem with description in `EditMenuQuestions`.
4. Add per `bundler` hooks in `BeforeBundlePatch`. Use function name with this 
template `add_awesome_gem` where `awesome` is a gem name. Usually minimum is to 
add gem into `Gemfile`.
5. Add after install hooks in `AfterInstallPatch`. Name your function 
`after_install_awesome`. Also, add it in query at `#post_init`. Other way it 
will not run
6. Update README.MD
7. Make PR

Please, do not change version or gems for default install.
Appname `tmp` is preferred for develop. It already added to gitignore.

Keep in mind, that tests will need installed [hub](https://github.com/github/hub)

If you find some misprints fell free to fix them.

Thank you!

## Direct GitHub gem installation

Gems, which have been installed from github, with 'github:' option in 
`Gemfile.erb` will be automatically installed with `gem install` command. It made
for making available support fresh fixes. If you do not need it, use 'git:' 
option with full gem trace.   

## License

MIT Licence
