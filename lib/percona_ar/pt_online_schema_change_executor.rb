require 'rake'
require 'rake/file_utils'

class PerconaAr::PtOnlineSchemaChangeExecutor
  include FileUtils

  attr_accessor :sql, :table

  def initialize(table, sql)
    @table = table
    @sql = sql
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
    ActiveRecord::Base.connection_config
  end
end
