# frozen_string_literal: true

atom_feed do |feed|
  feed.title(@feed_title)
  feed.updated(@posts[0].created_at) if @posts.any?
  feed.icon(root_url + "favicon.ico")
  feed.generator("△ Prismo", version: Fedipub.configuration.app_version)

  @posts.each do |post|
    feed.entry(post) do |entry|
      render("posts/post", post: post, entry: entry)
    end
  end
end
