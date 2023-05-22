class UsersController < ApplicationController
  before_action :get_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    begin
      @user = User.create!(user_params)
      redirect_to user_path(@user.id)
    rescue ActiveRecord::RecordInvalid => exception
      flash[:error] = exception.message
      redirect_to new_user_path
    end
  end

  def show
    @facade = MovieFacade
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def get_user
    @user = User.find(params[:id])
  end
end