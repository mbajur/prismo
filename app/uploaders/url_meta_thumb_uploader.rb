# frozen_string_literal: true

class UrlMetaThumbUploader < Shrine
  plugin :processing
  plugin :derivatives, create_on_promote: true
  plugin :remote_url, max_size: 20*1024*1024

  process(:cache) do |io, _|
    pipeline = ImageProcessing::Vips.source(io)
                                    .loader(page: 1)
                                    .convert('jpg')
                                    .saver(background: 255, quality: 100)

    pipeline.resize_to_limit!(400, 400)
  end

  Attacher.derivatives do |original|
    pipeline = ImageProcessing::Vips.source(original)
                                    .saver(quality: 80)

    { size_200: pipeline.resize_to_fill!(200, 200, crop: :attention) }
  end
end
