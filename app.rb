require "rubygems"

require "sinatra"
require 'dm-core'
require 'dm-migrations'
require 'lib/sokoban_loader'
require 'json'


class SokobanLevel
  include DataMapper::Resource
  property :id, Serial, :key => true
  property :text, Text
  property :copyright, String
end

conn_string = "sqlite3://#{Dir.pwd}/sokoban-levels.db"

configure :production do
  if ENV['VCAP_SERVICES']
    require "json"
    mysql_service = JSON.parse(ENV['VCAP_SERVICES'])['mysql-5.1'].first
    dbname   = mysql_service['credentials']['name']
    username = mysql_service['credentials']['username']
    password = mysql_service['credentials']['password']
    host     = mysql_service['credentials']['host']
    port     = mysql_service['credentials']['port']
    conn_string = "mysql://#{username}:#{password}@#{host}:#{port}/#{dbname}"
  end
end

DataMapper.setup(:default, conn_string)
DataMapper.finalize
DataMapper.auto_upgrade!


helpers do
  def h(html_test)
    Rack::Utils.escape_html(html_test)
  end
end

get "/" do
  @levels = SokobanLevel.all
  erb :index
end

get "/random" do
  level = SokobanLevel.first(:offset => rand(SokobanLevel.count))
  ret = {}
  ret[:copyright] = level.copyright
  ret[:text] = level.text
  ret.to_json
end


get "/load" do
  SokobanLevel.all.destroy!

  levels_base = "./sokoban-levels"

  sokoban_loader = SokobanLoader.new
  Dir["#{levels_base}/*.slc"].each do |file| 
    basename = File.basename(file)
    cnt = File.open(file).read
    sokoban_loader.parse basename, cnt

    copyright = sokoban_loader.copyright

    sokoban_loader.levels.each do |level|
      db_level = SokobanLevel.new
      db_level.copyright = copyright
      db_level.text = level[:text]
      db_level.save
    end
  end
  redirect '/'
end