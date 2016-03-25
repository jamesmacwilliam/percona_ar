class PerconaAr::Migration < ActiveRecord::Migration
  def connection
    @percona_connection ||=
      PerconaAr::Connection.new(ActiveRecord::Base.connection)
  end
end
