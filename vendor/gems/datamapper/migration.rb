class AddUsers < DataMapper::Migration
  def self.up
    table :users do # sees that the users table does not exist and so creates the table
      add :name, :string
      add :login, :string
    end
    table :users do # sees that the users table exists and so scopes the following commands to the users table
      add :password, :string
      add :email, :string
      remove :login
    end
    
    # Rails style
    create_table :rails_users do |t|
      t.column :name, :string
      t.column :login, :string
    end
    add_column :rails_users, :password, :string
    add_column :rails_users, :email, :string
    remove_column :rails_users, :login
  end
  
  def self.down
    table.drop :users
    drop_table :users
  end
end