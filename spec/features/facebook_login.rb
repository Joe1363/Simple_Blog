require 'rails_helper'

describe "Omniauth Facebook login" do
  before(:each) do
    ## 1 article and 1 user(author)
    @aUser = FactoryGirl.create(:user)
    @aArticle = FactoryGirl.create(:article)
    @aArticle.user = @aUser
    @aUser.save
    @aArticle.save

    visit '/'
  end

  it 'should log a user in using facebook' do
    click_link 'Sign Up'
    click_link 'Log in with Facebook'

    expect(page).to have_content "Hello John!"
    expect(page).to have_content "The Majestic Beauty Of The Roudhouse Kick"
    expect(page).to have_content "Chuck Norris"
  end

  it 'should let a user share an article on facebook' do
    # click_link 'Sign Up'
    # click_link 'Log in with Facebook'
    #
    # click_link "The Majestic Beauty Of The Roudhouse Kick"
    # expect(page).to have_content "Share Article On Facebook"
    # click_link "Share on Facebook"
    # fill_in "fb_content", :with => "Link this page."
    # click_button "Share Article"
    #
    # expect(page).to have_content "Page shared on Facebook"

    # graph = Koala::Facebook::API.new('ABCDEFGH', ENV['FACEBOOK_SECRET'])
    # p graph.get_object('12345')
  end
end
