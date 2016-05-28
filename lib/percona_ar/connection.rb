class PerconaAr::Connection < ActiveRecord::ConnectionAdapters::Mysql2Adapter
  def initialize(conn)
    super(
      conn.instance_variable_get(:@connection),
      Logger.new("/dev/null"),
      conn.instance_variable_get(:@connection_options),
      conn.instance_variable_get(:@config)
    )
  end

  def execute(sql, name = nil)
    return super unless sql =~ /^ALTER TABLE.*/
    $query_builder.add sql
  end

  def not_implemented(*)
    raise NotImplementedError.new(
      "This is not implemented with the percona tool, please use a standard migration"
    )
  end

  alias :create_table          :not_implemented
  alias :remove_table          :not_implemented
  alias :change_table          :not_implemented
  alias :create_join_table     :not_implemented
end
