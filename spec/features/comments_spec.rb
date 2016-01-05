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

  # it "should raise error if guest tries to access the urls for edit and destroy" do
  #   expect{visit "/comments/#{@nbComment.id}/edit"}.to raise_error ()
  #   expect{visit "/comments/#{@nbComment.id}"}.to raise_error ()
  # end

  #### author ####
  it "should let an author create a comment" do
    log_in @aUser
    visit '/'
    click_link "Propane and Propane Accessories"

    expect(page).to have_content "Hank Hill"
    within(".comments_section") do
      fill_in "comment_content", :with => ":)"
      click_button "Post Comment"
    end
    within(".comments_section") do
      expect(page).to have_content ":)"
    end
    within("#comment#{@bbComment.id + 1}") do
      expect(page).to have_content "Edit"
      expect(page).to have_xpath("//a[@href='/comments/#{@bbComment.id + 1}']")
    end
  end

  it "should let an author delete their own comment" do
    log_in @aUser
    click_link "Propane and Propane Accessories"

    within("#comment#{@bbComment.id}") do
      expect(page).not_to have_content "Edit"
      expect(page).not_to have_xpath("//a[@href='/comments/#{@bbComment.id}']")
    end

    within("#comment#{@bComment.id}") do
      expect(page).to have_content "Edit"
      expect(page).to have_xpath("//a[@href='/comments/#{@bComment.id}']")
    end
    find(:xpath, "//a[@href='/comments/#{@bComment.id}']").click
    expect(page).not_to have_content "Your ideas are intriguing to me and I wish to subscribe to your newsletter"
    within(".comments_section") do
      expect(page).not_to have_content "Edit"
      expect(page).not_to have_xpath("//a[@href='/comments/#{@bComment.id}']")
    end
  end

  it "should show do nothing and show flash message if comment is blank for author" do
    log_in @aUser
    click_link "Propane and Propane Accessories"

    within(".comments_section") do
      click_button "Post Comment"
    end
    within(".notice") do
      expect(page).to have_content "Comment can't be blank, silly"
    end
  end

  #### moderator ####
  it "should let a moderator create a comment" do
    log_in @bUser
    visit '/'
    click_link "Propane and Propane Accessories"

    expect(page).to have_content "Hank Hill"
    within(".comments_section") do
      fill_in "comment_content", :with => ":)"
      click_button "Post Comment"
    end
    within(".comments_section") do
      expect(page).to have_content ":)"
    end
  end

  it "should show do nothing and show flash message if comment is blank for moderator" do
    log_in @bUser
    click_link "Propane and Propane Accessories"

    within(".comments_section") do
      click_button "Post Comment"
    end
    within(".notice") do
      expect(page).to have_content "Comment can't be blank, silly"
    end
  end

  it "should let a moderator delete but not edit anyones comment" do
    log_in @bUser
    click_link "Propane and Propane Accessories"

    within("#comment#{@bComment.id}") do
      expect(page).not_to have_content "Edit"
      expect(page).to have_xpath("//a[@href='/comments/#{@bComment.id}']")
    end
    within("#comment#{@bbComment.id}") do
      expect(page).to have_content "Edit"
      expect(page).to have_xpath("//a[@href='/comments/#{@bbComment.id}']")
    end

    find(:xpath, "//a[@href='/comments/#{@bComment.id}']").click
    find(:xpath, "//a[@href='/comments/#{@bbComment.id}']").click
    within(".comments_section") do
      expect(page).not_to have_content "That can be arranged"
      expect(page).not_to have_content "Edit"
      expect(page).not_to have_xpath("//a[@href='/comments/#{@bbComment.id}']")

      expect(page).not_to have_content "Your ideas are intriguing to me and I wish to subscribe to your newsletter"
      expect(page).not_to have_xpath("//a[@href='/comments/#{@bbComment.id}']")
    end
  end

  #### admin ####
  it "should let an admin delete comments but not edit them" do
    log_in @cUser
    visit '/'
    click_link "Propane and Propane Accessories"

    expect(page).not_to have_xpath("//a[@href='/comments/#{@bComment.id}/edit']")
    expect(page).to have_xpath("//a[@href='/comments/#{@bComment.id}']")
    expect(page).not_to have_xpath("//a[@href='/comments/#{@bbComment.id}/edit']")
    expect(page).to have_xpath("//a[@href='/comments/#{@bbComment.id}']")

    find(:xpath, "//a[@href='/comments/#{@bbComment.id}']").click
    expect(page).not_to have_content "That can be arranged"   #No it can't
    expect(page).not_to have_xpath("//a[@href='/comments/#{@bbComment.id}/edit']")
    expect(page).not_to have_xpath("//a[@href='/comments/#{@bbComment.id}']")
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
