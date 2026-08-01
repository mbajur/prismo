class User < ApplicationRecord
  class Settings
    include StoreModel::Model

    enum :theme, %i[default dark], default: :default
  end

  USERNAME_RE = /[a-z0-9_]+([a-z0-9_\.]+[a-z0-9_]+)?/i
  MENTION_RE  = %r{(?<=^|[^/[:word:]])@((#{USERNAME_RE})(?:@[a-z0-9\.\-]+[a-z0-9]+)?)}i

  include Fedipub::ActorEntity
  include UserAvatarUploader[:avatar]

  has_many :likes, dependent: :destroy
  has_many :active_follows, class_name: "Follow", as: :follower, dependent: :destroy
  has_many :passive_follows, class_name: "Follow", as: :following, dependent: :destroy
  has_many :followers, -> { order("follows.id desc") }, through: :passive_follows, source_type: "User"
  has_many :following, -> { order("follows.id desc") }, through: :active_follows, source_type: "User"

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable

  attribute :settings, User::Settings.to_type

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :username, format: { with: /\A#{USERNAME_RE}\z/i, message: "can only contain letters, numbers, underscores and periods" }

  acts_as_fedipub_actor username_field: :username,
                        name_field: :display_name,
                        profile_url_method: :user_url

  def to_activitypub_object
    data = { summary: decorate.bio_html }

    if avatar_data.present?
      data["image"] = {
        type: "Image",
        "url" => avatar_url(host: "https://#{ENV['HOST']}"),
        "mediaType" => avatar.mime_type
      }
    end

    data
  end

  def to_param
    username
  end

  def follow!(other_account, uri: nil)
    active_follows.create_with(uri: uri)
                  .find_or_create_by!(following: other_account)
  end

  def unfollow!(other_account)
    follow = active_follows.find_by(following: other_account)
    follow&.destroy
  end

  # def requested_follow?(other_account)
  #   follow_requests.where(following: other_account).exists?
  # end

  # def remote?
  #   !local?
  # end

  # def acct
  #   local? ? username : "#{username}@#{domain}"
  # end

  # def local_username_and_domain
  #   "#{username}@#{Rails.configuration.x.local_domain}"
  # end

  # def to_webfinger_s
  #   "acct:#{local_username_and_domain}"
  # end

  # def subscribed?
  #   subscription_expires_at.present?
  # end

  # def possibly_stale?
  #   last_webfingered_at.nil? || last_webfingered_at <= 1.day.ago
  # end

  # def refresh!
  #   return self if local?
  #   ResolveAccountService.new.call(acct)
  # end

  # def keypair
  #   @keypair ||= OpenSSL::PKey::RSA.new(private_key || public_key)
  # end

  # def magic_key
  #   modulus, exponent = [ keypair.public_key.n, keypair.public_key.e ].map do |component|
  #     result = []

  #     until component.zero?
  #       result << [ component % 256 ].pack("C")
  #       component >>= 8
  #     end

  #     result.reverse.join
  #   end

  #   ([ "RSA" ] + [ modulus, exponent ].map { |n| Base64.urlsafe_encode64(n) }).join(".")
  # end

  # Following

  def follow!(other_user)
    active_follows.find_or_create_by!(following: other_user)
  end

  def unfollow!(other_user)
    follow = active_follows.find_by(following: other_user)
    follow&.destroy
  end

  def following?(other_user)
    active_follows.where(following: other_user).exists?
  end
end
