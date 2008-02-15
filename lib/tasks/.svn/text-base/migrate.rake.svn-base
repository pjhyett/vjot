namespace :dm do  
  def models
    Dir["#{RAILS_ROOT}/app/models/**.rb"].map { |dir| File.basename(dir, '.rb').classify.constantize }
  end
  
  def tables
    DataMapper.database.query("show table status").map do |row|
      row.Name.classify.constantize
    end
  end
  
  def columns_in_model(klass)
    DataMapper.database.schema[klass].columns
  end
  
  def columns_in_db(klass)
    DataMapper.database.query("show fields from #{klass.to_s.tableize}").map do |row|
      row.Field.to_sym  
    end rescue []
  end
  
  desc "DataMapper reset"
  task :reset => :environment do
    tables.each { |table| DataMapper.database.drop_table(table) }
    Rake::Task["dm:migrate"].invoke
  end
  
  desc "DataMapper migrate"
  task :migrate => :environment do
    def build_table(model)
      clsdb  = columns_in_db(model)
      remove = clsdb - columns_in_model(model).map(&:name) & clsdb
      schema = "table :#{model.to_s.tableize} do\n"
      schema << columns_in_model(model).map { |column| "add :#{column.name}, :#{column.type}\n" }.join
      schema << remove.map { |name| "remove :#{name}\n" }.join
      schema << "end\n"
    end
    
    class AutoMigration < DataMapper::Migration
      class_eval <<-CE
        def self.up
          #{models.map { |model| build_table(model) }.join}
        end
      CE
    end
    AutoMigration.migrate
  end
end
