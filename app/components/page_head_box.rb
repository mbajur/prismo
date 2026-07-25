module Components
  class PageHeadBox < Base
    def view_template(&)
      div(class: "bg-white p-4 py-3 overflow-hidden rounded-b-sm") do
        yield if block_given?
      end
    end
  end
end
