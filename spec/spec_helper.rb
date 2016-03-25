$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'percona_ar'

ActiveRecord::Base.establish_connection(
  adapter:  "mysql2",
  host:     ENV["db_host"] || "localhost",
  username: ENV["db_user"] || "root",
  password: ENV["db_pass"] || "",
  database: ENV["db"]      || "mysql"
)
