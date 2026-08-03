module Views
  module Admin
    module Flags
      class Show < Base
        include Phlex::Rails::Helpers::T
        include Phlex::Rails::Helpers::LinkTo
        include Phlex::Rails::Helpers::ButtonTo
        include Phlex::Rails::Helpers::SimpleFormat

        def initialize(flag:)
          @flag = flag
        end

        def view_template
          render Views::Settings::Layout.new() do
            render Components::Box.new() do
              render Components::BoxContent.new() do
                Table() do
                  TableBody do
                    TableRow do
                      TableHead { t(".author") }
                      TableCell { link_to @flag.actor.decorate, @flag.actor.decorate.path }
                    end

                    TableRow do
                      TableHead { t(".object") }
                      TableCell { link_to @flag.flaggable.decorate.to_flag_title, @flag.flaggable.decorate.path }
                    end

                    TableRow do
                      TableHead { t(".sumary") }
                      TableCell { simple_format(@flag.summary) }
                    end

                    TableRow do
                      TableHead { t(".resolved") }
                      TableCell { @flag.action_taken? ? t(".yes") : t(".no") }
                    end

                    TableRow do
                      TableHead { t(".created_at") }
                      TableCell { @flag.created_at.to_s }
                    end
                  end
                end

                div(class: "flex gap-2 mt-4") do
                  if policy(@flag).resolve?
                    if @flag.action_taken?
                      button_to t(".unresolve"), unresolve_admin_flag_path(@flag.id), method: :post, class: "whitespace-nowrap inline-flex items-center justify-center rounded-md font-medium transition-colors disabled:pointer-events-none disabled:opacity-50 focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring aria-disabled:pointer-events-none aria-disabled:opacity-50 aria-disabled:cursor-not-allowed px-4 py-2 h-9 text-sm bg-primary text-primary-foreground shadow hover:bg-primary/90"
                    else
                      button_to t(".resolve"), resolve_admin_flag_path(@flag.id), method: :post, class: "whitespace-nowrap inline-flex items-center justify-center rounded-md font-medium transition-colors disabled:pointer-events-none disabled:opacity-50 focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring aria-disabled:pointer-events-none aria-disabled:opacity-50 aria-disabled:cursor-not-allowed px-4 py-2 h-9 text-sm bg-primary text-primary-foreground shadow hover:bg-primary/90"
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
