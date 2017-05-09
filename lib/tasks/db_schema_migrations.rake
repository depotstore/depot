namespace :db do
  desc "Prints the magrated versions"
  task :schema_migrations => :environment do
    puts ActiveRecord::Base.connection.select_values(
    'select version from schema_migrations order by version'
    # 'select name from orders ORDER BY name asc limit 3'
    )

  end
end
