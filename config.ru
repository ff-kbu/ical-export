require 'rubygems'
require 'sinatra'
require 'ff-kbu_export.rb'


set :environment, ENV['RACK_ENV'].to_sym
set :app_file,     'ical_export.rb'
disable :run

log = File.new("logs/sinatra.log", "a")
STDOUT.reopen(log)
STDERR.reopen(log)

run Sinatra::Application

#run Sinatra::Application

