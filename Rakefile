require 'bundler'
Bundler.require

require 'sinatra/activerecord/rake'
ActiveRecord::Base.establish_connection({
    adapter: 'postgresql',
    database: 'blog'
})

namespace :db do
  desc 'create blog database'
  task :create_db do
    conn = PG::Connection.open()
    conn.exec('CREATE DATABASE blog;')
    conn.close
  end
  desc 'drop blog database'
  task :drop_db do
    conn = PG::Connection.open()
    conn.exec('DROP DATABASE blog;')
    conn.close
  end


end