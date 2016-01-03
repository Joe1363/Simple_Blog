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
    click_link "New Article"

    checkNewPageContent()
  end

  private
    def checkNewPageContent
      expect(page).to have_content "Create A New Article"
      expect(page).to have_content "Article Title"
      expect(page).to have_content "Article Content"
      expect(page).to have_selector(:link_or_button, "Post Article")
    end
end
