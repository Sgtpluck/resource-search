class AnalyticsController < ApplicationController
  before_action :require_user!

  def index
    @query_data = QueryData.new
  end

  def require_user!
    return if helpers.user_signed_in?
    return if Rails.configuration.x.bypass_auth? == true
    redirect_to root_path
  end
end
