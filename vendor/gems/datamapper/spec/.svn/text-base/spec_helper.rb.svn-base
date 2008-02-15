require File.dirname(__FILE__) + '/../lib/data_mapper'
require 'yaml'
require 'pp'

log_path = File.dirname(__FILE__) + '/../spec.log'

require 'fileutils'
FileUtils::rm log_path if File.exists?(log_path)

case ENV['ADAPTER']
when 'sqlite3' then
  DataMapper::Database.setup do
    adapter 'sqlite3'
    database 'data_mapper_1.db'
    log_stream 'spec.log'
    log_level Logger::DEBUG
  end
when 'postgresql' then
  DataMapper::Database.setup do
    adapter  'postgresql'
    database 'data_mapper_1'
    username 'postgres'
    log_stream 'spec.log'
    log_level Logger::DEBUG
  end
else
  DataMapper::Database.setup do
    adapter 'mysql'
    database 'data_mapper_1'
    username 'root'
    log_stream 'spec.log'
    log_level Logger::DEBUG
  end
end

Dir[File.dirname(__FILE__) + '/models/*.rb'].each do |path|
  load path
end

database do |db|
  db.schema.each do |table|
    db.create_table(table.klass)
  end
end

at_exit do
  database do |db|
    db.schema.each do |table|
      db.drop_table(table.klass)
    end
  end
end if ENV['DROP'] == '1'

# Define a fixtures helper method to load up our test data.
def fixtures(name)
  entry = YAML::load_file(File.dirname(__FILE__) + "/fixtures/#{name}.yaml")
  klass = Kernel::const_get(Inflector.classify(Inflector.singularize(name)))
  
  database.schema[klass].create!
  klass.truncate!
  
  (entry.kind_of?(Array) ? entry : [entry]).each do |hash|
    klass::create(hash)
  end
end

# Pre-fill the database so non-destructive tests don't need to reload fixtures.
Dir[File.dirname(__FILE__) + "/fixtures/*.yaml"].each do |path|
  fixtures(File::basename(path).sub(/\.yaml$/, ''))
end
