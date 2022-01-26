class PagesController < ApplicationController
  def home
    @search = search_params
    @results = AirtableSearch.new(search_params).find_resources
  end

  private

  def search_params
    return {} unless params[:search]

    params.require(:search).permit!
  end
end
