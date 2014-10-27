class CreateTagsTable < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :word
      t.integer :post_id

      t.timestamps
    end
  end
end
