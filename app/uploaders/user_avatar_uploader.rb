# frozen_string_literal: true

class UserAvatarUploader < Shrine
  plugin :derivatives, create_on_promote: true
  plugin :remote_url, max_size: 20*1024*1024

  Attacher.derivatives do |original|
    pipeline = ImageProcessing::Vips.source(original)
                                    .loader(page: 1)
                                    .convert("jpg")
                                    .saver(background: 255, quality: 100)

    {
      size_60:  pipeline.resize_to_fill!(60, 60),
      size_400: pipeline.resize_to_fill!(400, 400)
    }
  end
end
