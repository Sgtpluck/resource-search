class ApplicationController < ActionController::Base
  skip_forgery_protection if: -> { Rails.configuration.x.bypass_auth }
end
