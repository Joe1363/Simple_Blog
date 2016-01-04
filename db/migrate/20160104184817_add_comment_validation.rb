class AddCommentValidation < ActiveRecord::Migration
  def change
    change_column :comments, :content, :string, null: false
  end
end
