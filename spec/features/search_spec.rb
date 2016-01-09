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

  #### guest ####
  it "should let a guest search case-insensitively for articles by title and author" do

    do_the_search()
  end

  #### author ####
  it "should let an author search case-insensitively for articles by title and author" do
    log_in @aUser
    do_the_search()
  end

  #### moderator ####
  it "should let a moderator search case-insensitively for articles by title and author" do
    log_in @bUser
    do_the_search()
  end

  #### admin ####
  it "should let an admin search case-insensitively for articles by title and author" do
    log_in @cUser
    do_the_search()
  end

  def log_in(user)
    visit 'users/sign_in'
    within('#login') do
      fill_in "Email", :with => user.email
      fill_in "Password", :with => user.password
      click_button "Log in"
    end
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

  def do_the_search
    click_link "Articles"
    click_link "Search"

    expect(page).to have_content "Search For Articles"
    expect(page).to have_css('input[type="text"]')
    expect(page).to have_selector(:link_or_button, "Search")

    fill_form("Propane and Propane Accessories")
    fill_form("proPane")
    fill_form("Hank Hill")
    fill_form("hAnK")
  end

  def fill_form s
    fill_in "search", :with => "#{s}"
    click_button "Search"
    expect(page).to have_content "Propane and Propane Accessories by Hank Hill"
    expect(page).to have_selector(:xpath, "//a[@href='/articles/#{@bArticle.id}']")
  end
end
