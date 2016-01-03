require 'rails_helper'

describe "New article page" do
  before(:each) do
    ## 1 author
    @aUser = FactoryGirl.create(:user)
    ## 1 moderator
    @bUser = FactoryGirl.create(:moderator)
    ## 1 admin
    @cUser = FactoryGirl.create(:admin)

    visit '/'
  end

  #### guests ####
  it "should redirect to log in page if guest tries to access the new article page" do
    visit "/articles/new"

    expect(page).to have_content "Log in"
    expect(page).to have_content "Email"
    expect(page).to have_content "Password"
    expect(page).to have_selector(:link_or_button, "Log in")
  end

  #### authors ####
  it "should let an author create a new article" do
    log_in @aUser

    click_link "Articles"
    click_link "New Article"

    checkNewPageContent()
    fillInFields()
    expect(page).to have_content "A Well Thought-out Englilsh Paper"
  end

  #### moderators ####
  it "should let an author create a new article" do
    log_in @bUser

    click_link "Articles"
    click_link "New Article"

    checkNewPageContent()
    fillInFields()
    expect(page).to have_content "A Well Thought-out Englilsh Paper"
  end

  #### admin ####
  it "should let an author create a new article" do
    log_in @cUser

    click_link "Articles"
    click_link "New Article"

    checkNewPageContent()
    fillInFields()
    expect(page).to have_content "A Well Thought-out Englilsh Paper"
  end

  private
    def log_in(user)
      visit 'users/sign_in'
      within('.row') do
        fill_in "Email", :with => user.email
        fill_in "Password", :with => user.password
        click_button "Log in"
      end
    end

    def checkNewPageContent
      expect(page).to have_content "Create A New Article"
      expect(page).to have_content "Article Title"
      expect(page).to have_content "Article Content"
      expect(page).to have_selector(:link_or_button, "Post Article")
    end

    def fillInFields
      fill_in "Article Title", :with => "A Well Thought-out Englilsh Paper"
      fill_in "Article Content", :with => "Something about hustle and bustle"
      click_button "Post Article"
    end
end
