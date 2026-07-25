module Components
  class PageSidenavSection < Base
    def initialize
      @links = []
      @header_block = nil
    end

    def view_template(&)
      vanish(&)

      div do
        h6(class: "text-muted-foreground uppercase text-xs mb-2", &@header_block) if @header_block

        ul(class: "text-sm") do
          @links.each do |link|
            li { link }
          end
        end
      end
    end

    def with_header(&block)
      @header_block = block
      nil
    end

    def item(href, opts = {}, &block)
      @links << active_link_to(
        href, class: "group flex w-full items-center rounded-md border border-transparent px-2 py-0.5 transition-colors text-foreground hover:bg-muted-foreground/10",
              class_active: "font-bold",
              **opts, &block)
    end
  end
end
