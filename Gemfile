source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "4.2.9"
gem "pg", "0.20"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.0"
# bundle exec rake doc:rails generates the API under doc/api.
gem "swagger-blocks"
gem "devise"
gem "jwt"
gem "dotenv-rails"

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug"
  gem "annotate"
  gem "rubocop", require: false
  gem "faker"
end

group :test do
  gem "rspec-rails"
  gem "factory_girl_rails", "~> 4.0"
  gem "database_cleaner"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem "web-console", "~> 2.0"

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
end

