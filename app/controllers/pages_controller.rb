class PagesController < ApplicationController
  def home
    @search = formatted_search_params

    # TODO: use formatted_search_params in FullSearch
    @results = FullSearch.new(sources, search_params[:query]).find_resources
  end

  def redirect
    redirect_to root_path
  end

  private

  def formatted_search_params
    return {type: ["All"], source: ["All"]} if search_params[:query].empty?
    {
      type: search_params["query"]["type"]&.keep_if { |k, v| v == "1" }&.keys || ["All"],
      source: sources,
      description: search_params["query"]["description"]
    }
  end

  def search_params
    return {query: {}, source: {}} unless params[:search]

    params.require(:search).permit(source: {}, query: [:description, type: {}])
  end

  def sources
    search_params["source"]&.keep_if { |k, v| v == "1" }&.keys || ["All"]
  end
end
