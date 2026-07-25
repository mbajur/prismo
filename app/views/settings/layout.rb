module Views
  module Settings
    class Layout < Base
      include Phlex::Rails::Helpers::T

      def view_template(&)
        render Components::Page.new() do
          div(class: "grid grid-cols-12 gap-8") do
            div(class: "col-span-3") do
              div(class: "flex flex-col gap-4") do
                render Components::PageSidenavSection.new() do |nav|
                  nav.with_header { t('.settings') }
                  nav.item(settings_profile_path) { t('.edit_profile') }
                  nav.item(settings_preferences_path) { t('.preferences') }
                end

                if current_user.admin?
                  render Components::PageSidenavSection.new() do |nav|
                    nav.with_header { t('.administration') }
                    nav.item(edit_admin_settings_path) { t('.site_settings') }
                    nav.item(admin_users_path) { t('.users') }
                    nav.item(admin_flags_path) { t('.flags') }
                    # nav.item(admin_domain_blocks_path) { t('.blocked_domains') }
                  end
                end
              end
            end

            div(class: "col-span-9") do
              yield
            end
          end
        end
      end
    end
  end
end
