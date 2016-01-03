require 'rails_helper'

describe "Article show page" do
  before(:each) do
    ## 1 article and 1 user(author)
    @aUser = FactoryGirl.create(:user)
    @aArticle = FactoryGirl.create(:article)
    @aArticle.user = @aUser
    @aUser.save
    @aArticle.save

    ## 1 article with 1 comment and 1 user(mod)
    @bUser = FactoryGirl.create(:moderator)
    @bArticle = FactoryGirl.create(:article, title: "Propane and Propane Accessories", author: "Hank Hill")
    @bArticle.user = @bUser
    @bUser.save
    @bArticle.save
    @bComment = FactoryGirl.create(:comment, user_id: @aUser.id)
    @bComment.article = @bArticle
    @bComment.save
    @bbComment = FactoryGirl.create(:comment, content: "That can be arranged", author: "Hank Hill", user_id: @bUser.id)
    @bbComment.article = @bArticle
    @bbComment.save
    ## 1 admin
    @cUser = FactoryGirl.create(:admin)

    visit '/'
  end

  #### guest ####
  it "should not show edit and destroy links for guests" do
    click_link "Propane and Propane Accessories"

    expect(page).not_to have_xpath("//a[@href='/comments/#{@bComment.id}/edit']")
    expect(page).not_to have_xpath("//a[@href='/comments/#{@bComment.id}']")
    expect(page).not_to have_xpath("//a[@href='/comments/#{@bbComment.id}/edit']")
    expect(page).not_to have_xpath("//a[@href='/comments/#{@bbComment.id}']")
  end

  it "should raise error if guest tries to access the urs for edit and destroy" do
    expect{visit "/comments/#{@bComment.id}/edit"}.to raise_error ()
    expect{visit "/comments/#{@bComment.id}"}.to raise_error ()
  end

  #### author ####
  it "should allow an author to delete their own comments", js: true  do
    log_in @bUser
    click_link "Propane and Propane Accessories"

    expect(page).to have_xpath("//a[@href='/comments/#{@bbComment.id}']")
    find(:xpath, "//a[@href='/comments/#{@bbComment.id}']").click
    page.evaluate_script('window.confirm = function() { return true; }')

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
end
