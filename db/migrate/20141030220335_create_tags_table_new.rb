class CreateTagsTableNew < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :word

      t.timestamps
    end
  end
end
