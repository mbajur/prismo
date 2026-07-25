# frozen_string_literal: true

class Components::Base < Phlex::HTML
  include RubyUI
  # Include any helpers you want to be available across all components
  include Phlex::Rails::Helpers::Routes

  register_value_helper :policy
  register_value_helper :active_link_to
  register_value_helper :current_user
  register_value_helper :user_signed_in?

  if Rails.env.development?
    def before_template
      comment { "Before #{self.class.name}" }
      super
    end
  end
end
