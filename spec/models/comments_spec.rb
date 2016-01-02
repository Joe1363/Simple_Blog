require 'rails_helper'

describe Comment, type: :model do
 it "should accept content, an author, and recieve a article_id" do
   aComment = FactoryGirl.create(:comment)
   aArticle = aComment.article
   aComment.article_id = aArticle.id
   aComment.save
   
   expect(aComment.content).to eq "Your ideas are intriguing to me and I wish to subscribe to your newsletter"
   expect(aComment.author).to eq "Homer Simpson"
   expect(aComment.article_id).to eq aArticle.id
 end
end
