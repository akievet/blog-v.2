class TaggedController < ApplicationController
  get '/:word' do
    tag = Tag.where(word: params[:word])
    @posts= tag[0].posts

    erb :'tagged/show'
  end
end