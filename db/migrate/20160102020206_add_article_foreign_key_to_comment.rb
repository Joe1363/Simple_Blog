class AddArticleForeignKeyToComment < ActiveRecord::Migration
  def change
    add_column :comments, :article_id, :integer

    add_foreign_key :comments, :articles
  end
end
