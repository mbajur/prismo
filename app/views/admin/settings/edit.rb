module Views
  module Admin
    module Settings
      class Edit < Views::Base
        include Phlex::Rails::Helpers::FormWith
        include Phlex::Rails::Helpers::T

        def initialize(admin_settings:)
          @admin_settings = admin_settings
        end

        def view_template
          render Views::Settings::Layout.new() do
            form_with model: @admin_settings, url: admin_settings_path, method: :put, builder: RubyUiFormBuilder do |f|
              div(class: "flex flex-col gap-4") do
                render Components::Box.new() do
                  render Components::BoxContent.new() do
                    div(class: "flex flex-col gap-4") do
                      FormField() do
                        f.label :site_title
                        f.text_field :site_title
                      end

                      FormField() do
                        f.label :site_description
                        f.text_area :site_description
                      end
                    end
                  end
                end

                render Components::Box.new() do
                  render Components::BoxContent.new() do
                    div(class: "flex flex-col gap-4") do
                      FormField() do
                        div(class: "flex items-center space-x-3") do
                          f.check_box :open_registrations
                          f.label :open_registrations
                        end
                      end

                      FormField() do
                        f.label :closed_registrations_message
                        f.text_area :closed_registrations_message
                      end

                      FormField() do
                        div(class: "flex items-center space-x-3") do
                          f.check_box :webmentions_enabled
                          f.label :webmentions_enabled
                        end
                      end
                    end
                  end
                end

                render Components::Box.new() do
                  render Components::BoxContent.new() do
                    div(class: "flex flex-col gap-4") do
                      FormField() do
                        f.label :posts_per_day
                        f.number_field :posts_per_day
                      end

                      FormField() do
                        f.label :post_likes_per_day
                        f.number_field :post_likes_per_day
                      end

                      FormField() do
                        f.label :comment_likes_per_day
                        f.number_field :comment_likes_per_day
                      end

                      FormField() do
                        f.label :post_title_update_time_limit
                        f.number_field :post_title_update_time_limit
                      end

                      FormField() do
                        f.label :edit_counter_grace_period_minutes
                        f.number_field :edit_counter_grace_period_minutes
                      end
                    end
                  end
                end

                f.submit t(:save_changes)
              end
            end
          end
        end
      end
    end
  end
end
