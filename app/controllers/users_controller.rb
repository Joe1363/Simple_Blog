class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @articles = @user.articles
  end
end
