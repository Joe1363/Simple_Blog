FactoryGirl.define do
  factory :user do
    first_name "Chuck"
    last_name "Norris"
    sequence(:email) { |n| "cn#{n}@example.com" }
    password "password"

    factory :moderator do
      first_name "Hank"
      last_name "Hill"
      sequence(:email) { |n| "hh#{n}@example.com" }
      role "moderator"
    end

    factory :admin do
      first_name "admin"
      last_name "admin"
      sequence(:email) { |n| "admin#{n}@example.com" }
      role "admin"
    end
  end

  factory :article do
    title "The Majestic Beauty Of The Roudhouse Kick"
    content "Content"
    author "Chuck Norris"
  end

  factory :comment do
    content "Your ideas are intriguing to me and I wish to subscribe to your newsletter"
    author "Homer Simpson"
  end
end
