require 'rake'
require 'rake/file_utils'
require 'percona_ar/sql_parser'

class PerconaAr::PtOnlineSchemaChangeExecutor
  include FileUtils

  attr_accessor :sql

  def initialize(sql)
    @sql = sql
  end

  def call
    sh "#{boilerplate}#{suffix(PerconaAr::SqlParser.parse(sql))}"
  end

  private

  def suffix(table:, cmd:)
    "'#{cmd}' --recursion-method none --no-check-alter --execute D=#{config[:database]},t=#{table}"
  end

  def boilerplate
    "pt-online-schema-change -u '#{config[:username]}' -h '#{config[:host]}' -p '#{config[:password]}' --alter "
  end

  def config
    ActiveRecord::Base.connection_config
  end
end
