# frozen_string_literal: true

entry.title(post.title)
entry.summary(post.decorate.excerpt)

entry.author do |author|
  decorated_author = post.fedipub_actor.decorate

  author.name(decorated_author)
  author.uri(decorated_author.profile_url)
end

post.tags.each do |tag|
  entry.category(term: tag.name, label: tag.name)
end
