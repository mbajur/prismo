module Components
  class BoxHeader < Base
    def view_template(&)
      div(class: "border-b px-4") do
        yield
      end
    end
  end
end
