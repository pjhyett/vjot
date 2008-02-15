# This line just let's us require anything in the +lib+ sub-folder
# without specifying a full path.
$LOAD_PATH.unshift(File.dirname(__FILE__))

# Require the basics...
require 'set'
require 'fastthread'
require 'data_mapper/support/array'
require 'data_mapper/support/blank'
require 'data_mapper/support/enumerable'
require 'data_mapper/support/symbol'
require 'data_mapper/support/string'
require 'data_mapper/support/proc'
require 'data_mapper/support/inflector'
require 'data_mapper/database'
require 'data_mapper/base'
require 'data_mapper/migration'

# This block of code is for compatibility with Ruby On Rails' database.yml
# file, allowing you to simply require the data_mapper.rb in your
# Rails application's environment.rb to configure the DataMapper.
if defined? RAILS_ENV
  require 'yaml'
  
  rails_config = YAML::load_file(RAILS_ROOT + '/config/database.yml')
  current_config = rails_config[RAILS_ENV.to_s]

  DataMapper::Database.setup do
    adapter   current_config['adapter']
    host      current_config['host']
    database  current_config['database']
    username  current_config['username']
    password  current_config['password']
    log_stream "#{RAILS_ROOT}/log/db.log"
    log_level  Logger::DEBUG
    #cache WeakHash::Factory
  end
end