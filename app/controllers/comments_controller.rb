class CommentsController < ApplicationController
  def create
    @article = Article.find(params[:id])
    @comment = Comment.new(comment_params)
    @comment.author = current_user.first_name + " " + current_user.last_name
    @comment.article_id = @article.id
    @comment.user_id = current_user.id
    @comment.save

    redirect_to "/articles/#{@article.id}"
  end

  def update
  end

  def destroy
    @comment = Comment.find(params[:id])
    article = @comment.article_id
    @comment.destroy

    redirect_to "/articles/#{article}"
  end

  private
    def comment_params
      params.require(:comment).permit(:content, :author)
    end
end
