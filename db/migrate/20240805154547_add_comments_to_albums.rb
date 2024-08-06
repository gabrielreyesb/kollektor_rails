class AddCommentsToAlbums < ActiveRecord::Migration[7.1]
  def change
    add_column :albums, :comments, :text
  end
end
