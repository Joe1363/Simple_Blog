FactoryGirl.define do
  factory :user do
    first_name "Chuck"
    last_name "Norris"
    sequence(:email) { |n| "cn#{n}@example.com" }
    password "password"
    encrypted_password "password"
  end

  factory :article do
    user
    title "The Majestic Beauty Of The Roudhouse Kick"
    content "Content"
    author "Chuck Norris"
  end

  factory :comment do
    article
    content "Your ideas are intriguing to me and I wish to subscribe to your newsletter"
    author "Homer Simpson"
  end
end
