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
  end

  #### guests ####
  it "should display articles and the un-signed in navbar for guests" do
    visit "/"
    within(".navbar") do
      expect(page).to have_content "Simple Blog"
      expect(page).to have_content "Articles"
      expect(page).to have_content "View Article"
      expect(page).to have_content "Search"
      expect(page).to have_content "Log In"
      expect(page).to have_content "Sign Up"

      expect(page).not_to have_content "Hello"
      expect(".dropdown").not_to have_content "Article"
      expect(page).not_to have_content "Tools"
      expect(page).not_to have_content "Settings"
      expect(page).not_to have_content "Logout"
    end
    checkArticles()
  end

  #### authors ####
  it "should display articles and the signed in navbar for authors" do
    log_in @aUser
    visit "/"

    checkNav @aUser
    within(".navbar") do
      expect(page).not_to have_content "Tools"
    end
    checkArticles()
  end

  #### moderators ####
  it "should display articles and the signed in navbar for moderator" do
    log_in @bUser
    visit "/"

    checkNav @bUser
    within(".navbar") do
      expect(page).not_to have_content "Tools"
    end
    checkArticles()
  end

  #### admin ####
  it "should display articles and the signed in navbar for moderator" do
    log_in @cUser
    visit "/"

    checkNav @cUser
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

    def checkNav(user)
      within(".navbar") do
        expect(page).to have_content "Simple Blog"
        expect(page).to have_content "Hello #{user.first_name}!"
        expect(page).to have_content "Articles"
        expect(page).to have_content "View Article"
        expect(page).to have_content "Search"
        expect(page).to have_content "Settings"
        expect(page).to have_content "Logout"
      end
    end

    def checkArticles()
      within("body") do
        expect(page).to have_content "Newest Articles"
        expect(page).to have_content "The Majestic Beauty Of The Roudhouse Kick"
        expect(page).to have_content "by Chuck Norris"
        expect(page).to have_content "Content"

        expect(page).to have_content "Propane and Propane Accessories"
        expect(page).to have_content "by Hank Hill"
        expect(page).to have_content "Content"
      end
    end
end
