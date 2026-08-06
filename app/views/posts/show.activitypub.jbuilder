if @post.fedipub_tombstoned?
  json.partial! "fedipub/server/published/tombstone", publishable: @post
else
  json.partial! "fedipub/server/published/publishable", publishable: @post
end
