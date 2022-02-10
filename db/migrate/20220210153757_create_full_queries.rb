class CreateFullQueries < ActiveRecord::Migration[7.0]
  def change
    create_table :full_queries do |t|
      t.string :description
      t.string :reuse
      t.string :kind, array: true

      t.timestamps
    end
  end
end
