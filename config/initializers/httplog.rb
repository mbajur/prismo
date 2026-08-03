if Rails.env.development?
  HttpLog.configure do |config|
    # Enable or disable all logging
    config.enabled = true

    # config.log_headers = true

    # Log everything to log/http.log
    # config.logger = Logger.new(Rails.root.join("log", "http.log"))
  end
end
