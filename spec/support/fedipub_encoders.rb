# Copy parsers into integration tests so `response.parsed_body` can decode
# Fedipub's custom mime types (this doesn't happen automatically). Mirrors
# what the fedipub gem does in its own spec/rails_helper.rb.
[ :xrd, :jrd, :activitypub, :nodeinfo ].each do |mime_type|
  ActionDispatch::IntegrationTest.register_encoder mime_type,
    response_parser: ActionDispatch::Request.parameter_parsers[mime_type]
end
