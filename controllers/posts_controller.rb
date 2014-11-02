class PostsController < ApplicationController
  get '/new' do
    admin_only!
    @tags= Tag.all
    erb :'posts/new'
  end

  post '/' do
    binding.pry
    body= params[:body].gsub!("\r\n", "<br>")
    post= Post.create({title: params[:title], subtitle: params[:subtitle], body: body, head_img: params[:image], user_id: current_user.id})
    tag_ids= params[:word]
    tag_ids.each do |tag_id|
      tag_id= tag_id.to_i
      TagInstance.create({tag_id: tag_id, post_id: post.id})
    end
    redirect "/"
  end

  get '/:id' do
    @post= Post.find(params[:id])
    @tags= @post.tags
    erb :'posts/show'
  end

  get '/:id/edit' do
    admin_only!
    @post= Post.find(params[:id])
    if @post.body
      @post.body.gsub!("<br>", "\r\n")
    end
    @tags= @post.tags
    erb :'posts/edit'
  end

  patch '/:id' do
    post= Post.find(params[:id])
    body= params[:body].gsub!("\r\n", "<br>")
    post.update(title: params[:title], subtitle: params[:subtitle], body: body, head_img: params[:image])

    redirect "/posts/#{post.id}"
  end

  delete '/:id' do
    Post.destroy(params[:id])
    redirect '/'
  end

  get '/:id/tags' do
    @post= Post.find(params[:id])
    @current_tags = @post.tags
    @other_tags = (Tag.all - @current_tags)
    erb :'posts/tags/edit'
  end

  post '/:id/tags' do
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

  get '/:id/tags/new' do
    @post= Post.find(params[:id])
    erb :'posts/tags/new'
  end

  post '/:id/tags/new' do
    post= Post.find(params[:id])
    Tag.create({word: params[:word]})
    redirect "/posts/#{post.id}/tags"
  end


end