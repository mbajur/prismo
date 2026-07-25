class Follow < ApplicationRecord
  belongs_to :follower, polymorphic: true,
                        counter_cache: :following_count

  belongs_to :following, polymorphic: true,
                         counter_cache: :followers_count
end
