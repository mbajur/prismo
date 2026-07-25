# frozen_string_literal: true

module Users
  class SuspendService
    # Suspend an account and remove as much of its data as possible
    #
    # @param [Account]
    # @param [Hash] options
    # @option [Boolean] :including_user Remove the user record as well
    # @option [Boolean] :destroy Remove the account record instead of suspending
    def call(user, **options)
      @user = user
      @options = options

      purge_profile!
      purge_content!
    end

    private

    attr_reader :user, :options

    def purge_profile!
      # If the account is going to be destroyed
      # there is no point wasting time updating
      # its values first
      return if options[:destroy]

      user.silenced         = false
      user.suspended        = true
      # user.locked           = false
      user.display_name     = ''
      user.bio              = ''
      user.posts_count      = 0
      user.comments_count   = 0
      user.followers_count  = 0
      user.following_count  = 0
      # user.comments_karma   = 0
      # user.posts_karma      = 0
      user.avatar           = nil
      user.save!
    end

    def purge_content!
      user.comments.each { |c| Comments::Delete.run!(comment: c) }
      user.stories.each  { |s| Stories::Delete.run!(story: s) }
      user.likes.destroy_all
      # user.notifications_as_recipient.destroy_all
      # user.follow_requests.destroy_all
      # user.active_follows.destroy_all
      # user.passive_follows.destroy_all

      # user.destroy if options[:destroy]
    end
  end
end
