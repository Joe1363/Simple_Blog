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
    @bComment = FactoryGirl.create(:comment)
    @bComment.article = @bArticle
    @bComment.save

    ## 1 admin
    @cUser = FactoryGirl.create(:admin)
  end

  #### guest ####
  it "should display article contents and comments only for guest" do
    visit "/"
    click_link "Propane and Propane Accessories"

    checkArticleContentsB()
    expect(page).not_to have_content "Edit"


    checkCommentContents()
    expect(page).not_to have_content "#comment_content"
    expect(page).not_to have_selector(:link_or_button, "Post Comment")
  end

  #### author ####
  it "should display article contents, edit link, comments, and comment form for author's article" do
    log_in @aUser

    visit "/"
    click_link "The Majestic Beauty Of The Roudhouse Kick"

    checkArticleContentsA()
    expect(page).to have_content "Edit"

    checkEmptyComments()
    within(".comments_section") do
      expect(page).to have_selector(:link_or_button, "Post Comment")
    end
  end

  it "should display article contents, comments, and comment form on another authors article" do
    log_in @aUser

    visit "/"
    click_link "Propane and Propane Accessories"

    checkArticleContentsB()
    expect(page).not_to have_content "Edit"

    checkCommentContents()
    within(".comments_section") do
      expect(page).to have_selector(:link_or_button, "Post Comment")
    end
  end

  #### moderator ####
  it "should display article contents, edit link, comments, and comment form on moderators article" do
    log_in @bUser

    visit "/"
    click_link "Propane and Propane Accessories"

    checkArticleContentsB()
    expect(page).to have_content "Edit"

    checkCommentContents()
    within(".comments_section") do
      expect(page).to have_selector(:link_or_button, "Post Comment")
    end
  end

  it "should display article contents, comments, and comment form fir moderator on another user's article" do
    log_in @bUser

    visit "/"
    click_link "The Majestic Beauty Of The Roudhouse Kick"

    checkArticleContentsA()
    expect(page).not_to have_content "Edit"

    checkEmptyComments()
    within(".comments_section") do
      expect(page).to have_selector(:link_or_button, "Post Comment")
    end
  end

  #### admin ####
  it "should be able to view all except edit link for admin" do
    log_in @cUser

    visit "/"
    click_link "The Majestic Beauty Of The Roudhouse Kick"

    checkArticleContentsA()
    expect(page).not_to have_content "Edit"

    checkEmptyComments()
    within(".comments_section") do
      expect(page).to have_selector(:link_or_button, "Post Comment")
    end
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

    def checkArticleContentsA
      expect(page).to have_content "The Majestic Beauty Of The Roudhouse Kick"
      expect(page).to have_content "By Chuck Norris"
      expect(page).to have_content "<<Back"
      expect(page).to have_content "Content"
    end

    def checkArticleContentsB
      expect(page).to have_content "Propane and Propane Accessories"
      expect(page).to have_content "By Hank Hill"
      expect(page).to have_content "<<Back"
      expect(page).to have_content "Content"
    end

    def checkEmptyComments
      expect(page).to have_content "Comments"
      within(".comments_section") do
        expect(page).to have_content "Be the first to comment on this article."
      end
    end

    def checkCommentContents
      expect(page).to have_content "Comments"
      within(".comments_section") do
        expect(page).to have_content "Chuck Norris"
        expect(page).to have_content "Your ideas are intriguing to me and I wish to subscribe to your newsletter"
      end
    end
end
