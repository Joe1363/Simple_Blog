class CommentsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def create
    @article = Article.find(params[:id])
    @comment = Comment.new(comment_params)
    @comment.author = current_user.first_name + " " + current_user.last_name
    @comment.article_id = @article.id
    @comment.user_id = current_user.id
    if @comment.save
      redirect_to article_path(@article.id, anchor: 'comments')
    else
      flash[:notice] = "Comment can't be blank, silly"
      redirect_to article_path(@article.id, anchor: 'comments')
    end
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.update(comment_params)

    env["HTTP_REFERER"] += '#comments'
    redirect_to :back
  end

  def destroy
    @comment = Comment.find(params[:id])
    @article = @comment.article_id
    @comment.destroy

    redirect_to article_path(@article, anchor: 'comments')
  end

  private
    def comment_params
      params.require(:comment).permit(:content, :author)
    end
end
