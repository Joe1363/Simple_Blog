class UsersController < ApplicationController
  def user_articles
    @articles = current_user.articles
  end
end
