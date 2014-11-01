class CreateTagInstancesTable < ActiveRecord::Migration
  def change
    create_table :tag_instances do |t|
      t.integer :tag_id
      t.integer :post_id

      t.timestamps
    end
  end
end
