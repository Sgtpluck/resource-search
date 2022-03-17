class FullQuery < ApplicationRecord
  def create(description: "", kind: [])
    FullQuery.create(description, kind)
  end
end
