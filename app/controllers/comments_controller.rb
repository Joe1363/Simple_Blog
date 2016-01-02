class CommentsController < ApplicationController
  def create
    @article = Article.find(params[:id])
    @comment = Comment.new(comment_params)
    @comment.author = current_user.first_name + " " + current_user.last_name
    @comment.article_id = @article.id
    @comment.save

    redirect_to "/articles/#{@article.id}"
  end

  private
    def comment_params
      params.require(:comment).permit(:content, :author)
    end
end
