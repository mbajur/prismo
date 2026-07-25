# frozen_string_literal: true

class Comments::Delete < ActiveInteraction::Base
  object :comment, class: Comment

  def execute
    return false if comment.discarded?

    # @account = comment.account
    # is_local = comment.local?

    # comment.update(
    #   account: nil,
    #   content: nil,
    #   content_source: nil,
    #   uri: nil,
    #   url: nil,
    #   domain: nil,
    #   removed: true
    # )
    comment.discard!

    # distribute_delete_comment! if is_local

    comment
  end

  private

  attr_reader :account

  def distribute_delete_comment!
    delivery_inboxes.each do |inbox_url|
      ActivityPub::DeliveryJob.perform_later(
        signed_payload, account.id, inbox_url
      )
    end
  end

  def signed_payload
    @signed_payload ||= begin
      Oj.dump(
        ActivityPub::LinkedDataSignature.new(payload).sign!(account)
      )
    end
  end

  def payload
    ActivityPub::DeleteSerializer.new(comment, with_context: true).as_json
  end

  def delivery_inboxes
    Account.inboxes.reject(&:empty?)
  end
end
