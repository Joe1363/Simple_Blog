class ArticlesController < ApplicationController
  def index
    @articles = Article.first(10)
  end

  def all
    @articles = Article.all
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.author = current_user.first_name + " " + current_user.last_name
    @article.user_id = current_user.id
    @article.save

    redirect_to "/users/user_articles"
  end

  def show
    @article = Article.find(params[:id])
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    @article.update(article_params)

    redirect_to "/users/user_articles"
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to "/users/user_articles"
  end

  private
    def article_params
      params.require(:article).permit(:title, :content, :author)
    end

end
