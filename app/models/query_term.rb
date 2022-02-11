class QueryTerm < ApplicationRecord
  def self.description_by_count
    where(field: "Description").where.not(value: [nil, ""]).select("value").group(:value).order(count: :desc).count
  end

  def self.type_by_count
    where(field: "Type").select(:value).group(:value).order(count: :desc).count
  end
end
