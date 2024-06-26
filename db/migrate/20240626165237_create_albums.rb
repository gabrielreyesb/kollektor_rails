class CreateAlbums < ActiveRecord::Migration[7.1]
  def change
    create_table :albums do |t|
      t.string :name
      t.integer :year
      t.integer :genre_id
      t.integer :author_id

      t.timestamps
    end
  end
end
