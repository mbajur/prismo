# frozen_string_literal: true

# group = Group.create!(
#   name: 'General',
#   supergroup: true
# )

# account = Account.create!(
#   username: 'admin',
#   display_name: 'Site Admin'
# )

# User.create!(
#   account: account,
#   email: 'admin@example.com',
#   password: 'TestPass',
#   is_admin: true,
#   confirmed_at: Time.zone.now
# )

user = User.first

stories = [
  {
    # account: account,
    user: user,
    title: 'Szokujące słowa minister: Facebook nie zapłacił w Polsce ani grosza podatku',
    url: 'http://m.superbiz.se.pl/wiadomosci-biz/szokujace-slowa-minister-facebook-nie-zaplacil-w-polsce-ani-gorsza-podatku_1055497.html',
    url_domain: 'm.suberbiz.se.pl',
    likes_count: 14,
    tag_names: [ 'seo', 'security' ]
    # group: group

  }, {
    # account: account,
    user: user,
    title: 'GDPR Hall of Shame',
    url: 'http://gdprhallofshame.com/',
    url_domain: 'gdprhallofshame.com',
    likes_count: 51,
    tag_names: [ 'security' ]
    # group: group
  }, {
    # account: account,
    user: user,
    title: 'Pony 0.22.0 Released',
    url: 'https://www.ponylang.org/blog/2018/05/0.22.0-released/',
    url_domain: 'www.ponylang.org',
    likes_count: 6,
    tag_names: [ 'release' ]
    # group: group
  }, {
    # account: account,
    user: user,
    title: 'WireGuard is available for OpenBSD',
    url: 'https://marc.info/?l=openbsd-ports&m=152712417729497&w=2',
    url_domain: 'marc.info',
    likes_count: 31,
    tag_names: [ 'networking', 'openbsd', 'security' ]
    # group: group
  }
]

Post.create!(stories)

post = Post.first

comment1 = post.comments.create! user: user, body: 'Sample comment 1'
comment1_1 = post.comments.create! parent: comment1, user: user, body: 'Sample comment 1-1'
comment1_2 = post.comments.create! parent: comment1, user: user, body: 'Sample comment 1-2'

comment2 = post.comments.create! user: user, body: 'Sample comment 2'
comment2_1 = post.comments.create! parent: comment2, user: user, body: 'Sample comment 2-1'
comment2_2 = post.comments.create! parent: comment2, user: user, body: 'Sample comment 2-2'
comment2_2_1 = post.comments.create! parent: comment2, user: user, body: 'Sample comment 2-2-1'

Comment.all.find_each do |comment|
  comment.cache_depth
  comment.cache_body
  # comment.cache_root
end
