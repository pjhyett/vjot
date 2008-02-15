require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.frameworks -= [ :action_mailer, :active_resource, :active_record ]
  config.load_paths += Dir["#{RAILS_ROOT}/vendor/gems/**"].map do |dir| 
    File.directory?(lib = "#{dir}/lib") ? lib : dir
  end
  config.action_controller.session = {
    :session_key => '_vjot_session',
    :secret      => '3ihsdfdsfhy)H)Ah90h30r9h39rh'
  }
end

require 'data_mapper'
require 'json'

Default_jot = <<-JOT
vJot Howto

Creating
--------
Type in a title in the top box and press enter.

Searching
---------
While typing in a title the jots below will be filtered based upon what you've entered.

Syncing
-------
In order to save your jots to the database, you click the 'sync' button.
JOT

