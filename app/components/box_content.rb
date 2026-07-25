module Components
  class BoxContent < Base
    def initialize(opts = {})
      @opts = opts
    end

    def view_template(&)
      div(class: "p-4 #{@opts[:class]}") do
        yield
      end
    end
  end
end
