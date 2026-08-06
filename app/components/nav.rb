module Components
  class Nav < Base
    include Phlex::Rails::Helpers::FormWith
    include Phlex::Rails::Helpers::ImageTag

    def view_template(&)
      nav(class: "bg-primary") do
        div(class: "container mx-auto max-w-4xl flex items-center justify-between lg:justify-start gap-8 p-4 py-3 text-white") do
          SidebarTrigger(class: "lg:hidden")

          a(href: root_path, class: "text-lg font-medium") { Setting.site_title }

          div(class: "hidden items-center gap-4 hidden lg:flex") do
            raw helpers.active_link_to "Posts", root_path, active: [ [ "posts" ] ], class: "text-sm font-medium hover:text-white", class_active: "text-white", class_inactive: "text-white/60"
            raw helpers.active_link_to "Comments", comments_path, active: [ [ "comments" ] ], class: "text-sm font-medium hover:text-white", class_active: "text-white", class_inactive: "text-white/60"
          end

          form_with url: search_posts_path, method: :get, class: "ml-auto hidden lg:block" do
            input(type: "text", name: "q", placeholder: "Search...", value: helpers.params[:q], class: "text-primary rounded-full border border-teal-500 px-3 py-2 text-sm bg-white focus:border-teal-400 focus:ring focus:ring-teal-400 focus:ring-opacity-50")
          end

          div(class: "flex items-center gap-4") do
            a(href: new_post_path, class: "text-sm font-medium text-white/60 hover:text-white") { "+ Add" }

            if user_signed_in?
              DropdownMenu(options: { placement: "bottom-end" }, class: "hidden lg:block") do
                DropdownMenuTrigger(class: "flex items-center") do
                  image_tag current_user.avatar_url, class: "h-8 w-8 rounded-full"
                end
                render Components::NavUserDropdownContent.new()
              end
            else
              a(href: new_user_session_path, class: "text-sm font-medium text-white/60 hover:text-white") { "Login" }
            end
          end
        end
      end
    end
  end
end
