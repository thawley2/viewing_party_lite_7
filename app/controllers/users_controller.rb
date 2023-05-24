class UsersController < ApplicationController
  before_action :get_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to dashboard_path
    else
      flash[:error] = user.errors.full_messages.to_sentence
      redirect_to new_user_path
    end
  end

  def show
    if current_user
      @facade = MovieFacade
    else
      flash[:error] = 'Must be logged in to access the dashboard.'
      redirect_to root_path
    end
  end

  def login_form
  end

  def login_user
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      check_for_admin(user)
    else
      redirect_to login_path
      flash[:error] = 'Email or Password does not exist'
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to root_path
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def get_user
    @user = current_user
  end

  def check_for_admin(user)
    if user.admin?
      redirect_to admin_dashboard_path
    else
      redirect_to dashboard_path
    end
  end
end