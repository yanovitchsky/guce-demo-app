require 'sinatra'
require 'json'
require 'sequel'

set :bind, '0.0.0.0'
set :port, 8081

# Simple CORS for React client
before do
  headers 'Access-Control-Allow-Origin' => '*',
          'Access-Control-Allow-Methods' => 'GET,POST,PUT,PATCH,DELETE,OPTIONS',
          'Access-Control-Allow-Headers' => 'Content-Type, Authorization'
end

options '*' do
  200
end

# Database setup (Postgres)
db_url = ENV['DATABASE_URL']
if !db_url || db_url.strip.empty?
  pg_user = ENV['POSTGRES_USER'] || 'postgres'
  pg_pass = ENV['POSTGRES_PASSWORD'] || 'postgres'
  pg_host = ENV['POSTGRES_HOST'] || 'localhost'
  pg_port = (ENV['POSTGRES_PORT'] || '5432')
  pg_db   = ENV['POSTGRES_DB'] || 'guce_demo'
  db_url = "postgres://#{pg_user}:#{pg_pass}@#{pg_host}:#{pg_port}/#{pg_db}"
end
DB = Sequel.connect(db_url)

unless DB.table_exists?(:pokemons)
  DB.create_table :pokemons do
    primary_key :id
    String :name, null: false
    String :type_primary, null: false
    String :type_secondary
  end
end

POKEMONS = DB[:pokemons]

# Seed on boot if empty
if POKEMONS.count == 0
  require_relative 'db/seeds'
  Seeds.seed_pokemons(DB)
end

get '/' do
  content_type :json
  { message: 'Hello from GUCE Demo API 🎉' }.to_json
end

get '/health' do
  content_type :json
  { status: 'ok' }.to_json
end

# API for React app
get '/pokemons' do
  content_type :json
  pokes = POKEMONS
          .order(:id)
          .all
          .map { |p| { id: p[:id], name: p[:name], type_primary: p[:type_primary], type_secondary: p[:type_secondary] } }
  puts "pokes: #{pokes}"
  { data: pokes }.to_json
end

get '/pokemons/:id' do
  content_type :json
  id = params[:id].to_i
  p = POKEMONS.where(id: id).first
  halt 404, { error: 'Not found' }.to_json unless p
  { id: p[:id], name: p[:name], type_primary: p[:type_primary], type_secondary: p[:type_secondary] }.to_json
end