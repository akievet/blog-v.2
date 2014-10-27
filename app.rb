require 'bundler'
Bundler.require

ROOT_PATH = Dir.pwd
Dir[ROOT_PATH+"/models/*.rb"].each{ |file| require file}
Dir[ROOT_PATH+"/helpers/*.rb"].each{ |file| require file}
require './connection'


enable :sessions

get '/console' do
  binding.pry
end

get '/' do
  @posts= Post.order(created_at: :desc)
  erb :index
end

get '/users/new' do
  erb :'users/new'
end

post '/users' do
  user = User.new(params[:user])
  user.password = params[:password]
  user.save!
  redirect '/'
end

get '/login' do
  erb :'sessions/login'
end

post '/sessions' do
  redirect '/' unless user = User.find_by({username: params[:username]})
  if user.password == params[:password]
    session[:current_user] = user.id
    redirect '/'
  else
    redirect '/'
  end
end

delete '/sessions' do
  session[:current_user] = nil
  redirect '/'
end

get '/posts/new' do
  admin_only!
  erb :'posts/new'
end

post '/posts' do
  post= Post.create({title: params[:title], subtitle: params[:subtitle], body: params[:body], user_id: current_user.id})
  tags= (params[:tags]).split(",")
  tags.each do |tag|
    Tag.create({word: tag, post_id: post.id})
  end
  redirect '/'
end

get '/posts/:id' do
  @post= Post.find(params[:id])
  erb :'posts/show'
end

get '/posts/:id/edit' do
  admin_only!
  @post= Post.find(params[:id])
  erb :'posts/edit'
end

patch '/posts/:id' do
  post= Post.find(params[:id])
  post.update(params[:post])
  redirect "/posts/#{post.id}"
end
