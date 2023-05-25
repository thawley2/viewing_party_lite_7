class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      check_for_admin(user)
    else
      redirect_to login_path
      flash[:error] = 'Email or Password does not exist'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  private
  def check_for_admin(user)
    if user.admin?
      redirect_to admin_dashboard_path
    else
      redirect_to dashboard_path
    end
  end
end