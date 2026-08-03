module Views
  module Admin
    module Users
      class Index < Base
        include Phlex::Rails::Helpers::T
        include Phlex::Rails::Helpers::LinkTo

        def initialize(users:, pagy:)
          @users = users
          @pagy = pagy
        end

        def view_template
          render Views::Settings::Layout.new() do
            render Components::Box.new() do
              render Components::BoxContent.new() do
                Table do
                  TableHeader do
                    TableRow do
                      TableHead { t(".username") }
                      TableHead { t(".domain") }
                      TableHead { }
                    end
                  end

                  TableBody do
                    @users.each do |user|
                      TableRow do
                        TableCell(class: "font-medium") do
                          if user.suspended?
                            span(class: "strike text-red-500") { user.username }
                          elsif user.silenced?
                            span(class: "strike") { user.username }
                          else
                            user.username
                          end
                        end
                        TableCell { "-" }
                        TableCell(class: "text-right") { link_to t(".edit"), admin_user_path(user.id) }
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
  end
end
