module Views
  module Posts
    class New < Views::Base
      include Phlex::Rails::Helpers::T

      def initialize(post:)
        @post = post
      end

      def view_template(&)
        render Components::Page.new(content_shifted: true) do
          div(class: "grid grid-cols-12 gap-4") do
            div(class: "col-span-8") do
              render Components::Box.new() do
                render Components::BoxContent.new() do
                  h1(class: "text-lg font-medium mb-2") { t(".title") }
                  p { t(".submit_text") }

                  hr(class: "my-6")

                  render Views::Posts::Form.new(post: @post)
                end
              end
            end

            div(class: "col-span-4") do
              render Views::Posts::Guidelines.new()
            end
          end
        end
      end
    end
  end
end
