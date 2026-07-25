module Views
  module Comments
    class List < Base
      def initialize(comments:)
        @comments = comments
      end

      def view_template(&)
        div(class: "flex flex-col gap-2") do
          @comments.each do |comment|
            render Views::Comments::Item.new(comment: comment)
          end
        end
      end
    end
  end
end
