class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token, if: proc { :bypass_auth? }
end
