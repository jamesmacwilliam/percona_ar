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
    "'#{cmd}' --recursion-method processlist --no-check-alter --execute D=#{config[:database]},t=#{table}"

  end

  def boilerplate
    "pt-online-schema-change -u '#{config[:username]}' -h '#{config[:host]}' -p '#{config[:password]}' --alter "
  end

  def config
    ActiveRecord::Base.connection_config
  end
end
