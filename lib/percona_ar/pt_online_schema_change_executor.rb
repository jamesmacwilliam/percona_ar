require 'rake'
require 'rake/file_utils'

class PerconaAr::PtOnlineSchemaChangeExecutor
  include FileUtils

  attr_accessor :sql, :table, :conn

  def initialize(table, sql, conn = ActiveRecord::Base.connection)
    @table = table
    @sql = sql
    @conn = conn
  end

  def call
    sh %Q(#{boilerplate}#{suffix(table, sql)})
  end

  private

  def suffix(table, cmd)
    %Q('#{cmd.gsub("'","\"")}' --recursion-method none --no-check-alter --execute D=#{config[:database]},t=#{table})
  end

  def boilerplate
    "pt-online-schema-change -u '#{config[:username]}' -h '#{config[:host]}' -p '#{config[:password]}' --alter "
  end

  def config
    conn.instance_variable_get(:@config)
  end
end
