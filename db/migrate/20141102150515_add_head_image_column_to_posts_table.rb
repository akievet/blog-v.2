class AddHeadImageColumnToPostsTable < ActiveRecord::Migration
  def change
    add_column :posts, :head_img, :string, default: 'https://c715274.ssl.cf2.rackcdn.com/ckeditor_assets/pictures/501bab58960a562429000004/content_qs-icons-add.png'
  end
end
