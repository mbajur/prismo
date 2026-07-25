module Views
  module Settings
    module Preferences
      class Show < Base
        include Phlex::Rails::Helpers::FormWith
        include Phlex::Rails::Helpers::T
        include Phlex::Rails::Helpers::OptionsForSelect

        def initialize(settings:)
          @settings = settings
        end

        def view_template(&)
          render Views::Settings::Layout.new() do
            form_with model: @settings, url: settings_preferences_path, scope: :settings, builder: RubyUiFormBuilder do |f|
              render Components::Box.new() do
                render Components::BoxContent.new() do
                  div(class: "flex flex-col gap-4") do
                    FormField() do
                      f.label :theme
                      f.select(:theme) { options_for_select(User::Settings.themes.keys.map(&:to_s), f.object.theme.to_s) }
                    end
                  end
                end
              end

              f.submit t(:save_changes), class: "mt-4"
            end
          end
        end
      end
    end
  end
end
