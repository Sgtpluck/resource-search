class FullQuery < ApplicationRecord
  def create(description: "", reuse: "", kind: [])
    FullQuery.create(description, reuse, kind)
  end
end
