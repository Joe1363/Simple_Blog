require 'rails_helper'

describe Article, type: :model do
 it "should accept content, an author, and recieve a article_id" do
   #set up user for user_id in article
   aUser = User.new
   aUser.first_name = "Chuck"
   aUser.last_name = "Norris"
   aUser.email = "cn@yahoo.com"
   aUser.password = "password"
   aUser.encrypted_password = "password"
   aUser.save

   aArticle = Article.new
   aArticle.title = "The Majestic Beauty Of The Roudhouse Kick"
   aArticle.content = "Content"
   aArticle.author = "Chuck Norris"
   aArticle.user_id = aUser.id
   aArticle.save
   expect(aArticle.title).to eq "The Majestic Beauty Of The Roudhouse Kick"
   expect(aArticle.content).to eq "Content"
   expect(aArticle.author).to eq "Chuck Norris"
   expect(aArticle.user_id).to eq aUser.id
 end
end
