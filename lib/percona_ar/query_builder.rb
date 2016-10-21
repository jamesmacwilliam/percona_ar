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
    if sql =~ /^ALTER TABLE `([^`]*)` (.*)/i
      @tables[$1.to_s] << get_sql_for($2)
    end
    self
  end

  private

  def get_sql_for(cmd)
    return cmd unless cmd =~ /DROP/i && !(cmd =~ /COLUMN/i)
    cmd.gsub(/DROP/i, "DROP COLUMN")
  end

end
