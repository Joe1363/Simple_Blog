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
  it "should only display a user's articles to guest" do
    click_link "Propane and Propane Accessories"
    click_link "By Hank Hill"

    expect(page).to have_content "Hank Hill's Articles"
    expect(page).to have_content "Created"
    expect(page).to have_content "Edited"
    expect(page).to have_content "Article Title"
    expect(page).not_to have_content "Options"

    expect(page).to have_content "#{@bArticle.created_at.strftime("%m-%d-%y")}"
    expect(page).to have_content "#{@bArticle.updated_at.strftime("%m-%d-%y")}"
    expect(page).to have_content "Propane and Propane Accessories"
    expect(page).not_to have_selector(:link_or_button, "Edit")
    expect(page).not_to have_selector(:link_or_button, "Delete")
  end

  #### authors ####
  it "should only display another user's articles" do
    log_in @aUser
    click_link "Propane and Propane Accessories"
    click_link "By Hank Hill"

    expect(page).to have_content "Hank Hill's Articles"
    expect(page).to have_content "Created"
    expect(page).to have_content "Edited"
    expect(page).to have_content "Article Title"
    expect(page).not_to have_content "Options"

    expect(page).to have_content "#{@bArticle.created_at.strftime("%m-%d-%y")}"
    expect(page).to have_content "#{@bArticle.updated_at.strftime("%m-%d-%y")}"
    expect(page).to have_content "Propane and Propane Accessories"
    expect(page).not_to have_selector(:link_or_button, "Edit")
    expect(page).not_to have_selector(:link_or_button, "Delete")
  end

  it "should display own author's articles and edit/delete" do
    log_in @aUser
    click_link "Articles"
    click_link "Manage Article"

    expect(page).to have_content "Manage Articles"
    expect(page).to have_content "Created"
    expect(page).to have_content "Edited"
    expect(page).to have_content "Article Title"
    expect(page).to have_content "Options"

    expect(page).to have_content "#{@aArticle.created_at.strftime("%m-%d-%y")}"
    expect(page).to have_content "#{@aArticle.updated_at.strftime("%m-%d-%y")}"
    expect(page).to have_content "The Majestic Beauty Of The Roudhouse Kick"
    expect(page).to have_selector(:link_or_button, "Edit")
    expect(page).to have_selector(:link_or_button, "Delete")
  end

  #### moderators ####
  it "should display another user's articles with delete link but not edit link" do
    log_in @bUser
    click_link "The Majestic Beauty Of The Roudhouse Kick"
    click_link "By Chuck Norris"

    expect(page).to have_content "Chuck Norris's Articles"
    expect(page).to have_content "Created"
    expect(page).to have_content "Edited"
    expect(page).to have_content "Article Title"
    expect(page).to have_content "Options"

    expect(page).to have_content "#{@bArticle.created_at.strftime("%m-%d-%y")}"
    expect(page).to have_content "#{@bArticle.updated_at.strftime("%m-%d-%y")}"
    expect(page).to have_content "The Majestic Beauty Of The Roudhouse Kick"
    expect(page).not_to have_selector(:link_or_button, "Edit")
    expect(page).to have_selector(:link_or_button, "Delete")
  end

  it "should display moderators own articles and edit/delete links" do
    log_in @bUser
    click_link "Articles"
    click_link "Manage Article"

    expect(page).to have_content "Manage Articles"
    expect(page).to have_content "Created"
    expect(page).to have_content "Edited"
    expect(page).to have_content "Article Title"
    expect(page).to have_content "Options"

    expect(page).to have_content "#{@bArticle.created_at.strftime("%m-%d-%y")}"
    expect(page).to have_content "#{@bArticle.updated_at.strftime("%m-%d-%y")}"
    expect(page).to have_content "Propane and Propane Accessories"
    expect(page).to have_selector(:link_or_button, "Edit")
    expect(page).to have_selector(:link_or_button, "Delete")
  end

  #### admin ####
  it "should display an author's articles with delete links but not edit links" do
    log_in @cUser
    click_link "The Majestic Beauty Of The Roudhouse Kick"
    click_link "By Chuck Norris"

    expect(page).to have_content "Chuck Norris's Articles"
    expect(page).to have_content "Created"
    expect(page).to have_content "Edited"
    expect(page).to have_content "Article Title"
    expect(page).to have_content "Options"

    expect(page).to have_content "#{@bArticle.created_at.strftime("%m-%d-%y")}"
    expect(page).to have_content "#{@bArticle.updated_at.strftime("%m-%d-%y")}"
    expect(page).to have_content "The Majestic Beauty Of The Roudhouse Kick"
    expect(page).not_to have_selector(:link_or_button, "Edit")
    expect(page).to have_selector(:link_or_button, "Delete")
  end

  it "should display a moderators articles and delete links but not edit links" do
    log_in @cUser
    click_link "Propane and Propane Accessories"
    click_link "By Hank Hill"

    expect(page).to have_content "Hank Hill's Articles"
    expect(page).to have_content "Created"
    expect(page).to have_content "Edited"
    expect(page).to have_content "Article Title"
    expect(page).to have_content "Options"

    expect(page).to have_content "#{@bArticle.created_at.strftime("%m-%d-%y")}"
    expect(page).to have_content "#{@bArticle.updated_at.strftime("%m-%d-%y")}"
    expect(page).to have_content "Propane and Propane Accessories"
    expect(page).not_to have_selector(:link_or_button, "Edit")
    expect(page).to have_selector(:link_or_button, "Delete")
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
end
