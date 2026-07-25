module Views
  module Admin
    module Users
      class Show < Base
        include Phlex::Rails::Helpers::T
        include Phlex::Rails::Helpers::LinkTo
        include Phlex::Rails::Helpers::ButtonTo

        def initialize(user:)
          @user = user
        end

        def view_template
          render Views::Settings::Layout.new() do
            render Components::Box.new() do
              render Components::BoxContent.new() do
                h1 { @user.username }

                if @user.suspended?
                  Badge(variant: :red) { t('.suspended') }
                elsif @user.silenced?
                  Badge(variant: :yellow) { t('.silenced') }
                end

                Table(class: "mt-4") do
                  TableBody do
                    TableRow do
                      TableHead { t('.username') }
                      TableCell { @user.username }
                    end

                    TableRow do
                      TableHead { t('.domain') }
                      TableCell { "-" }
                    end

                    TableRow do
                      TableHead { t('.display_name') }
                      TableCell { @user.display_name }
                    end

                    TableRow do
                      TableHead { t('.permissions') }
                      TableCell do
                        @user.admin? ? t('.admin') : t('.user')
                      end
                    end

                    TableRow do
                      TableHead { t('.e_mail') }
                      TableCell { @user.email }
                    end

                    TableRow do
                      TableHead { t('.last_ip') }
                      TableCell do
                        # @user.current_sign_in_ip || "-"
                        '-'
                      end
                    end

                    TableRow do
                      TableHead { t('.last_activity') }
                      TableCell do
                        @user.last_active_at ? l(@user.last_active_at) : "-"
                      end
                    end

                    TableRow do
                      TableHead { t('.followers') }
                      TableCell { @user.followers_count }
                    end

                    TableRow do
                      TableHead { t('.following') }
                      TableCell { @user.following_count }
                    end

                    TableRow do
                      TableHead { t('.posts') }
                      TableCell { @user.posts_count }
                    end

                    TableRow do
                      TableHead { t('.comments') }
                      TableCell { @user.comments_count }
                    end
                  end
                end

                div(class: "flex gap-2 mt-4") do
                  if policy(@user).silence?
                    if @user.silenced?
                      button_to t('.unsilence'), unsilence_admin_user_path(@user.id), method: :post, class: "whitespace-nowrap inline-flex items-center justify-center rounded-md font-medium transition-colors disabled:pointer-events-none disabled:opacity-50 focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring aria-disabled:pointer-events-none aria-disabled:opacity-50 aria-disabled:cursor-not-allowed px-4 py-2 h-9 text-sm bg-primary text-primary-foreground shadow hover:bg-primary/90"
                    else
                      button_to t('.silence'), silence_admin_user_path(@user.id), method: :post, class: "whitespace-nowrap inline-flex items-center justify-center rounded-md font-medium transition-colors disabled:pointer-events-none disabled:opacity-50 focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring aria-disabled:pointer-events-none aria-disabled:opacity-50 aria-disabled:cursor-not-allowed px-4 py-2 h-9 text-sm bg-primary text-primary-foreground shadow hover:bg-primary/90"
                    end
                  end

                  if policy(@user).suspend?
                    button_to t('.suspend'), suspend_admin_user_path(@user.id), method: :post, class: "whitespace-nowrap inline-flex items-center justify-center rounded-md font-medium transition-colors disabled:pointer-events-none disabled:opacity-50 focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring aria-disabled:pointer-events-none aria-disabled:opacity-50 aria-disabled:cursor-not-allowed px-4 py-2 h-9 text-sm bg-primary text-primary-foreground shadow hover:bg-primary/90"
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
