class PerconaAr::Migration < ActiveRecord::Migration
  def connection
    @percona_connection ||=
      PerconaAr::Connection.new(ActiveRecord::Base.connection)
  end

  def migrate(*args)
    $query_builder = PerconaAr::QueryBuilder.new connection
    super
    $query_builder.execute
  end
end
