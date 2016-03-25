require "mysql2"
require "active_record"
require "active_record/connection_adapters/mysql2_adapter"
require "percona_ar/version"
require "percona_ar/pt_online_schema_change_executor"
require "percona_ar/connection"
require "percona_ar/migration"

module PerconaAr
end
