# Jdbc::Splice

Splice Engine driver for JRuby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jdbc-splice'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install jdbc-splice

## Usage

   `require 'jdbc/splice'` and invoke `Jdbc::Splice.load_driver` within JRuby to load the driver.


#### This gem is mostly used in with Splice Adapter gem:

   `gem 'activerecord-jdbcsplice-adapter'`