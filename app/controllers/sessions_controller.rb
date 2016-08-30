class SessionsController < ApplicationController
  skip_before_action :authorize
  before_action :redirect_if_first_user, only: :create

  def new
  end

  def create
    user = User.find_by(name: params[:name])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to admin_url
    else
      redirect_to login_url, alert: 'Ivalid user/password combination'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to store_url, notice: 'Logged out'
  end

  private

    def redirect_if_first_user
      if User.count.zero?
        redirect_to new_user_path(name: params[:name])
      end
    end
end
