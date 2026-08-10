module Views
  module Tags
    class HeadBox < Base
      include Phlex::Rails::Helpers::LinkTo

      def view_template(&)
        Components::PageHeadBox() do
          ul(class: "flex items-center gap-4 text-sm overflow-x-auto") do
            Gutentag::Tag.all.each do |tag|
              li(class: "text-nowrap") { link_to "##{tag.name}", tag_posts_path(tag.name) }
            end
          end
        end
      end
    end
  end
end
