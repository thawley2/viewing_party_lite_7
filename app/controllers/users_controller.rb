class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_path(@user)
    else
      flash[:error] = 'E-mail address must be unique.'
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def discover
    @user = User.find(params[:user_id])
  end

  private
  def user_params
    params.require(:user).permit(:name, :email)
  end
end