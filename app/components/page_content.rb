module Components
  class PageContent < Base
    def initialize
      @before_block = nil
    end

    def view_template(&)
      vanish(&)

      render Components::Box.new() do
        render @before_block if @before_block

        yield if block_given?
      end
    end

    def with_before(&block)
      @before_block = block
      nil
    end
  end
end
