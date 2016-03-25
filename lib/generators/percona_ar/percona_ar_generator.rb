class PerconaArGenerator < Rails::Generators::NamedBase
  def create_percona_file
    create_file(filename, <<-EOT)
class #{name} < PerconaAr::Migration
  def change
    # ALTER commands will get run by the Percona tool,
    # all other commands will get run by ActiveRecord
  end
end
    EOT
  end

  def filename
    "db/migrate/#{Time.now.strftime("%Y%m%d%H%M%S")}_#{name.underscore}.rb"
  end
end
