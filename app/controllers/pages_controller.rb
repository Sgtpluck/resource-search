class PagesController < ApplicationController
  def home
    @results = AirtableSearch.new(params[:search]).find_resources
  end
end
