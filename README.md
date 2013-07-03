# Ruby Spfquery

It's a thin wrapper around spfquery which is assumed to be in the PATH of the ruby process.

## Installation

Add this line to your application's Gemfile:

    gem 'ruby-spfquery', require: 'spfquery'

And then execute:

    bundle

Or install it yourself as:

    gem install ruby-spfquery

## Usage

     Spfquery.pass?(ip_address, mail_from, helo)


