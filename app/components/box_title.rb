module Components
  class BoxTitle < Base
    def view_template(&)
      div(class: "font-bold py-4") do
        yield
      end
    end
  end
end
