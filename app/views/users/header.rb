module Views
  module Users
    class Header < Base
      include Phlex::Rails::Helpers::ImageTag
      include Phlex::Rails::Helpers::LinkTo
      include Phlex::Rails::Helpers::T

      def initialize(user:)
        @user = user
      end

      def view_template(&)
        render Components::Box.new() do
          render Components::BoxContent.new() do
            div(class: "grid grid-cols-12 gap-8") do
              div(class: "col-span-4") do
                div(class: "flex items-center gap-4 mb-4") do
                  div do
                    image_tag @user.avatar_url, class: "h-12 w-12 rounded-full", alt: @user.username
                  end

                  div do
                    h1(class: "text-2xl font-semibold") { @user.display_name }
                    link_to(@user, @user.path, class: "text-muted-foreground")
                  end
                end

                div do
                  if @user == helpers.current_user
                    Link(href: settings_profile_path, variant: :secondary, size: :sm, class: "w-full") do
                      t(".edit_your_profile")
                    end
                  else
                    render Views::Users::FollowBtn.new(user: @user)
                  end
                end
              end

              div(class: "col-span-8") do
                ul(class: "flex gap-8 mt-2") do
                  li do
                    span(class: "text-lg/4 block font-semibold") { @user.posts_karma + @user.comments_karma }
                    span(class: "uppercase text-xs text-muted-foreground") { t(".karma") }
                  end

                  li do
                    span(class: "text-lg/4 block font-semibold") { @user.fedipub_actor.followers.count }
                    span(class: "uppercase text-xs text-muted-foreground") { t(".followers") }
                  end

                  li do
                    span(class: "text-lg/4 block font-semibold") { @user.fedipub_actor.follows.count }
                    span(class: "uppercase text-xs text-muted-foreground") { t(".following") }
                  end
                end

                if @user.bio.present?
                  hr(class: "my-4")
                  div(class: "text-sm text-muted-foreground") { @user.bio_html }
                end
              end
            end
          end
        end

        render Components::Box.new() do
          render Components::BoxNavBig.new() do |nav|
            nav.item(user_posts_path(@user), active: [ [ "users/posts" ] ]) { t(".posts") }
            nav.item(user_comments_path(@user)) { t(".comments") }
          end
        end
      end
    end
  end
end
