class ArticlesController < ApplicationController
  def index
    @articles = Article.order(created_at: :desc)
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.author = current_user.first_name + " " + current_user.last_name
    @article.save

    redirect_to "/"
  end

  def show
    @article = Article.find(params[:id])
  end

  private
    def article_params
      params.require(:article).permit(:title, :content, :author)
    end

end
