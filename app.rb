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
  images= ['010130005.JPG', '010130009.JPG', '010130015.JPG', '010130019.JPG']
  @image= images.select
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
  @tags= Tag.all
  erb :'posts/new'
end

post '/posts' do
  binding.pry
  body= params[:body].gsub!("\r\n", "<br>")
  post= Post.create({title: params[:title], subtitle: params[:subtitle], body: body, user_id: current_user.id})
  tag_ids= params[:word]
  tag_ids.each do |tag_id|
    tag_id= tag_id.to_i
    TagInstance.create({tag_id: tag_id, post_id: post.id})
  end
  redirect '/'
end

get '/posts/:id' do
  @post= Post.find(params[:id])
  @tags= @post.tags
  erb :'posts/show'
end

get '/posts/:id/edit' do
  admin_only!
  @post= Post.find(params[:id])
  if @post.body
    @post.body.gsub!("<br>", "\r\n")
  end
  @tags= @post.tags
  erb :'posts/edit'
end

patch '/posts/:id' do
  post= Post.find(params[:id])
  body= params[:body].gsub!("\r\n", "<br>")
  post.update(title: params[:title], subtitle: params[:subtitle], body: body)

  redirect "/"
end

delete '/posts/:id' do
  Post.destroy(params[:id])
  redirect '/'
end

get '/posts/:id/tags' do
  @post= Post.find(params[:id])
  @current_tags = @post.tags
  @other_tags = (Tag.all - @current_tags)
  erb :'posts/tags/edit'
end

post '/posts/:id/tags' do
  post= Post.find(params[:id])
  current_instances= post.tag_instances
  current_instances.each do |tag_instance|
    TagInstance.destroy(tag_instance.id)
  end

  tag_ids= params[:word]
  tag_ids.each do |tag_id|
    tag_id= tag_id.to_i
    TagInstance.create({tag_id: tag_id, post_id: post.id})
  end

  redirect "/posts/#{post.id}"
end

get '/posts/:id/tags/new' do
  @post= Post.find(params[:id])
  erb :'posts/tags/new'
end

post '/posts/:id/tags/new' do
  post= Post.find(params[:id])
  Tag.create({word: params[:word]})
  redirect "/posts/#{post.id}/tags"
end

get '/tagged/:word' do
  tag = Tag.where(word: params[:word])
  @posts= tag[0].posts

  erb :'tagged/show'
end

get '/tags' do
  @tags= Tag.all
  erb :'tags/index'
end

post '/tags' do
  Tag.create({word: params[:word]})
  redirect '/tags'
end


get '/tags/:id/edit' do
  @tag= Tag.find(params[:id])
  erb :'tags/show'
end

patch '/tags/:id' do
  tag= Tag.find(params[:id])
  tag.update({word: params[:word]})
  redirect "/tags"
end

delete '/tags/:id' do
  Tag.destroy(params[:id])
  redirect "/tags"
end