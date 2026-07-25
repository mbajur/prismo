# frozen_string_literal: true

require 'shrine'
require 'shrine/storage/file_system'

Shrine.logger = Rails.logger
Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data
Shrine.plugin :restore_cached_data
Shrine.plugin :remove_attachment
Shrine.plugin :default_url
Shrine.plugin :determine_mime_type
Shrine.plugin :default_url_options, store: { public: true }
Shrine.plugin :delete_raw

public_store =
  if ENV['S3_ENABLED']
    require 'shrine/storage/s3'
    Shrine::Storage::S3.new(access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
                            secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
                            region: ENV.fetch('S3_REGION'),
                            bucket: ENV.fetch('S3_BUCKET'),
                            endpoint: ENV.fetch('S3_HOSTNAME'),
                            upload_options: { acl: 'public-read' })
  else
    Shrine::Storage::FileSystem.new('public', prefix: 'uploads/store')
  end

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'),
  store: public_store
}

Shrine::Attacher.default_url do |options|
  "/placeholders/#{name}.jpg"
end
