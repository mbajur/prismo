module Views
  module Users
    class FollowBtn < Base
      include Phlex::Rails::Helpers::ButtonTo
      include Phlex::Rails::Helpers::T

      def initialize(user:)
        @user = user
      end

      def view_template(&)
        if current_user&.following?(@user)
          button_to(unfollow_user_path(@user), method: :post, class: "w-full whitespace-nowrap inline-flex items-center justify-center rounded-md font-medium transition-colors disabled:pointer-events-none disabled:opacity-50 focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring aria-disabled:pointer-events-none aria-disabled:opacity-50 aria-disabled:cursor-not-allowed px-4 py-2 h-9 text-sm bg-primary text-primary-foreground shadow hover:bg-primary/90") do
            t(".unfollow")
          end
        else
          button_to(follow_user_path(@user), method: :post, class: "w-full whitespace-nowrap inline-flex items-center justify-center rounded-md font-medium transition-colors disabled:pointer-events-none disabled:opacity-50 focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring aria-disabled:pointer-events-none aria-disabled:opacity-50 aria-disabled:cursor-not-allowed px-4 py-2 h-9 text-sm bg-primary text-primary-foreground shadow hover:bg-primary/90") do
            t(".follow")
          end
        end
      end
    end
  end
end
