module Components
  class Page < Base
    def initialize(opts = {})
      @opts = opts
    end

    def view_template(&)
      render Components::Nav.new()

      div(class: "container mx-auto max-w-4xl #{'mt-4' if @opts[:content_shifted]}") do
        div(class: "flex flex-col gap-4") do
          yield if block_given?
        end
      end
    end
  end
end
