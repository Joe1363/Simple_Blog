require 'rails_helper'

describe User, type: :model do
 it "should accept a first name, last name, role (default), password, and password confirmation" do
   aUser = FactoryGirl.create(:user, email: "cn9999@example.com")

   expect(aUser.first_name).to eq "Chuck"
   expect(aUser.last_name).to eq "Norris"
   expect(aUser.email).to eq "cn9999@example.com"
   expect(aUser.role).to eq "author"
   expect(aUser.password).to eq "password"
   expect(aUser.encrypted_password).to eq "password"
 end
end
