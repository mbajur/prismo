FactoryBot.define do
  factory :fedipub_incoming_activity, class: 'Fedipub::IncomingActivity' do
    data { "MyText" }
    status { "MyString" }
    entity_class { "MyString" }
  end
end
