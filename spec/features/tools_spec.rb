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

  #### admin ####
  it "should diplay the tools page for admin" do
    log_in @cUser
    click_link "Tools"

    expect(page).to have_content "Admin Tools"
    expect(page).to have_content "Name"
    expect(page).to have_content "Role"
    expect(page).to have_content "Options"
    expect(page).to have_content "Chuck Norris"
    expect(page).to have_content "moderator"
    expect(page).to have_content "Hank Hill"
    expect(page).to have_content "author"
    expect(page).to have_content "admin"
    expect(page).to have_selector(:link_or_button, "Toggle Moderator")
  end

  it "should toggle an author to moderator" do
    log_in @cUser
    click_link "Tools"

    find(:xpath, "//a[@href='/users/tools/#{@aUser.id}']").click
    expect(page).not_to have_content "author"
  end

  it "should toggle a moderator to author" do
    log_in @cUser
    click_link "Tools"

    find(:xpath, "//a[@href='/users/tools/#{@bUser.id}']").click
    expect(page).not_to have_content "moderator"
  end

  it "should not be able to change an admin's role" do
    log_in @cUser
    click_link "Tools"

    find(:xpath, "//a[@href='/users/tools/#{@cUser.id}']").click
    find("p", text: "admin", :match => :prefer_exact)
  end

  #### moderator ####
  it "should not give a moderator access" do
    log_in @bUser
    expect{visit "/users/tools"}.to raise_error (CanCan::AccessDenied)
  end

  #### author ####
  it "should not give an author access" do
    log_in @aUser
    expect{visit "/users/tools"}.to raise_error (CanCan::AccessDenied)
  end

  #### guest ####
  it "should redirect a guest to log in page" do
    visit '/users/tools'
    expect(page).to have_content "Log in"
    expect(page).to have_content "Email"
    expect(page).to have_content "Password"
    expect(page).to have_selector(:link_or_button, "Log in")
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
