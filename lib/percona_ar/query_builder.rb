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
    if sql =~ /^ALTER TABLE `?([^ `]*)`? (.*)/i
      @tables[$1.to_s] << get_sql_for($2)
    elsif sql =~ /DROP INDEX/i
      drop_clause, table = sql.split(/ ON /i)
      @tables[table.delete('`')] << get_sql_for(drop_clause)
    elsif sql =~ /CREATE  INDEX (`?[^ ]*)  ON `?([^ `]*)`? (.*)/i
      @tables[$2] << get_sql_for("ADD INDEX #{$1} #{$3}")
    end
    self
  end

  private

  def get_sql_for(cmd)
    return cmd unless cmd =~ /DROP/i && !(cmd =~ /COLUMN/i)
    return cmd if cmd =~ /DROP INDEX/i
    cmd.gsub(/(^| )DROP /i, " DROP COLUMN ")
  end

end
