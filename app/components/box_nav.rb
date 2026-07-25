module Components
  class BoxNav < Base
    def initialize
      @links = []
    end

    def view_template(&)
      vanish(&)
      ul(class: "text-sm gap-2 flex -mb-px") do
        @links.each do |link|
          li { link }
        end
      end
    end

    def item(href, opts = {}, &)
      @links << helpers.active_link_to(href, class: "border-b-2 px-2 py-2 block", class_active: "border-black", class_inactive: "border-transparent text-muted-foreground", **opts, &)
    end
  end
end
