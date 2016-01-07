require 'rails_helper'

describe "All articles page" do
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
    log_in @aUser
    click_link 'View Articles'
    checkArticles()
  end

  #### moderators ####
  it "should display all articles for moderators" do
    log_in @bUser
    click_link 'View Articles'
    checkArticles()
  end

  #### admin ####
  it "should display all articles for admin" do
    log_in @cUser
    click_link 'View Articles'
    checkArticles()
  end

  private
    def log_in(user)
      visit 'users/sign_in'
      within('#login') do
        fill_in "Email", :with => user.email
        fill_in "Password", :with => user.password
        click_button "Log in"
      end
    end

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
