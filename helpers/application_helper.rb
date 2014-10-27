module Sinatra
  module AuthenticationHelper

    def current_user
      if session[:current_user]
        @current_user ||= User.find(session[:current_user])
      else
        nil
      end
    end

    def authenticate!
      redirect '/' unless current_user
    end

    def admin
      admin= User.find(1)
      current_user == admin
    end

    def admin_only!
      unless admin
        redirect '/'
      end
    end

  end
  helpers AuthenticationHelper
end
