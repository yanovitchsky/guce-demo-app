require 'sinatra'
require 'json'

set :bind, '0.0.0.0'
set :port, 8081

get '/' do
  content_type :json
  { message: 'Hello from GUCE Demo API 🎉' }.to_json
end

get '/health' do
  content_type :json
  { status: 'ok' }.to_json
end