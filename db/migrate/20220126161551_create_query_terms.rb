class CreateQueryTerms < ActiveRecord::Migration[7.0]
  def change
    create_table :query_terms do |t|
      t.string :field
      t.string :value

      t.timestamps
    end
  end
end
