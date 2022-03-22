class FullQuery < ApplicationRecord
  def create(description: "", kind: [], data_source: [])
    FullQuery.create(description, kind, data_source)
  end
end
