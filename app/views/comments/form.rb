module Views
  module Comments
    class Form < Views::Base
      include Phlex::Rails::Helpers::FormWith
      include Phlex::Rails::Helpers::T

      def initialize(comment:)
        @comment = comment
        @post = comment.post
        @parent = comment.parent
      end

      def view_template(&)
        form_with(model: form_model) do |form|
          div(class: "flex flex-col gap-2") do
            form.text_area(:body, class: "flex w-full rounded-sm border bg-background px-3 py-2 text-sm shadow-sm transition-colors border-border placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50 file:border-0 file:bg-transparent file:text-sm file:font-medium focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring aria-disabled:cursor-not-allowed aria-disabled:opacity-50 aria-disabled:pointer-events-none", rows: 4, autofocus: true, placeholder: placeholder, disabled: disabled?)
          end

          div(class: "flex mt-2") do
            Button(type: "submit", size: :sm, variant: :secondary, disabled: disabled?) { submit_text }
            Link(href: post_path(@comment.post), size: :sm) { "Cancel" } if user_signed_in?
          end
        end
      end

      private

      def submit_text
        @comment.persisted? ? t("helpers.submit.comment.update") : t("helpers.submit.comment.create")
      end

      def placeholder
        user_signed_in? ? "Write a comment..." : "Sign in to write a comment"
      end

      def disabled?
        !user_signed_in?
      end

      def form_model
        if @comment.persisted?
          @comment
        else
          if @parent
            [ @post, @parent, @comment ]
          else
            [ @post, @comment ]
          end
        end
      end
    end
  end
end
