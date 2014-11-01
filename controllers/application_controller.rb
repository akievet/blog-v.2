class ApplicationController < Sinatra::Base
  helpers Sinatra::AuthenticationHelper
  ActiveRecord::Base.establish_connection({
    adapter: 'postgresql',
    database: 'blog'
    })

  set :views, File.expand_path('../../views', __FILE__ )
  set :public, File.expand_path('../../public', __FILE__)

  enable :sessions, :method_override

  get '/' do
    @posts= Post.order(created_at: :desc)
    erb :index
  end

  get '/console' do
    binding.pry
  end
end