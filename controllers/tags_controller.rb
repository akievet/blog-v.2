class TagsController < ApplicationController
  get '/' do
    @tags= Tag.all
    erb :'tags/index'
  end

  post '/' do
    Tag.create({word: params[:word]})
    redirect '/tags'
  end


  get '/:id/edit' do
    @tag= Tag.find(params[:id])
    erb :'tags/show'
  end

  patch '/:id' do
    tag= Tag.find(params[:id])
    tag.update({word: params[:word]})
    redirect "/tags"
  end

  delete '/:id' do
    Tag.destroy(params[:id])
    redirect "/tags"
  end
end