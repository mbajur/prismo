module Views
  module Posts
    class List < Views::Base
      def initialize(posts:, pagy:)
        @posts = posts
        @pagy = pagy
      end

      def view_template(&)
        div(class: "flex flex-col divide-y divide-gray-200 gap-y-4") do
          @posts.each do |post|
            render Views::Posts::Item.new(post: post)
          end
        end
      end
    end
  end
end
