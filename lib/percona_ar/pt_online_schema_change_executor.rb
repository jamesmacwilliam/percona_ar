require 'rake'
require 'rake/file_utils'

class PerconaAr::PtOnlineSchemaChangeExecutor
  include FileUtils

  attr_accessor :sql

  def initialize(sql)
    @sql = sql
  end

  def call
    if sql =~ /^ALTER TABLE `([^`]*)` (.*)/i
      sh "#{boilerplate}#{suffix($1, $2)}"
    end
  end

  private

  def suffix(table, cmd)
    "'#{get_sql_for(cmd)}' --recursion-method none --no-check-alter --execute D=#{config[:database]},t=#{table}"
  end

  def get_sql_for(cmd)
    return cmd unless cmd =~ /DROP/i && !(cmd =~ /COLUMN/i)
    cmd.gsub(/DROP/i, "DROP COLUMN")
  end

  def boilerplate
    "pt-online-schema-change -u '#{config[:username]}' -h '#{config[:host]}' -p '#{config[:password]}' --alter "
  end

  def config
    ActiveRecord::Base.connection_config
  end
end
