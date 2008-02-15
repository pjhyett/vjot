require 'lib/data_mapper'

ENV['ADAPTER'] ||= 'mysql'

DataMapper::Database.setup do
  adapter  ENV['ADAPTER']
  
  unless ENV['LOGGER'] == 'false'
    log_stream 'example.log'
    log_level Logger::DEBUG
  end
  
  database_name = 'data_mapper_1'
  
  case ENV['ADAPTER']
    when 'postgresql' then
      username 'postgres'
    when 'mysql' then
      username 'root'
    when 'sqlite3' then
      database_name << '.db'
  end
  
  database database_name
end

Dir[File.dirname(__FILE__) + '/spec/models/*.rb'].each do |path|
  load path
end

# p Zoo.all
