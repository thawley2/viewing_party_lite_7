class UsersController < ApplicationController
  before_action :get_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    if user.save
      redirect_to user_path(user.id)
    else
      flash[:error] = user.errors.full_messages.to_sentence
      redirect_to new_user_path
    end
  end

  def show
    @facade = MovieFacade
  end

  def login_form
  end

  def login_user
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user_path(user)
    else
      redirect_to login_path
      flash[:error] = 'Email or Password does not exist'
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def get_user
    @user = User.find(params[:id])
  end
end