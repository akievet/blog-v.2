class CreateImagesTable < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :name
      t.text :caption
      t.string :image_src
      t.boolean :main_image
      t.integer :post_id

      t.timestamps
    end
  end
end
