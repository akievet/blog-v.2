class PostsController < ApplicationController
  get '/new' do
    admin_only!
    @tags= Tag.all
    erb :'posts/new'
  end

  post '/' do
    body= params[:body].gsub!("\r\n", "<br>")
    post= Post.create({title: params[:title], subtitle: params[:subtitle], body: body, head_img: params[:image], user_id: current_user.id})

    Image.create({image_src: params[:image_src], caption: params[:caption], post_id: post.id})

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
    posts = Post.order('created_at')
    index = posts.index(@post) - 1
    if posts[index] == nil
      @next= posts.sample
      @next_desc = "Suggested"
    else
      @next_desc = "Up Next"
      @next= posts[index]
    end
    erb :'posts/show'
  end

  get '/:id/edit' do
    admin_only!
    @post= Post.find(params[:id])
    if @post.body
      @post.body.gsub!("<br>", "\r\n")
    end
    @tags= @post.tags
    @images= @post.images
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
    content_type :json
    post= Post.find(params[:id])

    {
      current_tags: post.tags,
      other_tags: (Tag.all - post.tags)
    }.to_json
  end

  delete '/:id/tags' do
    content_type :json
    post= Post.find(params[:id])
    instance = (TagInstance.where("tag_id = ? AND post_id = ?", params[:tagId], params[:id]))[0]
    post.tag_instances.delete(instance)
    {status: 'ok'}.to_json
  end

  post '/:id/tags' do
    content_type :json
    post = Post.find(params[:id])
    post.tag_instances << TagInstance.new({tag_id: params[:tagId], post_id: post.id})
    {status: 'ok'}.to_json
  end


  get '/:id/tags/new' do
    admin_only!
    @post= Post.find(params[:id])
    erb :'posts/tags/new'
  end

  post '/:id/tags/new' do
    post= Post.find(params[:id])
    Tag.create({word: params[:word]})
    redirect "/posts/#{post.id}/tags"
  end

  get '/:id/images/new' do
    admin_only!
    @post= Post.find(params[:id])
    erb :'posts/images/new'
  end

  post '/:id/images' do
    post= Post.find(params[:id])
    Image.create(params[:img])
    redirect "/posts/#{post.id}"
  end

  delete '/:id/images/:img_id' do
    post= Post.find(params[:id])
    Image.destroy(params[:img_id])
    redirect "/posts/#{post.id}"
  end


end