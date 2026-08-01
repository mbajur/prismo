RorVsWild.start(api_key: ENV["RORVSWILD_API_KEY"]) if Rails.env.production? && ENV["RORVSWILD_API_KEY"].present?
