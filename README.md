# Setting up environment

 Required: **JRuby 9.1.5.0** (Ruby 2.3.1), **Rails 4.2.1**

### Install JRuby (using RVM)

1. If no RVM is installed, install it with:

  `\curl -sSL https://get.rvm.io | bash -s stable`

   More information: https://rvm.io/rvm/install


2. Install specific JRuby version. Go to app root directory and run in console:

  `rvm use jruby-9.1.5.0 --install`



### Install all the gems

  `bundle install`


### Starting up the splicemachine and the app

  First, make sure splice engine is up and running:

  1. `cd ~/spliceengine/`

  2. `./start-splice-cluster` (only for the first time). Run `./start-splice-cluster -b`on every other time

    `./start-splice-cluster -h`, for any addtional information


##### Possible issues:

  If there are issues with running a splice cluster, you might need to add next line into your `~/.bashrc` file:

  `export LD_LIBRARY_PATH=/usr/local/lib`

##### Notes:

  On linux, if splice cluster is not run on the first time (after running a `./start-splice-cluster -b`), stop the execution, and run `./start-splice-cluster -b` again.


### Setting up a database
  Now when the cluster is up and running, we need to set-up the database:

  1. Delete the `config/database.yml` file.
  2. Locate `database_example.yml` and rename it to `database.yml`
  3. Run `bundle exec rake db:migrate`

### Set-up production environment (needed for testing puma in production mode)

  1. Open a consolsole and run `bundle exec rake secret` and copy the generated string
  2. Open `.bashrc` and write at the end:
     export SECRET_KEY_BASE=`COPY_AND_PASTE_STRING_GENERATED_FROM_STEP_1`
  3. Restart computer, or just for this session, run in console `source ~/.bashrc`

  Note: In an error about uglifier appears, you might need to install a nodejs on linux:

  `$ sudo apt-get install nodejs`

### Additional information (not neeeded for the set-up)

##### Gem which is needed in order to use splice engine is:

  `gem 'activerecord-jdbcsplice-adapter'`

And, it depends on:

  `gem 'jdbc-splice'` (no need to specify it directly, it is done in the background)



# Testing

  Before running tests or benchmarks, make sure that splice cluster is running: `./start-splice-cluster -b`

#### Run all test tests

  `bundle exec rspec spec/`

#### Run specific test

  `bundle exec rspec spec/models/company_spec.rb:13` (13 is the line number)

#### Run specific test with logs enabled

  `LOGS=true bundle exec rspec spec/models/company_spec.rb:13`


#### Run real server-client test:

  *Note: Some of the SQL commands will assume that there are records in database, like where, update etc. , so in `bundle exec rails c`, and create a single record with: `Company.create(name: 'Company')` before running the tests.*

  **Please note the ID of the created record**, as it will be used in some of the tests.

  1. Run the server: `bundle exec puma -p 3000 -t 16:16 -e production`

      *Note:* Run server with logs enabled: `LOGS=true bundle exec puma -p 3000 -t 16:16 -e production`
  2. Run the benchmark with any of these commands:
     - `ab -n 10000 -c 1000 -r http://localhost:3000/benchmarks/method_where?id=NOTED_ID` (special case)
     - `ab -n 10000 -c 1000 -r http://localhost:3000/benchmarks/method_create`
     - `ab -n 10000 -c 1000 -r http://localhost:3000/benchmarks/method_update`
     - etc.

  *Note:* On mac, there is an issue with Apache Benchmark. In order to fix it, follow instructions from http://sudheeraedama.blogspot.rs/2013/05/install-apachebench-on-mac-osx-1075.html

##### Methods supported:

  `method_create`, `method_update`, `method_where`, `method_limit`, `method_offset`, `method_group`, `method_select`

#### Run benchmarks on single SQL commands (where, create, limit etc.):

  `bundle exec rake benchmark:models RAILS_ENV=test`

# Switching between Ruby and JRuby

  In this app **Ruby**  is used for *MySQL* and **JRuby** for *Splice Engine*

  If you want to run the code against `ruby` code and test the app with it, open file `.ruby-version` and change any text in it to `ruby-2.3.1`, or any other ruby version. Return to the previous directory with (`cd ..`), and re-enter the app directory by `cd splice-jruby` (in order to refresh the settings)

  The database settings for `ruby` is in `database_ruby.yml`. No need to replace or delete the `database.yml`, just modify the `database_ruby.yml` file with your settings.

# Helper Methods

  In order to drop all tables in current database, run in console:

  `bundle exec rake db:splice:destroy_all`


# Implementation of Rails on CentOS (centos-release-6-8.el6.centos.12.3.x86_64)

* sudo yum groupinstall -y 'development tools'
* gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
* curl -L get.rvm.io | bash -s stable (In case the keys are not present then the above key would be shown )
* source ~/.profile
* rvm install jruby
  in case ruby gems is not installed (rvm ruby gems latest)
* gem install rails -v 4.0.0
* gem install bundle
* git clone https://github.com/splicemachine/splice-community-sample-code.git
* navigate to “tutorial-rails” and run "bundle install"
* which jruby
  whatever directory comes substitute bin for lib and put the client driver file there.
  In my case i for ~/.rvm/rubies/jruby-9.0.5.0/bin/jruby
  ~/.rvm/rubies/jruby-9.0.5.0/lib

