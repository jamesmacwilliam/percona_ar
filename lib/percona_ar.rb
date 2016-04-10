require "mysql2"
require "active_record"
require "active_record/connection_adapters/mysql2_adapter"
require "percona_ar/version"
require "percona_ar/pt_online_schema_change_executor"
require "percona_ar/connection"
require "percona_ar/migration"

module PerconaAr
  cattr_accessor :configuration

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :mailer_sender

    def initialize
      @mailer_sender = 'donotreply@example.com'
    end
  end
end

