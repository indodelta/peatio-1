# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :credit do
    balance "9.99"
    currency "MyString"
    member_id 1
  end
end
