FactoryBot.define do
  factory :fedipub_mention, class: 'Fedipub::Mention' do
    entity factory: :comment
    actor factory: :fedipub_actor
  end
end
