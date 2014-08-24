ENV["RACK_ENV"] ||= "development"

require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, ENV["RACK_ENV"].to_sym)

class BinxWidget < Sinatra::Base
  before do
    response.headers["access-control-allow-origin"] = "*"
    response.headers['access-control-allow-headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    response.headers['access-control-allow-methods'] = "GET, OPTIONS"
    response.headers['access-control-request-method'] = "*"
  end

  get '/' do
    erb :index
  end
end
