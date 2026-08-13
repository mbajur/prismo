FactoryBot.define do
  factory :fedipub_incoming_activity, class: 'Fedipub::IncomingActivity' do
    data { "https://example.com/activities/1" }
    status { :pending }
    entity_class { "Post" }
  end
end
