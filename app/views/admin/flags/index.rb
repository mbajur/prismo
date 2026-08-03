module Views
  module Admin
    module Flags
      class Index < Base
        include Phlex::Rails::Helpers::T
        include Phlex::Rails::Helpers::LinkTo

        def initialize(flags:, pagy:)
          @flags = flags
          @pagy = pagy
        end

        def view_template
          render Views::Settings::Layout.new() do
            render Components::Box.new() do
              render Components::BoxContent.new() do
                Table do
                  TableHeader do
                    TableRow do
                      TableHead { t(".author") }
                      TableHead { t(".object") }
                      TableHead { t(".resolved") }
                      TableHead { t(".when") }
                      TableHead
                    end
                  end

                  TableBody do
                    @flags.each do |flag|
                      flag = flag.decorate
                      flaggable = flag.flaggable.decorate
                      actor = flag.actor.decorate

                      TableRow do
                        TableCell { link_to actor, actor.path }
                        TableCell do
                          link_to flaggable.to_flag_title.truncate(20), flag.flaggable.decorate.path
                        end
                        TableCell { flag.action_taken? ? t(".yes") : t(".no") }
                        TableCell { timeago(flag.created_at) }
                        TableCell do
                          link_to t(".more"), admin_flag_path(flag)
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
end
