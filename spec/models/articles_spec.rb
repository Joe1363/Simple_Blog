require 'rails_helper'

describe Article, type: :model do
 it "should accept content, an author, and recieve a article_id" do
   aArticle = FactoryGirl.create(:article)
   aUser = aArticle.user
   aArticle.user_id = aUser.id
   aArticle.save

   expect(aArticle.title).to eq "The Majestic Beauty Of The Roudhouse Kick"
   expect(aArticle.content).to eq "Content"
   expect(aArticle.author).to eq "Chuck Norris"
   expect(aArticle.user_id).to eq aUser.id
 end
end
