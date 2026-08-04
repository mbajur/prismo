# frozen_string_literal: true

require 'rails_helper'

describe Posts::SendWebmentionJob do
  subject { described_class.perform_now(post) }

  let(:post) { create(:post, :link) }
  let(:decorated_post) { post.decorate }

  before do
    allow(Rails.logger).to receive(:info)
    allow(Rails.logger).to receive(:warn)
  end

  context "when webmentions are enabled" do
    before { allow(Webmention).to receive(:send_webmention).and_return(response) }

    around do |example|
      original_value = Setting.webmentions_enabled
      Setting.webmentions_enabled = true
      example.run
      Setting.webmentions_enabled = original_value
    end

    context "when webmention is sent successfully" do
      let(:response) { instance_double("Webmention::Response", ok?: true) }

      it "logs a success message" do
        expect(Rails.logger).to receive(:info).with("Webmention sent from #{decorated_post.local_url} to #{decorated_post.url}")
        subject
      end

      it "updates the post's webmentioned attribute to true" do
        expect { subject }.to change { post.reload.webmentioned }.from(false).to(true)
      end
    end

    context "when webmention fails to send" do
      let(:response) { instance_double("Webmention::ErrorResponse", ok?: false, message: "Error message") }

      it "logs a warning message" do
        expect(Rails.logger).to receive(:warn).with("Failed to send webmention: Error message")
        subject
      end
    end
  end

  context "when webmentions are disabled" do
    around do |example|
      original_value = Setting.webmentions_enabled
      Setting.webmentions_enabled = false
      example.run
      Setting.webmentions_enabled = original_value
    end

    it "does not attempt to send a webmention" do
      expect(Webmention).not_to receive(:send_webmention)
      subject
    end
  end
end
