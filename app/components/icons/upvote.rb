module Components
  module Icons
    class Upvote < Phlex::SVG
      def initialize(opts = {})
        @opts = opts
      end

      def view_template
        svg(
          viewBox: "0 0 16 16",
          version: "1.1",
          xmlns: "http://www.w3.org/2000/svg",
          xmlns_xlink: "http://www.w3.org/1999/xlink",
          class: @opts[:class]
        ) do
          rect(
            id: "icon-bound",
            fill: "none"
          )

          polygon(
            points: "8,5 13,10 3,10",
            fill: "currentColor"
          )
        end
      end
    end
  end
end
