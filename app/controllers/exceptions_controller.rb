class ExceptionsController < ApplicationController
  def show
    render page, status: status_code
  end

  private

  def status_code
    params[:code] || 500
  end

  def page
    status_code.to_s
  end
end
