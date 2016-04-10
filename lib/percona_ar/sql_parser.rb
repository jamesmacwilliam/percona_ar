class PerconaAr::SqlParser
  attr_accessor :sql

  def initialize(sql)
    @sql = sql
  end

  def parse
    if sql =~ /^ALTER TABLE `([^`]*)` (.*)/i
      {
        table: $1,
        cmd:   fix_drop_statement_for($2)
      }
    else
      raise "attempted to parse an sql statement that was not a schema update"
    end
  end

  def self.parse(sql)
    new(sql).parse
  end

  private

  def fix_drop_statement_for(cmd)
    return cmd unless cmd =~ /DROP/i && !(cmd =~ /COLUMN/i)
    cmd.gsub(/DROP/i, "DROP COLUMN")
  end

end
