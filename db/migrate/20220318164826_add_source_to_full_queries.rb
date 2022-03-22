class AddSourceToFullQueries < ActiveRecord::Migration[7.0]
  def change
    add_column :full_queries, :data_source, :string, array: true
    remove_column :full_queries, :reuse, :string
  end
end
