if ActiveRecord.gem_version >= Gem::Version.new('5.0')
  class PerconaAr::Migration < ActiveRecord::Migration[4.2]; end
else
  class PerconaAr::Migration < ActiveRecord::Migration; end
end

PerconaAr::Migration.class_eval do
  def connection
    @percona_connection ||=
      PerconaAr::Connection.new(ActiveRecord::Base.connection)
  end

  def migrate(*args)
    $query_builder = PerconaAr::QueryBuilder.new
    super
    $query_builder.execute
  end
end
