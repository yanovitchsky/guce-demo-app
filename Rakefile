require 'rake'
require 'sequel'
require_relative './db/seeds'

namespace :db do
  def build_db_params
    db_url = ENV['DATABASE_URL']
    return URI.parse(db_url) if db_url && !db_url.strip.empty?

    user = ENV['POSTGRES_USER'] || 'postgres'
    pass = ENV['POSTGRES_PASSWORD'] || 'postgres'
    host = ENV['POSTGRES_HOST'] || 'localhost'
    port = (ENV['POSTGRES_PORT'] || '5432')
    db   = ENV['POSTGRES_DB'] || 'guce_demo'

    URI.parse("postgres://#{user}:#{pass}@#{host}:#{port}/#{db}")
  end

  def admin_db_url
    uri = build_db_params
    admin_uri = uri.dup
    admin_uri.path = '/postgres'
    admin_uri
  end

  def target_db_name
    uri = build_db_params
    (uri.path || '/guce_demo').sub('/', '')
  end

  desc 'Create the target PostgreSQL database if it does not exist'
  task :create do
    require 'uri'
    dbname = target_db_name
    admin  = Sequel.connect(admin_db_url.to_s)

    exists = admin.fetch('SELECT 1 FROM pg_database WHERE datname = ?', dbname).any?
    if exists
      puts "Database '#{dbname}' already exists."
    else
      safe_name = '"' + dbname.gsub('"', '""') + '"'
      admin.run("CREATE DATABASE #{safe_name} ENCODING 'UTF8' TEMPLATE template1")
      puts "Created database '#{dbname}'."
    end
  ensure
    admin&.disconnect
  end

  desc 'Seed the database with initial Pokémon data'
  task :seed do
    require_relative './app'
    puts 'Seeding pokemons...'
    Seeds.seed_pokemons(DB)
    puts 'Done.'
  end
end

task default: 'db:seed'


