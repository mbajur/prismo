module Views
  module Settings
    module Profiles
      class Show < Base
        include Phlex::Rails::Helpers::T
        include Phlex::Rails::Helpers::FormWith
        include Phlex::Rails::Helpers::ImageTag

        def initialize(user:)
          @user = user
        end

        def view_template(&)
          render Views::Settings::Layout.new() do
            form_with model: @user, url: settings_profile_path, builder: RubyUiFormBuilder do |f|
              render Components::Box.new() do
                render Components::BoxContent.new() do
                  div(class: "flex flex-col gap-4") do
                    FormField() do
                      f.label :display_name
                      f.text_field :display_name
                    end

                    FormField() do
                      f.label :bio
                      f.text_area :bio
                    end

                    div(class: "grid grid-cols-2 gap-4") do
                      div(class: "col-span-1") do
                        FormField() do
                          f.label :avatar
                          f.file_field :avatar
                        end
                      end

                      div(class: "col-span-1") do
                        if @user.avatar_data
                          FormField() do
                            image_tag @user.avatar_url(:size_400), size: '100x100', class: "rounded-full"

                            div(class: "flex items-center space-x-3") do
                              f.check_box :remove_avatar
                              f.label :remove_avatar, class: "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
                            end
                          end
                        end
                      end
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
