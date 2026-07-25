module Views
  module Posts
    class Form < Views::Base
      include Phlex::Rails::Helpers::FormWith
      include Phlex::Rails::Helpers::T

      def initialize(post:)
        @post = post
      end

      def view_template(&)
        form_with model: @post, scope: :post, url: url, method: method, data: { controller: "post-form" } do |f|
          div(class: "flex flex-col gap-6 mb-6") do
            Alert(variant: :destructive) do
              AlertTitle { "Oopsie daisy!" }
              AlertDescription { f.object.errors.full_messages.to_sentence }
            end if f.object.errors.any?

            div(class: "flex gap-2") do
              f.label :url, class: "w-24 empty:hidden text-sm font-medium leading-9 peer-disabled:cursor-not-allowed peer-disabled:opacity-70 peer-aria-disabled:cursor-not-allowed peer-aria-disabled:opacity-70 peer-aria-disabled:pointer-events-none"

              div(class: "flex-1") do
                div(class: "flex gap-2") do
                  f.url_field :url, placeholder: "https://...",
                                    data: { post_form_target: "urlInput", action: "input->post-form#handleUrlChange" },
                                    readonly: @post.is_a?(::Posts::Update) && !policy(f.object).update_url?,
                                    class: "flex h-9 w-full rounded-md border bg-background px-3 py-1 text-sm shadow-xs transition-[color,box-shadow] border-border ring-0 ring-ring/0 placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50 file:border-0 file:bg-transparent file:text-sm file:font-medium aria-disabled:cursor-not-allowed aria-disabled:opacity-50 aria-disabled:pointer-events-none focus-visible:outline-none focus-visible:ring-ring/50 focus-visible:ring-2 focus-visible:border-ring focus-visible:shadow-sm"

                  Button(
                    class: "flex-1 text-nowrap cursor-pointer",
                    variant: :secondary,
                    data: {
                      action: "click->post-form#fetchTitle",
                      post_form_target: "fetchTitleBtn"
                    },
                    disabled: true
                  ) { t(".fetch_title") }
                end

                small(class: "text-muted-foreground") { t(".url_help") }
              end
            end

            div(class: "flex gap-2") do
              f.label :title, class: "w-24 empty:hidden text-sm font-medium leading-9 peer-disabled:cursor-not-allowed peer-disabled:opacity-70 peer-aria-disabled:cursor-not-allowed peer-aria-disabled:opacity-70 peer-aria-disabled:pointer-events-none"

              div(class: "flex-1") do
                f.text_field :title, data: { post_form_target: "titleInput" },
                                    required: false,
                                    readonly: @post.is_a?(::Posts::Update) && !policy(@post.post).update_title?,
                                    class: "flex h-9 w-full rounded-md border bg-background px-3 py-1 text-sm shadow-xs transition-[color,box-shadow] border-border ring-0 ring-ring/0 placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50 file:border-0 file:bg-transparent file:text-sm file:font-medium aria-disabled:cursor-not-allowed aria-disabled:opacity-50 aria-disabled:pointer-events-none focus-visible:outline-none focus-visible:ring-ring/50 focus-visible:ring-2 focus-visible:border-ring focus-visible:shadow-sm"
              end
            end

            div(class: "flex gap-2") do
              f.label :tag_list, class: "w-24 empty:hidden text-sm font-medium leading-9 peer-disabled:cursor-not-allowed peer-disabled:opacity-70 peer-aria-disabled:cursor-not-allowed peer-aria-disabled:opacity-70 peer-aria-disabled:pointer-events-none"

              div(class: "flex-1") do
                input(
                  data: { post_form_target: "tagsPhantomInput", max_tags: Setting.max_story_tags },
                  value: f.object.tag_list,
                  class: "flex h-9 w-full rounded-md border bg-background px-3 py-1 text-sm shadow-xs transition-[color,box-shadow] border-border ring-0 ring-ring/0 placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50 file:border-0 file:bg-transparent file:text-sm file:font-medium aria-disabled:cursor-not-allowed aria-disabled:opacity-50 aria-disabled:pointer-events-none focus-visible:outline-none focus-visible:ring-ring/50 focus-visible:ring-2 focus-visible:border-ring focus-visible:shadow-sm"
                )
                f.hidden_field :tag_list,
                                data: { post_form_target: "tagsInput" }
                small(class: "text-muted-foreground") { "Comma-separated list of tags" }
              end
            end

            div(class: "flex gap-2") do
              f.label :description, class: "w-24 empty:hidden text-sm font-medium leading-9 peer-disabled:cursor-not-allowed peer-disabled:opacity-70 peer-aria-disabled:cursor-not-allowed peer-aria-disabled:opacity-70 peer-aria-disabled:pointer-events-none"

              div(class: "flex-1") do
                f.marksmith :description
                small(class: "text-muted-foreground") { t(".description_help") }
              end
            end
          end

          div(class: "flex justify-center") do
            f.submit "Save post", class: "whitespace-nowrap inline-flex items-center justify-center rounded-md font-medium transition-colors disabled:pointer-events-none disabled:opacity-50 focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring aria-disabled:pointer-events-none aria-disabled:opacity-50 aria-disabled:cursor-not-allowed px-4 py-2 h-9 text-sm bg-primary text-primary-foreground shadow hover:bg-primary/90"
          end
        end
      end

      private

      def url
        @post.is_a?(::Posts::Update) ? post_path(@post.post) : posts_path
      end

      def method
        @post.is_a?(::Posts::Update) ? :put : :post
      end
    end
  end
end
