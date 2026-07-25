module Components
  class Box < Base
    def view_template(&)
      div(class: "bg-white rounded-sm") do
        yield
      end
    end
  end
end
