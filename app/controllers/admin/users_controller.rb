class Admin::UsersController < ApplicationController
  before_action :require_admin

  def show
  end

  private
    def require_admin
      render file: "/public/404.html" unless current_admin?
    end
end