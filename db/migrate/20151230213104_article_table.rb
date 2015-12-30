class ArticleTable < ActiveRecord::Migration
  create_table(:articles) do |t|
    t.string :title
    t.string :author
    t.string :content

    t.timestamps null: false
  end
end
