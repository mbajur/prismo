source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.1.3"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use sqlite3 as the database for Active Record
gem "sqlite3", ">= 2.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

group :development, :test do
  gem "dotenv"

  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Audits gems for known security defects (use config/bundler-audit.yml to ignore issues)
  gem "bundler-audit", require: false

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  gem "httplog", require: "httplog"
end

gem "devise", "~> 5.0"

gem "pagy", "~> 43.6"

gem "ruby_ui", "~> 1.4", group: :development, require: false

gem "phlex-rails", "~> 2.4"

gem "tailwind_merge", "~> 1.5"

gem "tailwindcss-rails", "~> 4.4"

gem "gutentag", "~> 3.0"

gem "closure_tree", "~> 9.7"

gem "active_link_to", "~> 1.0"

gem "active_interaction", "~> 5.5"

gem "discard", "~> 2.0"

gem "draper", "~> 4.0"

gem "meta-tags", "~> 2.23"

gem "search_cop", "~> 1.5"

gem "rails-settings-cached"

gem "validate_url", "~> 1.0"

gem "pundit", "~> 2.5"

gem "marksmith", "~> 0.5.2"

gem "commonmarker", "~> 2.9"

gem "link_thumbnailer", "~> 3.4"

gem "rinku", "~> 2.0"

gem "redcarpet", "~> 3.6"

gem "shrine", "~> 3.6"

gem "store_model", "~> 4.6"

gem "fedipub", git: "https://gitlab.com/fedipub/fedipub.git", branch: "main"
