require 'rails_helper'

describe Comment, type: :model do
 it "should accept content, an author, and recieve a article_id" do
   #set up user and article for article_id in comment
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

   aComment = Comment.new
   aComment.content = "Your ideas are intriguing to me and I wish to subscribe to your newsletter"
   aComment.author = "Homer Simpson"
   aComment.article_id = aArticle.id
   aComment.save
   expect(aComment.content).to eq "Your ideas are intriguing to me and I wish to subscribe to your newsletter"
   expect(aComment.author).to eq "Homer Simpson"
   expect(aComment.article_id).to eq aArticle.id
 end
end
