class UsersController < ApplicationController
  before_action :authenticate_user!, :except => [:show]
  load_and_authorize_resource

  def show
    @user = User.find(params[:id])
    @articles = @user.articles
  end

  def tools
    @users = User.order(id: "asc")
  end

  def toggleMod
    @user = User.find(params[:id])

    if @user.role == "author"
      @user.role = "moderator"
      @user.save
    elsif @user.role == "admin"
      #can't unadmin the admin
    else
      @user.role = "author"
      @user.save
    end
    redirect_to "/users/tools"
  end

end
