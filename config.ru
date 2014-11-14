require 'bundler'
Bundler.require

require ./helpers/application_helper
require ./controllers/application_controller

Dir.glob('./{helpers,models,controllers}/*.rb').each do |file|
	require file
	puts "required #{file}"
end

map('/'){ run ApplicationController }
map('/users'){ run UsersController }
map('/sessions'){ run SessionsController }
map('/posts'){ run PostsController }
map('/tags'){ run TagsController }
map('/tagged'){ run TaggedController }
