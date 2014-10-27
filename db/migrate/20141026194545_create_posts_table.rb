class CreatePostsTable < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :title
      t.text :subtitle
      t.text :body
      t.integer :user_id

      t.timestamps
    end
  end
end
