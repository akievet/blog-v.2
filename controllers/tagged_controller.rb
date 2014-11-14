class TaggedController < ApplicationController
  get '/:word' do
    @tag = Tag.where(word: params[:word])[0]
    @posts= @tag.posts

    erb :'tagged/show'
  end
end