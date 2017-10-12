class PerconaAr::QueryBuilder
  def initialize(conn = ActiveRecord::Base.connection)
    @tables = Hash.new {|h, k| h[k] = [] }
    @conn = conn
  end

  def execute
    @tables.each do |table, snippets|
      PerconaAr::PtOnlineSchemaChangeExecutor.new(table, snippets.join(", "), @conn).call
    end
  end

  def add(sql)
    # DROP INDEX `index_studies_on_added_column` ON `studies`
    if sql =~ /^ALTER TABLE `([^`]*)` (.*)/i
      @tables[$1.to_s] << get_sql_for($2)
    elsif sql =~ /DROP INDEX/i
      drop_clause, table = sql.split(/ ON /i)
      @tables[table] << get_sql_for(drop_clause)
    end
    self
  end

  private

  def get_sql_for(cmd)
    return cmd unless cmd =~ /DROP/i && !(cmd =~ /COLUMN/i)
    return cmd if cmd =~ /DROP INDEX/i
    cmd.gsub(/DROP/i, "DROP COLUMN")
  end

end
