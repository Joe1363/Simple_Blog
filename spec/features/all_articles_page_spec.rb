require 'rails_helper'

describe "Main page" do
  before(:each) do
    ## 1 article by 1 user(author)
    @aUser = FactoryGirl.create(:user)
    @aArticle = FactoryGirl.create(:article)
    @aArticle.user = @aUser
    @aUser.save
    @aArticle.save

    ## 1 article by 1 user(mod)
    @bUser = FactoryGirl.create(:moderator)
    @bArticle = FactoryGirl.create(:article, title: "Propane and Propane Accessories", author: "Hank Hill")
    @bArticle.user = @bUser
    @bUser.save
    @bArticle.save

    ## 1 admin
    @cUser = FactoryGirl.create(:admin)

    visit '/'
  end

  #### guests ####
  it "should display all articles for guests" do
    click_link 'View Articles'
    checkArticles()
  end

  #### authors ####
  it "should display all articles for authors" do
    click_link 'View Articles'
    checkArticles()
  end

  #### moderators ####
  it "should display all articles for moderators" do
    click_link 'View Articles'
    checkArticles()
  end

  #### admin ####
  it "should display all articles for admin" do
    click_link 'View Articles'
    checkArticles()
  end

  private
    def checkArticles()
      within("body") do
        expect(page).to have_content "All Articles"
        expect(page).to have_content "The Majestic Beauty Of The Roudhouse Kick"
        expect(page).to have_content "by Chuck Norris"
        expect(page).to have_content "Content"

        expect(page).to have_content "Propane and Propane Accessories"
        expect(page).to have_content "by Hank Hill"
        expect(page).to have_content "Content"
      end
    end

end
