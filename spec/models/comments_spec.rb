require 'rails_helper'

describe Comment, type: :model do
 it "should accept content, an author, and recieve a article_id" do
   aUser = FactoryGirl.create(:user)
   aArticle = FactoryGirl.create(:article)
   aComment = FactoryGirl.create(:comment)
   aArticle.user = aUser
   aUser.save
   aArticle.save
   aComment.article = aArticle
   aComment.save

   expect(aComment.content).to eq "Your ideas are intriguing to me and I wish to subscribe to your newsletter"
   expect(aComment.author).to eq "Homer Simpson"
   expect(aComment.article_id).to eq aArticle.id
 end
end
